package dal;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import model.User;
import util.ConfigUtils;

public class GoogleUtils {

    public static final String GOOGLE_CLIENT_ID = ConfigUtils.GOOGLE_CLIENT_ID;
    public static final String GOOGLE_CLIENT_SECRET = ConfigUtils.GOOGLE_CLIENT_SECRET;
    public static final String GOOGLE_REDIRECT_URI = ConfigUtils.GOOGLE_REDIRECT_URI;
    // END CONSTANTS

    public static final String GOOGLE_LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    public static final String GOOGLE_GRANT_TYPE = "authorization_code";

    public static String getLoginURL() {
        return "https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri="
                + GOOGLE_REDIRECT_URI + "&response_type=code&client_id=" + GOOGLE_CLIENT_ID + "&approval_prompt=force";
    }

    public static String getToken(String code) throws IOException {
        URL url = new URL(GOOGLE_LINK_GET_TOKEN);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        String params = "code=" + code +
                "&client_id=" + GOOGLE_CLIENT_ID +
                "&client_secret=" + GOOGLE_CLIENT_SECRET +
                "&redirect_uri=" + GOOGLE_REDIRECT_URI +
                "&grant_type=" + GOOGLE_GRANT_TYPE;

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes());
            os.flush();
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                // Check if we have Gson, otherwise Simple Parse
                // Assuming simple parse for "access_token"
                return extractJsonValue(response.toString(), "access_token");
            }
        }
        return null;
    }

    public static User getUserInfo(String accessToken) throws IOException {
        URL url = new URL(GOOGLE_LINK_GET_USER_INFO + accessToken);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                String json = response.toString();
                String email = extractJsonValue(json, "email");
                String name = extractJsonValue(json, "name");
                String id = extractJsonValue(json, "id");

                User u = new User();
                u.setEmail(email);
                u.setFullName(name);
                u.setUsername("google_" + id); // Temporary username
                return u;
            }
        }
        return null;
    }

    // Simple JSON value extractor
    private static String extractJsonValue(String json, String key) {
        try {
            // Using regex to safely find the value ignoring whitespaces
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\"" + key + "\"\\s*:\\s*\"([^\"]+)\"");
            java.util.regex.Matcher matcher = pattern.matcher(json);
            if (matcher.find()) {
                return matcher.group(1);
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }
}
