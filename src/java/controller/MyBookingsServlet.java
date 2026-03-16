package controller;

import dal.BookingDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;

@WebServlet(name = "MyBookingsServlet", urlPatterns = { "/history" })
public class MyBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        BookingDAO dao = new BookingDAO();
        List<Booking> bookingSummaries = dao.getBookingsByUserID(user.getUserID());
        List<Booking> bookings = new ArrayList<>();
        for (Booking booking : bookingSummaries) {
            Booking fullBooking = dao.getBookingFullDetails(booking.getBookingID());
            bookings.add(fullBooking != null ? fullBooking : booking);
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("views/public/my-bookings.jsp").forward(request, response);
    }
}
