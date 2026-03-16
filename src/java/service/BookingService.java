package service;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import model.Trip;
import model.User;
import util.FarePolicy;
import util.PasswordUtils;

public class BookingService {

    public BookingCreationResult createBooking(User user, int tripID, Integer returnTripID,
            int adultCount, int childCount,
            String selectedSeats, String returnSeats, String guestName, String guestPhone, String guestEmail)
            throws ServiceException {
        String[] outboundSeatArray = normalizeSeats(selectedSeats);
        String[] returnSeatArray = normalizeSeats(returnSeats);
        int passengerCount = adultCount + childCount;

        if (adultCount < 1) {
            throw new ServiceException("Can it nhat mot nguoi lon cho moi don dat ve.");
        }
        if (childCount < 0) {
            throw new ServiceException("So luong tre em khong hop le.");
        }
        if (passengerCount <= 0) {
            throw new ServiceException("Vui long chon it nhat mot hanh khach.");
        }
        if (outboundSeatArray.length != passengerCount) {
            throw new ServiceException("Vui long chon dung " + passengerCount + " ghe cho chuyen di.");
        }
        if (returnTripID != null && returnTripID == tripID) {
            throw new ServiceException("Chuyen di va chuyen ve khong duoc trung nhau.");
        }

        DBContext db = new DBContext();
        Connection connection = db.connection;
        if (connection == null) {
            throw new ServiceException("Khong the ket noi co so du lieu.");
        }

        boolean previousAutoCommit = true;
        try {
            previousAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            List<Integer> tripIdsToLock = new ArrayList<>();
            tripIdsToLock.add(tripID);
            if (returnTripID != null && !returnTripID.equals(tripID)) {
                tripIdsToLock.add(returnTripID);
            }
            Collections.sort(tripIdsToLock);
            for (Integer lockedTripId : tripIdsToLock) {
                lockTrip(connection, lockedTripId);
            }

            Trip outboundTrip = loadTrip(connection, tripID);
            validateTrip(outboundTrip);
            validateSeatsAvailable(connection, tripID, outboundSeatArray);

            Trip returnTrip = null;
            if (returnTripID != null) {
                if (returnSeatArray.length != passengerCount) {
                    throw new ServiceException("Vui long chon dung " + passengerCount + " ghe cho chuyen ve.");
                }
                returnTrip = loadTrip(connection, returnTripID);
                validateTrip(returnTrip);
                validateSeatsAvailable(connection, returnTripID, returnSeatArray);
            }

            int bookingUserID = user != null
                    ? user.getUserID()
                    : createGuestUser(connection, guestName, guestPhone, guestEmail);

            double totalPrice = FarePolicy.calculateSegmentTotal(outboundTrip.getPrice(), adultCount, childCount);
            if (returnTrip != null) {
                totalPrice += FarePolicy.calculateSegmentTotal(returnTrip.getPrice(), adultCount, childCount);
            }

            int bookingID = insertBooking(connection, tripID, bookingUserID, totalPrice, createTicketCode(),
                    returnTrip == null ? "OneWay" : "RoundTrip", adultCount, childCount);
            List<Integer> passengerIds = insertPassengers(connection, bookingID, adultCount, childCount);

            int outboundSegmentID = insertSegment(connection, bookingID, tripID, "OUTBOUND", 1, outboundTrip.getPrice());
            insertSegmentSeats(connection, outboundSegmentID, passengerIds, adultCount, outboundTrip.getPrice(), outboundSeatArray);

            if (returnTrip != null) {
                int returnSegmentID = insertSegment(connection, bookingID, returnTripID, "RETURN", 2, returnTrip.getPrice());
                insertSegmentSeats(connection, returnSegmentID, passengerIds, adultCount, returnTrip.getPrice(), returnSeatArray);
            }

            connection.commit();
            return new BookingCreationResult(bookingID, totalPrice, user == null);
        } catch (SQLException ex) {
            rollbackQuietly(connection);
            throw new ServiceException("Dat ve that bai. Vui long thu lai.", ex);
        } finally {
            restoreAutoCommit(connection, previousAutoCommit);
            closeQuietly(connection);
        }
    }

