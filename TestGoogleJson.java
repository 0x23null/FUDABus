public class TestGoogleJson {
    public static void main(String[] args) {
        String json = "{\n" +
                "  \"access_token\": \"ya29.a0AcM612x...\",\n" +
                "  \"expires_in\": 3599,\n" +
                "  \"scope\": \"https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email\",\n" +
                "  \"token_type\": \"Bearer\",\n" +
                "  \"id_token\": \"eyJhbGciOiJSUz...\"\n" +
                "}";

        System.out.println("Extracted: " + extractJsonValue(json, "access_token"));
    }

    private static String extractJsonValue(String json, String key) {
        try {
            String pattern = "\"" + key + "\":\\s*\"";
            int start = json.indexOf(pattern);
            if (start == -1) {
                // Try without quotes for numbers/booleans but here we usually expect strings
                System.out.println("Pattern not found: " + pattern);
                
                // Let's try alternative pattern since Google might return access_token without spacing
                pattern = "\"" + key + "\":\"";
                start = json.indexOf(pattern);
                if (start == -1) return null;
            }
            start += pattern.length();
            int end = json.indexOf("\"", start);
            return json.substring(start, end);
        } catch (Exception e) {
            return null;
        }
    }
}
