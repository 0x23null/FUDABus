package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;
import service.BookingAccessService;
import service.PaymentService;

@WebServlet(name = "TicketServlet", urlPatterns = { "/ticket" })
public class TicketServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            Booking booking = paymentService.getBookingDetails(bookingID);
            if (booking == null) {
                response.sendRedirect("home");
                return;
            }

            if (!BookingAccessService.canAccessBooking(request.getSession(), booking)) {
                if (request.getSession().getAttribute("user") == null && !BookingAccessService.isGuestBooking(booking)) {
                    BookingAccessService.rememberRedirectAfterLogin(request);
                    response.sendRedirect("login?error=LoginRequired");
                } else {
                    response.sendRedirect("home?error=AccessDenied");
                }
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("views/public/ticket.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidBooking");
        }
    }
}
