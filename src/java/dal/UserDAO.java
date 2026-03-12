package dal;

import model.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserDAO extends DBContext {

    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, password); // Note: In production, use hashed passwords!
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("userID"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setPhoneNumber(rs.getString("phoneNumber"));
                u.setRole(rs.getString("role"));
                u.setGoogleID(rs.getString("googleID"));
                u.setCreatedAt(rs.getTimestamp("createdAt"));
                return u;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public User checkUserExist(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(); // Just return non-null to indicate existence
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public void register(String username, String password, String email, String fullName) {
        String sql = "INSERT INTO Users (username, password, email, fullName, role) VALUES (?, ?, ?, ?, 'Customer')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, password);
            st.setString(3, email);
            st.setString(4, fullName);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    // For Google Login later
    public User loginByGoogleID(String googleID) {
        String sql = "SELECT * FROM Users WHERE googleID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, googleID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("userID"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setRole(rs.getString("role"));
                u.setGoogleID(rs.getString("googleID"));
                return u;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public User loginGoogle(String email, String fullName, String googleUsername) {
        String sqlCheck = "SELECT * FROM Users WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sqlCheck);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("userID"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("fullName"));
                u.setRole(rs.getString("role"));
                return u;
            } else {
                // Register new user
                String sqlInsert = "INSERT INTO Users (username, password, email, fullName, role) VALUES (?, ?, ?, ?, 'Customer')";
                PreparedStatement st2 = connection.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
                st2.setString(1, googleUsername);
                st2.setString(2, "GOOGLE_LOGIN_PASS"); // Dummy password
                st2.setString(3, email);
                st2.setString(4, fullName);
                st2.executeUpdate();

                ResultSet rs2 = st2.getGeneratedKeys();
                if (rs2.next()) {
                    int newId = rs2.getInt(1);
                    User u = new User();
                    u.setUserID(newId);
                    u.setUsername(googleUsername);
                    u.setEmail(email);
                    u.setFullName(fullName);
                    u.setRole("Customer");
                    return u;
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }
}
