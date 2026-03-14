package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    public Connection connection;

    public DBContext() {
        try {
            String host = util.ConfigUtils.DB_HOST;
            String port = util.ConfigUtils.DB_PORT;
            String dbName = util.ConfigUtils.DB_NAME;
            String user = util.ConfigUtils.DB_USER;
            String password = util.ConfigUtils.DB_PASS;

            String url = "jdbc:sqlserver://" + host + ":" + port
                    + ";databaseName=" + dbName
                    + ";encrypt=" + util.ConfigUtils.DB_ENCRYPT
                    + ";trustServerCertificate=" + util.ConfigUtils.DB_TRUST_SERVER_CERTIFICATE + ";";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, password);
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
}
