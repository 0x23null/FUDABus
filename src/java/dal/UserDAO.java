package dal;

import model.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;
import util.PasswordUtils;

public class UserDAO extends DBContext {

    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (!PasswordUtils.matches(password, storedPassword)) {
                    return null;
                }

                if (PasswordUtils.needsRehash(storedPassword)) {
                    upgradePasswordHash(rs.getInt("userID"), password);
                    storedPassword = getPasswordByUserID(rs.getInt("userID"));
                }

                User u = mapUser(rs);
                u.setPassword(storedPassword);
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

    public User checkEmailExist(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public void register(String username, String password, String email, String fullName, String phoneNumber) {
        String sql = "INSERT INTO Users (username, password, email, fullName, phoneNumber, role) VALUES (?, ?, ?, ?, ?, 'Customer')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, PasswordUtils.hashPassword(password));
            st.setString(3, email);
            st.setString(4, fullName);
            st.setString(5, phoneNumber);
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
                return mapUser(rs);
            } else {
                // Register new user
                String sqlInsert = "INSERT INTO Users (username, password, email, fullName, role) VALUES (?, ?, ?, ?, 'Customer')";
                PreparedStatement st2 = connection.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
                st2.setString(1, googleUsername);
                st2.setString(2, PasswordUtils.hashPassword(UUID.randomUUID().toString()));
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

    public void updatePhone(int userID, String phoneNumber) {
        String sql = "UPDATE Users SET phoneNumber = ? WHERE userID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, phoneNumber);
            st.setInt(2, userID);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    private void upgradePasswordHash(int userID, String plainPassword) throws SQLException {
        String sql = "UPDATE Users SET password = ? WHERE userID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, PasswordUtils.hashPassword(plainPassword));
            st.setInt(2, userID);
            st.executeUpdate();
        }
    }

    private String getPasswordByUserID(int userID) throws SQLException {
        String sql = "SELECT password FROM Users WHERE userID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userID);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getString("password") : null;
            }
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
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
}
