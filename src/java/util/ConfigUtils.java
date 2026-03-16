package util;

import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class ConfigUtils {
    private static final String LOCAL_SECRETS_PATH_PROPERTY = "local.secrets.file";
    private static final String LOCAL_SECRETS_ENV = "LOCAL_SECRETS_FILE";
    private static final Properties LOCAL_PROPERTIES = loadLocalProperties();
    private static final String CLASSPATH_SECRETS_RESOURCE = "local-secrets.properties";

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

    // Z.AI CONFIG
    public static final String ZAI_API_URL = getEnv("ZAI_API_URL", "https://api.z.ai/api/paas/v4/chat/completions");
    public static final String ZAI_API_KEY = getEnv("ZAI_API_KEY", "");
    public static final String ZAI_MODEL = getEnv("ZAI_MODEL", "glm-4.7-flash");

    // MAIL CONFIG
    public static final String MAIL_SMTP_HOST = getEnv("MAIL_SMTP_HOST", "smtp.gmail.com");
    public static final String MAIL_SMTP_PORT = getEnv("MAIL_SMTP_PORT", "587");
    public static final String MAIL_SMTP_USERNAME = getEnv("MAIL_SMTP_USERNAME", "");
    public static final String MAIL_SMTP_PASSWORD = getEnv("MAIL_SMTP_PASSWORD", "");
    public static final String MAIL_FROM = getEnv("MAIL_FROM", MAIL_SMTP_USERNAME);
    public static final String MAIL_FROM_NAME = getEnv("MAIL_FROM_NAME", "Fuda Bus");
    public static final String MAIL_REPLY_TO = getEnv("MAIL_REPLY_TO", MAIL_FROM);
    public static final boolean MAIL_ENABLED = Boolean.parseBoolean(getEnv("MAIL_ENABLED", "false"));

    public static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value != null && !value.trim().isEmpty()) {
            return value;
        }

        String localValue = LOCAL_PROPERTIES.getProperty(key);
        if (localValue != null && !localValue.trim().isEmpty()) {
            return localValue.trim();
        }

        return defaultValue;
    }

    private static Properties loadLocalProperties() {
        Properties properties = new Properties();
        loadFromClasspath(properties);
        loadFromFile(properties, resolveLocalSecretsPath());
        return properties;
    }

    private static void loadFromClasspath(Properties properties) {
        try (InputStream inputStream = ConfigUtils.class.getClassLoader().getResourceAsStream(CLASSPATH_SECRETS_RESOURCE)) {
            if (inputStream != null) {
                properties.load(inputStream);
            }
        } catch (IOException ex) {
            System.err.println("Unable to load packaged secrets file: " + ex.getMessage());
        }
    }

    private static void loadFromFile(Properties properties, Path configPath) {
        if (configPath == null || !Files.isRegularFile(configPath)) {
            return;
        }

        try (InputStream inputStream = Files.newInputStream(configPath)) {
            properties.load(inputStream);
        } catch (IOException ex) {
            System.err.println("Unable to load local secrets file: " + ex.getMessage());
        }
    }

    private static Path resolveLocalSecretsPath() {
        String explicitPath = System.getProperty(LOCAL_SECRETS_PATH_PROPERTY);
        if (explicitPath == null || explicitPath.trim().isEmpty()) {
            explicitPath = System.getenv(LOCAL_SECRETS_ENV);
        }

        if (explicitPath != null && !explicitPath.trim().isEmpty()) {
            return Paths.get(explicitPath.trim());
        }

        for (Path candidate : getDefaultSecretCandidates()) {
            if (Files.isRegularFile(candidate)) {
                return candidate;
            }
        }
        return null;
    }

    private static List<Path> getDefaultSecretCandidates() {
        List<Path> candidates = new ArrayList<>();
        candidates.add(Paths.get(System.getProperty("user.dir"), "conf", "local-secrets.properties"));
        candidates.add(Paths.get("conf", "local-secrets.properties").toAbsolutePath().normalize());

        try {
            Path classLocation = Paths.get(ConfigUtils.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            Path current = Files.isDirectory(classLocation) ? classLocation : classLocation.getParent();
            for (int i = 0; current != null && i < 6; i++) {
                candidates.add(current.resolve("conf").resolve("local-secrets.properties").normalize());
                current = current.getParent();
            }
        } catch (URISyntaxException | RuntimeException ignored) {
        }

        return candidates;
    }
}
