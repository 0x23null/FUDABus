package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DatabaseMigration {
    public static void main(String[] args) {
        migrate();
    }

    public static void migrate() {
        DBContext db = new DBContext();
        try {
            Connection conn = db.connection;

            // 1. Add ticketCode column
            String sql1 = "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'ticketCode') "
                    +
                    "BEGIN " +
                    "    ALTER TABLE Bookings ADD ticketCode VARCHAR(50); " +
                    "END";

            PreparedStatement st = conn.prepareStatement(sql1);
            st.executeUpdate();
            System.out.println("Migration applied: Added ticketCode to Bookings.");

        } catch (SQLException e) {
            System.out.println("Migration Error: " + e.getMessage());
        }
    }
}
