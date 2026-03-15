package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Booking;
import model.BookingPassenger;
import model.BookingSegment;
import model.Bus;
import model.Route;
import model.Trip;
import model.User;

public class BookingDAO extends DBContext {

    public List<Booking> getBookingsByUserID(int userID) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.bookingID, b.tripID, b.userID, b.bookingDate, b.totalPrice, b.status, b.ticketCode, "
                + "b.tripType, b.adultCount, b.childCount, b.qrCodeURL, "
                + "t.tripID AS primaryTripID, t.departureTime, t.arrivalTime, t.price, "
                + "r.routeID, r.origin, r.destination, r.duration, "
                + "bs.busID, bs.busNumber, bs.busType "
                + "FROM Bookings b "
                + "LEFT JOIN Trips t ON b.tripID = t.tripID "
                + "LEFT JOIN Routes r ON t.routeID = r.routeID "
                + "LEFT JOIN Buses bs ON t.busID = bs.busID "
                + "WHERE b.userID = ? "
                + "ORDER BY b.bookingDate DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Booking booking = mapBookingSummary(rs);
                list.add(booking);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.bookingID, b.tripID, b.userID, b.bookingDate, b.totalPrice, b.status, b.ticketCode, "
                + "b.tripType, b.adultCount, b.childCount, b.qrCodeURL, "
                + "t.tripID AS primaryTripID, t.departureTime, t.arrivalTime, t.price, "
                + "r.routeID, r.origin, r.destination, r.duration, "
                + "u.fullName, bs.busID, bs.busNumber, bs.busType "
                + "FROM Bookings b "
                + "LEFT JOIN Trips t ON b.tripID = t.tripID "
                + "LEFT JOIN Routes r ON t.routeID = r.routeID "
                + "LEFT JOIN Users u ON b.userID = u.userID "
                + "LEFT JOIN Buses bs ON t.busID = bs.busID "
                + "ORDER BY b.bookingDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Booking booking = mapBookingSummary(rs);
                User user = new User();
                user.setUserID(rs.getInt("userID"));
                user.setFullName(rs.getString("fullName"));
                booking.setUser(user);
                list.add(booking);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Booking getBookingFullDetails(int bookingID) {
        String sql = "SELECT b.bookingID, b.tripID, b.userID, b.bookingDate, b.totalPrice, b.status, b.ticketCode, "
                + "b.tripType, b.adultCount, b.childCount, b.qrCodeURL, "
                + "t.tripID AS primaryTripID, t.departureTime, t.arrivalTime, t.price, "
                + "r.routeID, r.origin, r.destination, r.duration, "
                + "u.fullName, u.email, u.phoneNumber, u.role, "
                + "bs.busID, bs.busNumber, bs.busType "
                + "FROM Bookings b "
                + "LEFT JOIN Trips t ON b.tripID = t.tripID "
                + "LEFT JOIN Routes r ON t.routeID = r.routeID "
                + "LEFT JOIN Users u ON b.userID = u.userID "
                + "LEFT JOIN Buses bs ON t.busID = bs.busID "
                + "WHERE b.bookingID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, bookingID);
            ResultSet rs = st.executeQuery();
            if (!rs.next()) {
                return null;
            }

            Booking booking = mapBookingSummary(rs);

            User user = new User();
            user.setUserID(rs.getInt("userID"));
            user.setFullName(rs.getString("fullName"));
            user.setEmail(rs.getString("email"));
            user.setPhoneNumber(rs.getString("phoneNumber"));
            user.setRole(rs.getString("role"));
            booking.setUser(user);

            List<BookingSegment> segments = loadSegments(bookingID);
            booking.setSegments(segments);
            if (booking.getTrip() == null && !segments.isEmpty()) {
                booking.setTrip(segments.get(0).getTrip());
            }

            BookingSegment outbound = booking.getOutboundSegment();
            if (outbound != null) {
                booking.setBookedSeats(outbound.getSeatNumbers());
            } else if (!segments.isEmpty()) {
                booking.setBookedSeats(segments.get(0).getSeatNumbers());
            } else {
                booking.setBookedSeats(new ArrayList<>());
            }

            booking.setPassengers(loadPassengers(bookingID));
            return booking;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    private Booking mapBookingSummary(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingID(rs.getInt("bookingID"));
        booking.setTripID(rs.getInt("tripID"));
        booking.setUserID(rs.getInt("userID"));
        booking.setBookingDate(rs.getTimestamp("bookingDate"));
        booking.setTotalPrice(rs.getDouble("totalPrice"));
        booking.setStatus(rs.getString("status"));
        booking.setTicketCode(rs.getString("ticketCode"));
        booking.setTripType(rs.getString("tripType"));
        booking.setAdultCount(rs.getInt("adultCount"));
        booking.setChildCount(rs.getInt("childCount"));
        booking.setQrCodeURL(rs.getString("qrCodeURL"));

        if (rs.getObject("primaryTripID") != null) {
            booking.setTrip(mapTrip(rs));
        }
        return booking;
    }

    private Trip mapTrip(ResultSet rs) throws SQLException {
        Trip trip = new Trip();
        trip.setTripID(rs.getInt("primaryTripID"));
        trip.setDepartureTime(rs.getTimestamp("departureTime"));
        trip.setArrivalTime(rs.getTimestamp("arrivalTime"));
        trip.setPrice(rs.getDouble("price"));

        Route route = new Route();
        route.setRouteID(rs.getInt("routeID"));
        route.setOrigin(rs.getString("origin"));
        route.setDestination(rs.getString("destination"));
        route.setDuration(rs.getInt("duration"));
        trip.setRoute(route);

        Bus bus = new Bus();
        bus.setBusID(rs.getInt("busID"));
        bus.setBusNumber(rs.getString("busNumber"));
        bus.setBusType(rs.getString("busType"));
        trip.setBus(bus);
        return trip;
    }

    private List<BookingSegment> loadSegments(int bookingID) throws SQLException {
        List<BookingSegment> segments = new ArrayList<>();
        String sql = "SELECT bs.segmentID, bs.bookingID, bs.tripID, bs.segmentType, bs.segmentOrder, bs.segmentPrice, "
                + "t.departureTime, t.arrivalTime, t.price, t.status, "
                + "r.routeID, r.origin, r.destination, r.duration, "
                + "b.busID, b.busNumber, b.busType, b.seatCapacity "
                + "FROM BookingSegments bs "
                + "JOIN Trips t ON bs.tripID = t.tripID "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "JOIN Buses b ON t.busID = b.busID "
                + "WHERE bs.bookingID = ? "
                + "ORDER BY bs.segmentOrder ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, bookingID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    BookingSegment segment = new BookingSegment();
                    segment.setSegmentID(rs.getInt("segmentID"));
                    segment.setBookingID(rs.getInt("bookingID"));
                    segment.setTripID(rs.getInt("tripID"));
                    segment.setSegmentType(rs.getString("segmentType"));
                    segment.setSegmentOrder(rs.getInt("segmentOrder"));
                    segment.setSegmentPrice(rs.getDouble("segmentPrice"));

                    Trip trip = new Trip();
                    trip.setTripID(rs.getInt("tripID"));
                    trip.setDepartureTime(rs.getTimestamp("departureTime"));
                    trip.setArrivalTime(rs.getTimestamp("arrivalTime"));
                    trip.setPrice(rs.getDouble("price"));
                    trip.setStatus(rs.getString("status"));

                    Route route = new Route();
                    route.setRouteID(rs.getInt("routeID"));
                    route.setOrigin(rs.getString("origin"));
                    route.setDestination(rs.getString("destination"));
                    route.setDuration(rs.getInt("duration"));
                    trip.setRoute(route);

                    Bus bus = new Bus();
                    bus.setBusID(rs.getInt("busID"));
                    bus.setBusNumber(rs.getString("busNumber"));
                    bus.setBusType(rs.getString("busType"));
                    bus.setSeatCapacity(rs.getInt("seatCapacity"));
                    trip.setBus(bus);

                    segment.setTrip(trip);
                    segment.setSeatNumbers(loadSegmentSeats(segment.getSegmentID()));
                    segments.add(segment);
                }
            }
        }
        return segments;
    }

    private List<String> loadSegmentSeats(int segmentID) throws SQLException {
        List<String> seats = new ArrayList<>();
        String sql = "SELECT seatNumber FROM BookingSegmentSeats WHERE segmentID = ? ORDER BY seatNumber";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, segmentID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    seats.add(rs.getString("seatNumber"));
                }
            }
        }
        return seats;
    }

    private List<BookingPassenger> loadPassengers(int bookingID) throws SQLException {
        List<BookingPassenger> passengers = new ArrayList<>();
        String sql = "SELECT passengerID, bookingID, passengerType, displayLabel FROM BookingPassengers WHERE bookingID = ? ORDER BY passengerID";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, bookingID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    BookingPassenger passenger = new BookingPassenger();
                    passenger.setPassengerID(rs.getInt("passengerID"));
                    passenger.setBookingID(rs.getInt("bookingID"));
                    passenger.setPassengerType(rs.getString("passengerType"));
                    passenger.setDisplayLabel(rs.getString("displayLabel"));
                    passengers.add(passenger);
                }
            }
        }
        return passengers;
    }

    public Booking getBookingByTicketCode(String ticketCode) {
        String sql = "SELECT bookingID FROM Bookings WHERE ticketCode = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, ticketCode);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return getBookingFullDetails(rs.getInt("bookingID"));
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public List<Booking> getBookingsByPhoneNumber(String phoneNumber, int limit) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.bookingID "
                + "FROM Bookings b "
                + "JOIN Users u ON b.userID = u.userID "
                + "WHERE u.phoneNumber = ? "
                + "ORDER BY b.bookingDate DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, phoneNumber);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next() && bookings.size() < limit) {
                    Booking booking = getBookingFullDetails(rs.getInt("bookingID"));
                    if (booking != null) {
                        bookings.add(booking);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return bookings;
    }
}