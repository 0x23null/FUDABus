package dal;

import model.Bus;
import model.Route;
import model.Trip;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TripDAO extends DBContext {

    public List<Trip> getAll() {
        List<Trip> list = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "r.origin, r.destination, r.distance, r.duration, "
                + "b.busNumber, b.busType, b.seatCapacity "
                + "FROM Trips t "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "JOIN Buses b ON t.busID = b.busID "
                + "ORDER BY t.departureTime DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapTrip(rs));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Trip> getUpcomingTrips() {
        List<Trip> list = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "r.origin, r.destination, r.distance, r.duration, "
                + "b.busNumber, b.busType, b.seatCapacity "
                + "FROM Trips t "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "JOIN Buses b ON t.busID = b.busID "
                + "WHERE t.departureTime > GETDATE() AND t.status = 'Scheduled' "
                + "ORDER BY t.departureTime ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapTrip(rs));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void insert(Trip t) {
        String sql = "INSERT INTO Trips (routeID, busID, departureTime, arrivalTime, price, status) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, t.getRouteID());
            st.setInt(2, t.getBusID());
            st.setTimestamp(3, t.getDepartureTime());
            st.setTimestamp(4, t.getArrivalTime());
            st.setDouble(5, t.getPrice());
            st.setString(6, t.getStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Trips WHERE tripID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public List<Trip> searchTrips(String origin, String destination, String date) {
        List<Trip> list = new ArrayList<>();
        String sql = "SELECT t.*, r.origin, r.destination, r.distance, r.duration, b.busNumber, b.busType, b.seatCapacity "
                + "FROM Trips t "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "JOIN Buses b ON t.busID = b.busID "
                + "WHERE r.origin LIKE ? AND r.destination LIKE ? "
                + "AND CONVERT(DATE, t.departureTime) = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + origin + "%");
            st.setString(2, "%" + destination + "%");
            st.setString(3, date);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapTrip(rs));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Trip getTripByID(int id) {
        String sql = "SELECT t.*, r.origin, r.destination, r.distance, r.duration, b.busNumber, b.busType, b.seatCapacity "
                + "FROM Trips t "
                + "JOIN Routes r ON t.routeID = r.routeID "
                + "JOIN Buses b ON t.busID = b.busID "
                + "WHERE t.tripID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapTrip(rs);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public List<Route> getAllRoutes() {
        List<Route> routes = new ArrayList<>();
        String sql = "SELECT routeID, origin, destination, duration, description FROM Routes ORDER BY origin, destination";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Route route = new Route();
                route.setRouteID(rs.getInt("routeID"));
                route.setOrigin(rs.getString("origin"));
                route.setDestination(rs.getString("destination"));
                route.setDuration(rs.getInt("duration"));
                route.setDescription(rs.getString("description"));
                routes.add(route);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return routes;
    }

    private Trip mapTrip(ResultSet rs) throws SQLException {
        Trip trip = new Trip(
                rs.getInt("tripID"),
                rs.getInt("routeID"),
                rs.getInt("busID"),
                rs.getTimestamp("departureTime"),
                rs.getTimestamp("arrivalTime"),
                rs.getDouble("price"),
                rs.getString("status"));

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
        return trip;
    }
}
