package util;

public class ConfigUtils {
    
    // STRIPE CONFIG
    public static final String STRIPE_PUBLIC_KEY = getEnv("STRIPE_PUBLIC_KEY", "pk_test_YOUR_STRIPE_PUBLIC_KEY");
    public static final String STRIPE_SECRET_KEY = getEnv("STRIPE_SECRET_KEY", "sk_test_YOUR_STRIPE_SECRET_KEY");
    
    // AWS DATABASE CONFIG
    public static final String DB_HOST = getEnv("DB_HOST", "localhost");
    public static final String DB_PORT = getEnv("DB_PORT", "1433");
    public static final String DB_NAME = getEnv("DB_NAME", "BusTicketDB");
    public static final String DB_USER = getEnv("DB_USER", "admin");
    public static final String DB_PASS = getEnv("DB_PASS", "2355");
    
    // APP CONFIG
    public static final String APP_BASE_URL = getEnv("APP_BASE_URL", "http://localhost:8080/BusTicketDev");

    public static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }
}
