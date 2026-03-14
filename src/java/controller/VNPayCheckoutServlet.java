package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;
import service.BookingAccessService;
import service.PaymentService;
import service.ServiceException;
import util.VNPayUtils;

@WebServlet(name = "VNPayCheckoutServlet", urlPatterns = { "/vnpay-checkout" })
public class VNPayCheckoutServlet extends HttpServlet {
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

            long amount = Math.round(paymentService.getBookingAmount(bookingID) * 100);
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String vnp_OrderInfo = "Thanh toan ve xe don hang: " + bookingIDStr;
            String orderType = "other";
            String vnp_TxnRef = bookingIDStr + "_" + System.currentTimeMillis();
            String vnp_IpAddr = "127.0.0.1";
            String vnp_TmnCode = VNPayUtils.vnp_TmnCode;

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", orderType);
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", VNPayUtils.vnp_Returnurl);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));

            cld.add(Calendar.MINUTE, 15);
            vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

            String hashData = VNPayUtils.hashAllFields(vnp_Params);
            StringBuilder queryUrl = new StringBuilder();

            java.util.List<String> fieldNames = new java.util.ArrayList<>(vnp_Params.keySet());
            java.util.Collections.sort(fieldNames);

            boolean first = true;
            for (String fieldName : fieldNames) {
                String fieldValue = vnp_Params.get(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()) {
                    if (!first) {
                        queryUrl.append("&");
                    }
                    queryUrl.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()))
                            .append("=")
                            .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    first = false;
                }
            }
            queryUrl.append("&vnp_SecureHash=").append(hashData);
            response.sendRedirect(VNPayUtils.vnp_PayUrl + "?" + queryUrl);
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidBooking");
        } catch (ServiceException ex) {
            response.sendRedirect("payment?bookingID=" + bookingIDStr + "&error=VNPayFailed");
        }
    }
}
