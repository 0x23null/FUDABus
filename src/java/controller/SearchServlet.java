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

        if (origin == null || destination == null || date == null) {
            response.sendRedirect("home");
            return;
        }

        TripDAO dao = new TripDAO();
        List<Trip> list = dao.searchTrips(origin, destination, date);

        if (list.isEmpty()) {
            list = dao.getAll(); // Fallback to show all trips
            request.setAttribute("isSuggestion", true);
        }

        request.setAttribute("trips", list);
        request.setAttribute("searchDate", date);
        request.setAttribute("searchOrigin", origin);
        request.setAttribute("searchDest", destination);

        request.getRequestDispatcher("views/public/trip-result.jsp").forward(request, response);
    }
}
