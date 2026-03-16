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
        Connection conn = db.connection;
        if (conn == null) {
            System.out.println("Migration skipped: database connection is unavailable.");
            return;
        }

        try {
            removeLegacyBookingDetails(conn);
            ensureBookingColumns(conn);
            ensureBookingTables(conn);
            ensureIndexes(conn);
        } catch (SQLException e) {
            System.out.println("Migration Error: " + e.getMessage());
        }
    }

    private static void removeLegacyBookingDetails(Connection conn) throws SQLException {
        execute(conn,
                "IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BookingDetails]') AND type in (N'U')) "
                + "BEGIN DROP TABLE BookingDetails; END");
    }

    private static void ensureBookingColumns(Connection conn) throws SQLException {
        execute(conn,
                "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'ticketCode') "
                + "BEGIN ALTER TABLE Bookings ADD ticketCode VARCHAR(50); END");

        execute(conn,
                "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'tripType') "
                + "BEGIN ALTER TABLE Bookings ADD tripType NVARCHAR(20) DEFAULT 'OneWay'; END");

        execute(conn,
                "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'adultCount') "
                + "BEGIN ALTER TABLE Bookings ADD adultCount INT DEFAULT 1; END");

        execute(conn,
                "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'childCount') "
                + "BEGIN ALTER TABLE Bookings ADD childCount INT DEFAULT 0; END");

        execute(conn,
                "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Bookings' AND COLUMN_NAME = 'qrCodeURL') "
                + "BEGIN ALTER TABLE Bookings ADD qrCodeURL NVARCHAR(255); END");
    }

    private static void ensureBookingTables(Connection conn) throws SQLException {
        execute(conn,
                "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BookingSegments]') AND type in (N'U')) "
                + "BEGIN "
                + "CREATE TABLE BookingSegments ("
                + "segmentID INT IDENTITY(1,1) PRIMARY KEY,"
                + "bookingID INT NOT NULL FOREIGN KEY REFERENCES Bookings(bookingID) ON DELETE CASCADE,"
                + "tripID INT NOT NULL FOREIGN KEY REFERENCES Trips(tripID),"
                + "segmentType NVARCHAR(20) NOT NULL,"
                + "segmentOrder INT NOT NULL,"
                + "segmentPrice DECIMAL(18,2) NOT NULL"
                + "); END");

        execute(conn,
                "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BookingPassengers]') AND type in (N'U')) "
                + "BEGIN "
                + "CREATE TABLE BookingPassengers ("
                + "passengerID INT IDENTITY(1,1) PRIMARY KEY,"
                + "bookingID INT NOT NULL FOREIGN KEY REFERENCES Bookings(bookingID) ON DELETE CASCADE,"
                + "passengerType NVARCHAR(20) NOT NULL,"
                + "displayLabel NVARCHAR(100)"
                + "); END");

        execute(conn,
                "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BookingSegmentSeats]') AND type in (N'U')) "
                + "BEGIN "
                + "CREATE TABLE BookingSegmentSeats ("
                + "bookingSegmentSeatID INT IDENTITY(1,1) PRIMARY KEY,"
                + "segmentID INT NOT NULL FOREIGN KEY REFERENCES BookingSegments(segmentID) ON DELETE CASCADE,"
                + "passengerID INT NULL FOREIGN KEY REFERENCES BookingPassengers(passengerID),"
                + "seatNumber NVARCHAR(10) NOT NULL,"
                + "price DECIMAL(18,2) NOT NULL"
                + "); END");
    }

    private static void ensureIndexes(Connection conn) throws SQLException {
        execute(conn,
                "IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'UX_BookingSegmentSeats_Segment_Seat' AND object_id = OBJECT_ID('BookingSegmentSeats')) "
                + "BEGIN CREATE UNIQUE INDEX UX_BookingSegmentSeats_Segment_Seat ON BookingSegmentSeats(segmentID, seatNumber); END");
    }

    private static void execute(Connection conn, String sql) throws SQLException {
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.executeUpdate();
        }
    }
}

