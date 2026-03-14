package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class StripeUtils {
    public static String createCheckoutSession(int bookingID, double amountVND, String ticketName) {
        if (ConfigUtils.STRIPE_SECRET_KEY == null || ConfigUtils.STRIPE_SECRET_KEY.isEmpty()) {
            return null;
        }

        try {
            URL url = new URL("https://api.stripe.com/v1/checkout/sessions");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");

            String auth = ConfigUtils.STRIPE_SECRET_KEY + ":";
            String encodedAuth = java.util.Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);

            StringBuilder params = new StringBuilder();
            params.append("success_url=").append(java.net.URLEncoder.encode(
                    ConfigUtils.APP_BASE_URL + "/stripe-success?bookingID=" + bookingID
                            + "&session_id={CHECKOUT_SESSION_ID}",
                    "UTF-8"));
            params.append("&cancel_url=").append(java.net.URLEncoder.encode(
                    ConfigUtils.APP_BASE_URL + "/payment?bookingID=" + bookingID,
                    "UTF-8"));
            params.append("&payment_method_types[0]=card");
            params.append("&mode=payment");
            params.append("&client_reference_id=").append(bookingID);
            params.append("&line_items[0][price_data][currency]=vnd");
            params.append("&line_items[0][price_data][product_data][name]=")
                    .append(java.net.URLEncoder.encode(ticketName, "UTF-8"));
            params.append("&line_items[0][price_data][unit_amount]=").append(String.format("%.0f", amountVND));
            params.append("&line_items[0][quantity]=1");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.toString().getBytes(StandardCharsets.UTF_8));
                os.flush();
            }

            int code = conn.getResponseCode();
            if (code == 200) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                    return extractJsonValue(response.toString(), "url");
                }
            } else {
                logErrorResponse(conn);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean isCheckoutSessionPaid(String sessionID, int bookingID) {
        if (sessionID == null || sessionID.isEmpty() || ConfigUtils.STRIPE_SECRET_KEY == null
                || ConfigUtils.STRIPE_SECRET_KEY.isEmpty()) {
            return false;
        }

        try {
            URL url = new URL("https://api.stripe.com/v1/checkout/sessions/" + sessionID);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            String auth = ConfigUtils.STRIPE_SECRET_KEY + ":";
            String encodedAuth = java.util.Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);

            if (conn.getResponseCode() != 200) {
                logErrorResponse(conn);
                return false;
            }

            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }

                String json = response.toString();
                String paymentStatus = extractJsonValue(json, "payment_status");
                String clientReferenceID = extractJsonValue(json, "client_reference_id");
                return "paid".equalsIgnoreCase(paymentStatus)
                        && String.valueOf(bookingID).equals(clientReferenceID);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    private static void logErrorResponse(HttpURLConnection conn) {
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            System.out.println("Stripe API Error: " + response);
        } catch (Exception ignored) {
        }
    }

    private static String extractJsonValue(String json, String key) {
        java.util.regex.Pattern pattern = java.util.regex.Pattern
                .compile("\"" + key + "\"\\s*:\\s*\"([^\"]+)\"");
        java.util.regex.Matcher matcher = pattern.matcher(json);
        return matcher.find() ? matcher.group(1) : null;
    }
}
