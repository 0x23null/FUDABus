package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Booking;
import model.Bus;
import model.Route;
import model.Trip;

public class BookingDAO extends DBContext {

    public List<Booking> getBookingsByUserID(int userID) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, "
                + "t.tripID, t.departureTime, t.arrivalTime, t.price, "
                + "r.routeID, r.origin, r.destination, r.duration, "
                + "bs.busID, bs.busNumber, bs.busType "
                + "FROM Bookings b "
                + "JOIN Trips t ON b.tripID = t.tripID "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "JOIN Buses bs ON t.busID = bs.busID "
                + "WHERE b.userID = ? "
                + "ORDER BY b.bookingDate DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setTicketCode(rs.getString("ticketCode"));
                b.setTripID(rs.getInt("tripID"));
                b.setUserID(rs.getInt("userID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setTotalPrice(rs.getDouble("totalPrice"));
                b.setStatus(rs.getString("status"));

                // Set Trip info
                Trip t = new Trip();
                t.setTripID(rs.getInt("tripID"));
                t.setDepartureTime(rs.getTimestamp("departureTime"));
                t.setArrivalTime(rs.getTimestamp("arrivalTime"));
                t.setPrice(rs.getDouble("price"));

                Route r = new Route();
                r.setRouteID(rs.getInt("routeID"));
                r.setOrigin(rs.getString("origin"));
                r.setDestination(rs.getString("destination"));
                r.setDuration(rs.getInt("duration"));
                t.setRoute(r);

                Bus bus = new Bus();
                bus.setBusID(rs.getInt("busID"));
                bus.setBusNumber(rs.getString("busNumber"));
                bus.setBusType(rs.getString("busType"));
                t.setBus(bus);

                b.setTrip(t);

                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    // For Admin to view all bookings
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, "
                + "t.tripID, t.departureTime, t.arrivalTime, "
                + "r.origin, r.destination, "
                + "u.fullName "
                + "FROM Bookings b "
                + "JOIN Trips t ON b.tripID = t.tripID "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "JOIN Users u ON b.userID = u.userID "
                + "ORDER BY b.bookingDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setTicketCode(rs.getString("ticketCode"));
                b.setTripID(rs.getInt("tripID"));
                b.setUserID(rs.getInt("userID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setTotalPrice(rs.getDouble("totalPrice"));
                b.setStatus(rs.getString("status"));

                // Trip Info (Simplified)
                Trip t = new Trip();
                t.setTripID(rs.getInt("tripID"));
                t.setDepartureTime(rs.getTimestamp("departureTime"));
                t.setArrivalTime(rs.getTimestamp("arrivalTime"));

                Route r = new Route();
                r.setOrigin(rs.getString("origin"));
                r.setDestination(rs.getString("destination"));
                t.setRoute(r);
                b.setTrip(t);

                // User Info
                model.User u = new model.User();
                u.setUserID(rs.getInt("userID"));
                u.setFullName(rs.getString("fullName"));
                b.setUser(u);

                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Booking getBookingFullDetails(int bookingID) {
        Booking b = null;
        String sql = "SELECT b.*, "
                + "t.tripID, t.departureTime, t.arrivalTime, t.price, "
                + "r.routeID, r.origin, r.destination, r.duration, "
                + "u.fullName, u.email, u.phoneNumber, "
                + "bs.busID, bs.busNumber, bs.busType "
                + "FROM Bookings b "
                + "JOIN Trips t ON b.tripID = t.tripID "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "LEFT JOIN Users u ON b.userID = u.userID "
                + "JOIN Buses bs ON t.busID = bs.busID "
                + "WHERE b.bookingID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, bookingID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setTicketCode(rs.getString("ticketCode"));
                b.setTripID(rs.getInt("tripID"));
                b.setUserID(rs.getInt("userID"));
                b.setBookingDate(rs.getTimestamp("bookingDate"));
                b.setTotalPrice(rs.getDouble("totalPrice"));
                b.setStatus(rs.getString("status"));

                Trip t = new Trip();
                t.setTripID(rs.getInt("tripID"));
                t.setDepartureTime(rs.getTimestamp("departureTime"));
                t.setArrivalTime(rs.getTimestamp("arrivalTime"));
                t.setPrice(rs.getDouble("price"));

                Route r = new Route();
                r.setRouteID(rs.getInt("routeID"));
                r.setOrigin(rs.getString("origin"));
                r.setDestination(rs.getString("destination"));
                r.setDuration(rs.getInt("duration"));
                t.setRoute(r);

                Bus bus = new Bus();
                bus.setBusID(rs.getInt("busID"));
                bus.setBusNumber(rs.getString("busNumber"));
                bus.setBusType(rs.getString("busType"));
                t.setBus(bus);

                b.setTrip(t);

                model.User u = new model.User();
                u.setUserID(rs.getInt("userID"));
                u.setFullName(rs.getString("fullName"));
                u.setEmail(rs.getString("email"));
                u.setPhoneNumber(rs.getString("phoneNumber"));
                b.setUser(u);

                // Fetch seats
                String sqlSeats = "SELECT seatNumber FROM BookingDetails WHERE bookingID = ?";
                PreparedStatement stSeats = connection.prepareStatement(sqlSeats);
                stSeats.setInt(1, bookingID);
                ResultSet rsSeats = stSeats.executeQuery();
                List<String> seats = new ArrayList<>();
                while (rsSeats.next()) {
                    seats.add(rsSeats.getString("seatNumber"));
                }
                b.setBookedSeats(seats);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return b;
    }
}
