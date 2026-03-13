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
        String ticketCountStr = request.getParameter("ticketCount");

        if (origin == null || destination == null || date == null) {
            response.sendRedirect("home");
            return;
        }

        int ticketCount = 1;
        if (ticketCountStr != null && !ticketCountStr.isEmpty()) {
            try {
                ticketCount = Integer.parseInt(ticketCountStr);
            } catch (NumberFormatException e) {
                ticketCount = 1;
            }
        }

        TripDAO dao = new TripDAO();
        // Lấy chuyến đi
        List<Trip> outboundTrips = dao.searchTrips(origin, destination, date);
        if (outboundTrips.isEmpty()) {
            outboundTrips = dao.getAll(); // Gợi ý nếu không có chuyến
            request.setAttribute("isSuggestion", true);
        }
        request.setAttribute("trips", outboundTrips);

        // Lấy chuyến về nếu là Khứ hồi
        if ("roundTrip".equals(tripType) && returnDate != null && !returnDate.isEmpty()) {
            List<Trip> returnTrips = dao.searchTrips(destination, origin, returnDate);
            request.setAttribute("returnTrips", returnTrips);
            request.setAttribute("searchReturnDate", returnDate);
        }

        request.setAttribute("searchDate", date);
        request.setAttribute("searchOrigin", origin);
        request.setAttribute("searchDest", destination);
        request.setAttribute("tripType", tripType);
        request.setAttribute("ticketCount", ticketCount);

        request.getRequestDispatcher("views/public/trip-result.jsp").forward(request, response);
    }
}
