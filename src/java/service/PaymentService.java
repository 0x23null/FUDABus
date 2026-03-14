package service;

import dal.BookingDAO;
import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Booking;

public class PaymentService {

    public Booking getBookingDetails(int bookingID) {
        return new BookingDAO().getBookingFullDetails(bookingID);
    }

    public double getBookingAmount(int bookingID) throws ServiceException {
        Booking booking = getBookingDetails(bookingID);
        if (booking == null) {
            throw new ServiceException("Khong tim thay don dat ve.");
        }
        if ("Cancelled".equalsIgnoreCase(booking.getStatus())) {
            throw new ServiceException("Don dat ve nay da bi huy.");
        }
        if ("Paid".equalsIgnoreCase(booking.getStatus())) {
            throw new ServiceException("Don dat ve nay da duoc thanh toan.");
        }
        return booking.getTotalPrice();
    }

    public boolean cancelPendingBooking(int bookingID) throws ServiceException {
        DBContext db = new DBContext();
        Connection connection = db.connection;
        if (connection == null) {
            throw new ServiceException("Khong the ket noi co so du lieu.");
        }

        String sql = "UPDATE Bookings SET status = 'Cancelled' WHERE bookingID = ? AND status = 'Pending'";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, bookingID);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new ServiceException("Khong the huy don dat ve.", ex);
        } finally {
            closeQuietly(connection);
        }
    }

    public boolean markBookingPaid(int bookingID, String paymentMethod, String transactionID) throws ServiceException {
        DBContext db = new DBContext();
        Connection connection = db.connection;
        if (connection == null) {
            throw new ServiceException("Khong the ket noi co so du lieu.");
        }

        boolean previousAutoCommit = true;
        try {
            previousAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            BookingState bookingState = loadBookingState(connection, bookingID);
            if (bookingState == null) {
                throw new ServiceException("Khong tim thay don dat ve.");
            }
            if ("Cancelled".equalsIgnoreCase(bookingState.status)) {
                throw new ServiceException("Don dat ve nay da bi huy.");
            }
            if ("Paid".equalsIgnoreCase(bookingState.status)) {
                connection.commit();
                return true;
            }

            try (PreparedStatement update = connection.prepareStatement(
                    "UPDATE Bookings SET status = 'Paid' WHERE bookingID = ?")) {
                update.setInt(1, bookingID);
                update.executeUpdate();
            }

            if (!hasSuccessfulPayment(connection, bookingID, paymentMethod, transactionID)) {
                try (PreparedStatement insert = connection.prepareStatement(
                        "INSERT INTO Payments (bookingID, amount, paymentMethod, transactionID, status) "
                                + "VALUES (?, ?, ?, ?, 'Success')")) {
                    insert.setInt(1, bookingID);
                    insert.setDouble(2, bookingState.totalPrice);
                    insert.setString(3, paymentMethod);
                    insert.setString(4, transactionID);
                    insert.executeUpdate();
                }
            }

            connection.commit();
            return true;
        } catch (SQLException ex) {
            rollbackQuietly(connection);
            throw new ServiceException("Khong the cap nhat thanh toan.", ex);
        } finally {
            restoreAutoCommit(connection, previousAutoCommit);
            closeQuietly(connection);
        }
    }

    public void recordFailedPayment(int bookingID, String paymentMethod, String transactionID) throws ServiceException {
        DBContext db = new DBContext();
        Connection connection = db.connection;
        if (connection == null) {
            throw new ServiceException("Khong the ket noi co so du lieu.");
        }

        try {
            BookingState bookingState = loadBookingState(connection, bookingID);
            if (bookingState == null) {
                throw new ServiceException("Khong tim thay don dat ve.");
            }

            try (PreparedStatement insert = connection.prepareStatement(
                    "INSERT INTO Payments (bookingID, amount, paymentMethod, transactionID, status) "
                            + "VALUES (?, ?, ?, ?, 'Failed')")) {
                insert.setInt(1, bookingID);
                insert.setDouble(2, bookingState.totalPrice);
                insert.setString(3, paymentMethod);
                insert.setString(4, transactionID);
                insert.executeUpdate();
            }
        } catch (SQLException ex) {
            throw new ServiceException("Khong the ghi nhan thanh toan that bai.", ex);
        } finally {
            closeQuietly(connection);
        }
    }

    private BookingState loadBookingState(Connection connection, int bookingID) throws SQLException {
        String sql = "SELECT bookingID, totalPrice, status FROM Bookings WHERE bookingID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, bookingID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }
                return new BookingState(
                        resultSet.getInt("bookingID"),
                        resultSet.getDouble("totalPrice"),
                        resultSet.getString("status"));
            }
        }
    }

    private boolean hasSuccessfulPayment(Connection connection, int bookingID, String paymentMethod, String transactionID)
            throws SQLException {
        String sql = "SELECT COUNT(*) FROM Payments WHERE bookingID = ? AND status = 'Success' "
                + "AND paymentMethod = ? "
                + "AND ((transactionID IS NULL AND ? IS NULL) OR transactionID = ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, bookingID);
            statement.setString(2, paymentMethod);
            statement.setString(3, transactionID);
            statement.setString(4, transactionID);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
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

    private static class BookingState {
        private final int bookingID;
        private final double totalPrice;
        private final String status;

        private BookingState(int bookingID, double totalPrice, String status) {
            this.bookingID = bookingID;
            this.totalPrice = totalPrice;
            this.status = status;
        }
    }
}
