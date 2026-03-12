package dal;

import model.Bus;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BusDAO extends DBContext {

    public List<Bus> getAll() {
        List<Bus> list = new ArrayList<>();
        String sql = "SELECT * FROM Buses";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Bus b = new Bus(
                        rs.getInt("busID"),
                        rs.getString("busNumber"),
                        rs.getInt("seatCapacity"),
                        rs.getString("busType"),
                        rs.getString("imageURL"));
                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Bus getBusByID(int id) {
        String sql = "SELECT * FROM Buses WHERE busID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Bus(
                        rs.getInt("busID"),
                        rs.getString("busNumber"),
                        rs.getInt("seatCapacity"),
                        rs.getString("busType"),
                        rs.getString("imageURL"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public void insert(Bus b) {
        String sql = "INSERT INTO Buses (busNumber, seatCapacity, busType, imageURL) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, b.getBusNumber());
            st.setInt(2, b.getSeatCapacity());
            st.setString(3, b.getBusType());
            st.setString(4, b.getImageURL());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void update(Bus b) {
        String sql = "UPDATE Buses SET busNumber=?, seatCapacity=?, busType=?, imageURL=? WHERE busID=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, b.getBusNumber());
            st.setInt(2, b.getSeatCapacity());
            st.setString(3, b.getBusType());
            st.setString(4, b.getImageURL());
            st.setInt(5, b.getBusID());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Buses WHERE busID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