    private String[] normalizeSeats(String seats) {
        if (seats == null || seats.trim().isEmpty()) {
            return new String[0];
        }

        String[] splitSeats = seats.split(",");
        Set<String> uniqueSeats = new LinkedHashSet<>();
        for (String seat : splitSeats) {
            String normalizedSeat = seat == null ? "" : seat.trim().toUpperCase();
            if (!normalizedSeat.isEmpty()) {
                uniqueSeats.add(normalizedSeat);
            }
        }
        return uniqueSeats.toArray(new String[0]);
    }

    private void lockTrip(Connection connection, int tripID) throws SQLException, ServiceException {
        String sql = "SELECT tripID FROM Trips WITH (UPDLOCK, HOLDLOCK) WHERE tripID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, tripID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new ServiceException("Khong tim thay chuyen xe.");
                }
            }
        }
    }

    private Trip loadTrip(Connection connection, int tripID) throws SQLException, ServiceException {
        String sql = "SELECT tripID, departureTime, price, status FROM Trips WHERE tripID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, tripID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new ServiceException("Khong tim thay chuyen xe.");
                }

                Trip trip = new Trip();
                trip.setTripID(resultSet.getInt("tripID"));
                trip.setDepartureTime(resultSet.getTimestamp("departureTime"));
                trip.setPrice(resultSet.getDouble("price"));
                trip.setStatus(resultSet.getString("status"));
                return trip;
            }
        }
    }

    private void validateTrip(Trip trip) throws ServiceException {
        if (trip == null) {
            throw new ServiceException("Khong tim thay chuyen xe.");
        }
        if (!"Scheduled".equalsIgnoreCase(trip.getStatus())) {
            throw new ServiceException("Chuyen xe nay hien khong the dat.");
        }
        if (trip.getDepartureTime() == null || trip.getDepartureTime().before(new Timestamp(System.currentTimeMillis()))) {
            throw new ServiceException("Chuyen xe nay da qua gio khoi hanh.");
        }
    }

    private void validateSeatsAvailable(Connection connection, int tripID, String[] seats)
            throws SQLException, ServiceException {
        String sql = "SELECT COUNT(*) FROM BookingSegmentSeats bss "
                + "JOIN BookingSegments bs ON bss.segmentID = bs.segmentID "
                + "JOIN Bookings b ON bs.bookingID = b.bookingID "
                + "WHERE bs.tripID = ? AND bss.seatNumber = ? AND b.status IN ('Pending', 'Paid')";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (String seat : seats) {
                statement.setInt(1, tripID);
                statement.setString(2, seat);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next() && resultSet.getInt(1) > 0) {
                        throw new ServiceException("Ghe " + seat + " vua duoc dat boi mot khach hang khac.");
                    }
                }
            }
        }
    }

    private int createGuestUser(Connection connection, String guestName, String guestPhone, String guestEmail)
            throws SQLException, ServiceException {
        if (isBlank(guestName) || isBlank(guestPhone) || isBlank(guestEmail)) {
            throw new ServiceException("Vui long nhap day du thong tin lien he.");
        }
        if (emailExists(connection, guestEmail)) {
            throw new ServiceException("Email nay da ton tai. Vui long dang nhap de tiep tuc.");
        }

        String sql = "INSERT INTO Users (username, password, fullName, phoneNumber, email, role) "
                + "VALUES (?, ?, ?, ?, ?, 'Guest')";
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, "guest_" + System.currentTimeMillis() + "_" + Math.abs(UUID.randomUUID().hashCode()));
            statement.setString(2, PasswordUtils.hashPassword(UUID.randomUUID().toString()));
            statement.setString(3, guestName.trim());
            statement.setString(4, guestPhone.trim());
            statement.setString(5, guestEmail.trim());
            statement.executeUpdate();

            try (ResultSet resultSet = statement.getGeneratedKeys()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }
        throw new ServiceException("Khong the tao thong tin hanh khach.");
    }

    private boolean emailExists(Connection connection, String email) throws SQLException {
        String sql = "SELECT 1 FROM Users WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email.trim());
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    private int insertBooking(Connection connection, int tripID, int userID, double totalPrice, String ticketCode,
            String tripType, int adultCount, int childCount)
            throws SQLException, ServiceException {
        String sql = "INSERT INTO Bookings (tripID, userID, totalPrice, status, ticketCode, tripType, adultCount, childCount) "
                + "VALUES (?, ?, ?, 'Pending', ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, tripID);
            statement.setInt(2, userID);
            statement.setDouble(3, totalPrice);
            statement.setString(4, ticketCode);
            statement.setString(5, tripType);
            statement.setInt(6, adultCount);
            statement.setInt(7, childCount);
            statement.executeUpdate();

            try (ResultSet resultSet = statement.getGeneratedKeys()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }
        throw new ServiceException("Khong the tao don dat ve.");
    }

    private List<Integer> insertPassengers(Connection connection, int bookingID, int adultCount, int childCount)
            throws SQLException {
        List<Integer> passengerIds = new ArrayList<>();
        String sql = "INSERT INTO BookingPassengers (bookingID, passengerType, displayLabel) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 1; i <= adultCount; i++) {
                passengerIds.add(insertPassenger(statement, bookingID, "Adult", "Adult " + i));
            }
            for (int i = 1; i <= childCount; i++) {
                passengerIds.add(insertPassenger(statement, bookingID, "Child", "Child " + i));
            }
        }
        return passengerIds;
    }

    private int insertPassenger(PreparedStatement statement, int bookingID, String passengerType, String displayLabel)
            throws SQLException {
        statement.setInt(1, bookingID);
        statement.setString(2, passengerType);
        statement.setString(3, displayLabel);
        statement.executeUpdate();
        try (ResultSet resultSet = statement.getGeneratedKeys()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        }
        throw new SQLException("Unable to create booking passenger.");
    }

    private int insertSegment(Connection connection, int bookingID, int tripID, String segmentType, int segmentOrder,
            double segmentPrice) throws SQLException {
        String sql = "INSERT INTO BookingSegments (bookingID, tripID, segmentType, segmentOrder, segmentPrice) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, bookingID);
            statement.setInt(2, tripID);
            statement.setString(3, segmentType);
            statement.setInt(4, segmentOrder);
            statement.setDouble(5, segmentPrice);
            statement.executeUpdate();
            try (ResultSet resultSet = statement.getGeneratedKeys()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }
        throw new SQLException("Unable to create booking segment.");
    }

    private void insertSegmentSeats(Connection connection, int segmentID, List<Integer> passengerIds,
            int adultCount, double basePrice, String[] seats)
            throws SQLException {
        String sql = "INSERT INTO BookingSegmentSeats (segmentID, passengerID, seatNumber, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 0; i < seats.length; i++) {
                boolean childPassenger = i >= adultCount;
                statement.setInt(1, segmentID);
                statement.setInt(2, passengerIds.get(i));
                statement.setString(3, seats[i]);
                statement.setDouble(4, FarePolicy.calculateSeatPrice(basePrice, childPassenger));
                statement.addBatch();
            }
            statement.executeBatch();
        }
    }

    private String createTicketCode() {
        return "TKT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void rollbackQuietly(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            connection.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void restoreAutoCommit(Connection connection, boolean autoCommit) {
        if (connection == null) {
            return;
        }
        try {
            connection.setAutoCommit(autoCommit);
        } catch (SQLException ignored) {
        }
    }

    private void closeQuietly(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            connection.close();
        } catch (SQLException ignored) {
        }
    }

    public static class BookingCreationResult {
        private final int bookingID;
        private final double totalPrice;
        private final boolean guestBooking;

        public BookingCreationResult(int bookingID, double totalPrice, boolean guestBooking) {
            this.bookingID = bookingID;
            this.totalPrice = totalPrice;
            this.guestBooking = guestBooking;
        }

        public int getBookingID() {
            return bookingID;
        }

        public double getTotalPrice() {
            return totalPrice;
        }

        public boolean isGuestBooking() {
            return guestBooking;
        }
    }
}

