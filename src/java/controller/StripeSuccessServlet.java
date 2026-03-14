package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.PaymentService;
import service.ServiceException;
import util.StripeUtils;

@WebServlet(name = "StripeSuccessServlet", urlPatterns = { "/stripe-success" })
public class StripeSuccessServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIDStr = request.getParameter("bookingID");
        String sessionID = request.getParameter("session_id");

        if (bookingIDStr == null || sessionID == null || sessionID.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIDStr);
            boolean paid = StripeUtils.isCheckoutSessionPaid(sessionID, bookingID);
            if (!paid) {
                response.sendRedirect("payment?bookingID=" + bookingID + "&error=StripeVerificationFailed");
                return;
            }

            paymentService.markBookingPaid(bookingID, "Stripe", sessionID);
            response.sendRedirect("ticket?id=" + bookingID);
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidBooking");
        } catch (ServiceException ex) {
            response.sendRedirect("payment?bookingID=" + bookingIDStr + "&error=StripeVerificationFailed");
        }
    }
}
