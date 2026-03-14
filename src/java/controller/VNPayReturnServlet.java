package controller;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.PaymentService;
import service.ServiceException;
import util.VNPayUtils;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = { "/vnpay-return" })
public class VNPayReturnServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        String secureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        String signValue = VNPayUtils.hashAllFields(fields);
        String txnRef = request.getParameter("vnp_TxnRef");
        int bookingID = extractBookingID(txnRef);

        if (bookingID <= 0) {
            response.sendRedirect("home?error=InvalidBooking");
            return;
        }

        if (!signValue.equals(secureHash)) {
            response.sendRedirect("payment?bookingID=" + bookingID + "&error=InvalidHash");
            return;
        }

        try {
            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                paymentService.markBookingPaid(bookingID, "VNPay", txnRef);
                response.sendRedirect("ticket?id=" + bookingID);
                return;
            }

            paymentService.recordFailedPayment(bookingID, "VNPay", txnRef);
            response.sendRedirect("payment?bookingID=" + bookingID + "&error=PaymentFailed");
        } catch (ServiceException ex) {
            response.sendRedirect("payment?bookingID=" + bookingID + "&error=PaymentFailed");
        }
    }

    private int extractBookingID(String txnRef) {
        if (txnRef == null || txnRef.trim().isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(txnRef.split("_")[0]);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }
}
