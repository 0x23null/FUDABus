package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import service.BookingAccessService;
import service.PaymentService;
import service.ServiceException;

@WebServlet(name = "PaymentServlet", urlPatterns = { "/payment", "/payment/confirm" })
public class PaymentServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIDStr = request.getParameter("bookingID");
        if (bookingIDStr == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDStr);
            Booking booking = paymentService.getBookingDetails(bookingID);
            if (booking == null) {
                response.sendRedirect("home");
                return;
            }

            if (!BookingAccessService.canAccessBooking(request.getSession(), booking)) {
                handleUnauthorizedAccess(request, response, booking);
                return;
            }

            if ("Paid".equalsIgnoreCase(booking.getStatus())) {
                response.sendRedirect("ticket?id=" + bookingID);
                return;
            }

            request.setAttribute("booking", booking);
            request.setAttribute("amount", booking.getTotalPrice());
            request.setAttribute("bookingID", bookingID);
            request.getRequestDispatcher("views/public/payment.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidBooking");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String bookingIDStr = request.getParameter("bookingID");
        if (bookingIDStr == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDStr);
            Booking booking = paymentService.getBookingDetails(bookingID);
            if (booking == null) {
                response.sendRedirect("home");
                return;
            }

            if (!BookingAccessService.canAccessBooking(request.getSession(), booking)) {
                handleUnauthorizedAccess(request, response, booking);
                return;
            }

            if ("cancel".equals(action)) {
                boolean cancelled = paymentService.cancelPendingBooking(bookingID);
                if (cancelled) {
                    response.sendRedirect("home?msg=BookingCancelled");
                } else {
                    response.sendRedirect("payment?bookingID=" + bookingID + "&error=CannotCancel");
                }
                return;
            }

            response.sendRedirect("payment?bookingID=" + bookingID + "&error=UnsupportedPaymentFlow");
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidBooking");
        } catch (ServiceException ex) {
            response.sendRedirect("payment?bookingID=" + bookingIDStr + "&error=PaymentActionFailed");
        }
    }

    private void handleUnauthorizedAccess(HttpServletRequest request, HttpServletResponse response, Booking booking)
            throws IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null && !BookingAccessService.isGuestBooking(booking)) {
            BookingAccessService.rememberRedirectAfterLogin(request);
            response.sendRedirect("login?error=LoginRequired");
            return;
        }
        response.sendRedirect("home?error=AccessDenied");
    }
}
