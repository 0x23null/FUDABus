package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    public Connection connection;

    public DBContext() {
        try {
            if (isBlank(util.ConfigUtils.DB_HOST)
                    || isBlank(util.ConfigUtils.DB_NAME)
                    || isBlank(util.ConfigUtils.DB_USER)) {
                System.err.println("Missing database configuration. Please set DB_HOST, DB_NAME, DB_USER, and DB_PASS.");
                return;
            }

            String url = "jdbc:sqlserver://" + util.ConfigUtils.DB_HOST + ":" + util.ConfigUtils.DB_PORT
                    + ";databaseName=" + util.ConfigUtils.DB_NAME
                    + ";encrypt=" + util.ConfigUtils.DB_ENCRYPT
                    + ";trustServerCertificate=" + util.ConfigUtils.DB_TRUST_SERVER_CERTIFICATE + ";";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, util.ConfigUtils.DB_USER, util.ConfigUtils.DB_PASS);
        } catch (ClassNotFoundException | SQLException ex) {
            System.err.println("Error connecting to database: " + ex.getMessage());
        }
    }

    public static void main(String[] args) {
        DBContext db = new DBContext();
        if (db.connection != null) {
            System.out.println("Connection successful!");
        } else {
            System.out.println("Connection failed!");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
