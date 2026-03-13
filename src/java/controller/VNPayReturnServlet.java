package controller;

import dal.DBContext;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.PreparedStatement;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.VNPayUtils;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = { "/vnpay-return" })
public class VNPayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        String signValue = VNPayUtils.hashAllFields(fields);
        String txnRef = request.getParameter("vnp_TxnRef");
        int bookingID = 0;
        try {
            bookingID = Integer.parseInt(txnRef.split("_")[0]);
        } catch (Exception e) {}

        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                // Success
                updateBookingStatus(bookingID, "Paid");
                response.sendRedirect("ticket?id=" + bookingID);
            } else {
                // Failed
                updateBookingStatus(bookingID, "Payment Failed");
                response.sendRedirect("payment?bookingID=" + bookingID + "&error=PaymentFailed");
            }
        } else {
            // Invalid Signature
            response.sendRedirect("payment?bookingID=" + bookingID + "&error=InvalidHash");
        }
    }

    private void updateBookingStatus(int bookingID, String status) {
        DBContext db = new DBContext();
        try {
            String sql = "UPDATE Bookings SET status = ? WHERE bookingID = ?";
            PreparedStatement st = db.connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, bookingID);
            st.executeUpdate();

            if ("Paid".equals(status)) {
                String sqlPay = "INSERT INTO Payments (bookingID, amount, paymentMethod, status) VALUES (?, (SELECT totalPrice FROM Bookings WHERE bookingID = ?), 'VNPay', 'Success')";
                PreparedStatement st2 = db.connection.prepareStatement(sqlPay);
                st2.setInt(1, bookingID);
                st2.setInt(2, bookingID);
                st2.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
