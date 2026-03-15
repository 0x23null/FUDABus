package controller;

import dal.TripDAO;
import model.Trip;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SearchServlet", urlPatterns = { "/search" })
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String date = request.getParameter("date");
        String tripType = request.getParameter("tripType");
        String returnDate = request.getParameter("returnDate");
        String selectedOutboundID = request.getParameter("selectedOutboundID");
        int adultCount = parseCount(request.getParameter("adultCount"), 1);
        int childCount = parseCount(request.getParameter("childCount"), 0);

        if (origin == null || destination == null || date == null || origin.isBlank() || destination.isBlank()) {
            response.sendRedirect("home");
            return;
        }

        if (adultCount < 1) {
            adultCount = 1;
        }
        if (childCount < 0) {
            childCount = 0;
        }

        TripDAO dao = new TripDAO();
        List<Trip> outboundTrips = dao.searchTrips(origin, destination, date);
        boolean isSuggestion = false;
        if (outboundTrips.isEmpty()) {
            outboundTrips = dao.searchUpcomingTripsByRoute(origin, destination);
            if (!outboundTrips.isEmpty()) {
                isSuggestion = true;
            }
        }
        request.setAttribute("trips", outboundTrips);

        if ("roundTrip".equals(tripType) && returnDate != null && !returnDate.isBlank()) {
            List<Trip> returnTrips = dao.searchTrips(destination, origin, returnDate);
            if (returnTrips.isEmpty()) {
                returnTrips = dao.searchUpcomingTripsByRoute(destination, origin);
                if (!returnTrips.isEmpty()) {
                    isSuggestion = true;
                }
            }
            request.setAttribute("returnTrips", returnTrips);
            request.setAttribute("searchReturnDate", returnDate);
        }

        if (selectedOutboundID != null && !selectedOutboundID.isBlank()) {
            try {
                int outboundTripID = Integer.parseInt(selectedOutboundID);
                request.setAttribute("selectedOutboundID", outboundTripID);
                request.setAttribute("selectedOutboundTrip", dao.getTripByID(outboundTripID));
            } catch (NumberFormatException ignored) {
            }
        }

        request.setAttribute("searchDate", date);
        request.setAttribute("searchOrigin", origin);
        request.setAttribute("searchDest", destination);
        request.setAttribute("tripType", tripType);
        request.setAttribute("adultCount", adultCount);
        request.setAttribute("childCount", childCount);
        request.setAttribute("passengerCount", adultCount + childCount);
        request.setAttribute("currentTimeMillis", System.currentTimeMillis());
        request.setAttribute("isSuggestion", isSuggestion);

        request.getRequestDispatcher("views/public/trip-result.jsp").forward(request, response);
    }

    private int parseCount(String raw, int fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
