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
import service.ServiceException;
import util.StripeUtils;

@WebServlet(name = "StripeCheckoutServlet", urlPatterns = { "/stripe-checkout" })
public class StripeCheckoutServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
                response.sendRedirect("home?error=AccessDenied");
                return;
            }

            double amount = paymentService.getBookingAmount(bookingID);
            String checkoutUrl = StripeUtils.createCheckoutSession(bookingID, amount, "Bus Ticket #" + bookingID);
            if (checkoutUrl != null) {
                response.sendRedirect(checkoutUrl);
                return;
            }

            response.sendRedirect("payment?bookingID=" + bookingID + "&error=StripeFailed");
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidBooking");
        } catch (ServiceException ex) {
            response.sendRedirect("payment?bookingID=" + bookingIDStr + "&error=StripeFailed");
        }
    }
}
