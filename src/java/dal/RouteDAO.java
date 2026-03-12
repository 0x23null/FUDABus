package dal;

import model.Route;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RouteDAO extends DBContext {

    public List<Route> getAll() {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Route r = new Route(
                        rs.getInt("routeID"),
                        rs.getString("origin"),
                        rs.getString("destination"),
                        rs.getDouble("distance"),
                        rs.getInt("duration"),
                        rs.getString("description"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Route getRouteByID(int id) {
        String sql = "SELECT * FROM Routes WHERE routeID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Route(
                        rs.getInt("routeID"),
                        rs.getString("origin"),
                        rs.getString("destination"),
                        rs.getDouble("distance"),
                        rs.getInt("duration"),
                        rs.getString("description"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public void insert(Route r) {
        String sql = "INSERT INTO Routes (origin, destination, distance, duration, description) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, r.getOrigin());
            st.setString(2, r.getDestination());
            st.setDouble(3, r.getDistance());
            st.setInt(4, r.getDuration());
            st.setString(5, r.getDescription());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void update(Route r) {
        String sql = "UPDATE Routes SET origin=?, destination=?, distance=?, duration=?, description=? WHERE routeID=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, r.getOrigin());
            st.setString(2, r.getDestination());
            st.setDouble(3, r.getDistance());
            st.setInt(4, r.getDuration());
            st.setString(5, r.getDescription());
            st.setInt(6, r.getRouteID());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Routes WHERE routeID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
