package util;

public class ConfigUtils {

    // STRIPE CONFIG
    public static final String STRIPE_PUBLIC_KEY = getEnv("STRIPE_PUBLIC_KEY", "");
    public static final String STRIPE_SECRET_KEY = getEnv("STRIPE_SECRET_KEY", "");

    // DATABASE CONFIG
    public static final String DB_HOST = getEnv("DB_HOST", "localhost");
    public static final String DB_PORT = getEnv("DB_PORT", "1433");
    public static final String DB_NAME = getEnv("DB_NAME", "BusTicketDB");
    public static final String DB_USER = getEnv("DB_USER", "sa");
    public static final String DB_PASS = getEnv("DB_PASS", "");
    public static final String DB_ENCRYPT = getEnv("DB_ENCRYPT", "true");
    public static final String DB_TRUST_SERVER_CERTIFICATE = getEnv("DB_TRUST_SERVER_CERTIFICATE", "true");

    // GOOGLE OAUTH CONFIG
    public static final String GOOGLE_CLIENT_ID = getEnv("GOOGLE_CLIENT_ID", "");
    public static final String GOOGLE_CLIENT_SECRET = getEnv("GOOGLE_CLIENT_SECRET", "");

    // VNPAY CONFIG
    public static final String VNPAY_TMN_CODE = getEnv("VNPAY_TMN_CODE", "");
    public static final String VNPAY_SECRET_KEY = getEnv("VNPAY_SECRET_KEY", "");
    public static final String VNPAY_RETURN_URL = getEnv("VNPAY_RETURN_URL", "");

    // APP CONFIG
    public static final String APP_BASE_URL = getEnv("APP_BASE_URL", "http://localhost:8080/BusTicketDev");
    public static final String GOOGLE_REDIRECT_URI = getEnv("GOOGLE_REDIRECT_URI", APP_BASE_URL + "/login-google-callback");

    public static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }
}
