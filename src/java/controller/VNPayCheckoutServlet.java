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
import util.VNPayUtils;

@WebServlet(name = "VNPayCheckoutServlet", urlPatterns = { "/vnpay-checkout" })
public class VNPayCheckoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIDStr = request.getParameter("bookingID");
        String amountStr = request.getParameter("amount");

        if (bookingIDStr == null || amountStr == null) {
            response.sendRedirect("home");
            return;
        }

        long amount = (long) (Double.parseDouble(amountStr) * 100); // VNPay requires amount * 100

        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_OrderInfo = "Thanh toan ve xe don hang: " + bookingIDStr;
        String orderType = "other";
        String vnp_TxnRef = bookingIDStr + "_" + System.currentTimeMillis();
        String vnp_IpAddr = "127.0.0.1"; // Default IP for local, in prod get from request
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
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        String hashData = VNPayUtils.hashAllFields(vnp_Params);
        String queryUrl = "";
        
        java.util.List<String> fieldNames = new java.util.ArrayList<>(vnp_Params.keySet());
        java.util.Collections.sort(fieldNames);
        
        boolean first = true;
        for (String fieldName : fieldNames) {
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                if (!first) {
                    queryUrl += "&";
                }
                queryUrl += URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()) + "="
                        + URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                first = false;
            }
        }
        queryUrl += "&vnp_SecureHash=" + hashData;
        String paymentUrl = VNPayUtils.vnp_PayUrl + "?" + queryUrl;

        response.sendRedirect(paymentUrl);
    }
}
