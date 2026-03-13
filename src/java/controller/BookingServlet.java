package controller;

import dal.DBContext;
import dal.TripDAO;
import model.Trip;
import model.User;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "BookingServlet", urlPatterns = { "/booking" })
public class BookingServlet extends HttpServlet {

    // Helper to get booked seats
    private List<String> getBookedSeats(int tripID) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT seatNumber FROM BookingDetails bd "
                + "JOIN Bookings b ON bd.bookingID = b.bookingID "
                + "WHERE b.tripID = ? AND b.status != 'Cancelled'";
        try {
            DBContext db = new DBContext();
            PreparedStatement st = db.connection.prepareStatement(sql);
            st.setInt(1, tripID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("seatNumber"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tripIDStr = request.getParameter("tripID");
        String returnTripIDStr = request.getParameter("returnTripID");
        String ticketCountStr = request.getParameter("ticketCount");

        if (tripIDStr == null) {
            response.sendRedirect("home");
            return;
        }

        int tripID = Integer.parseInt(tripIDStr);
        int ticketCount = (ticketCountStr != null && !ticketCountStr.isEmpty()) ? Integer.parseInt(ticketCountStr) : 1;

        TripDAO dao = new TripDAO();
        Trip trip = dao.getTripByID(tripID);

        if (trip == null) {
            response.sendRedirect("home");
            return;
        }

        List<String> bookedSeats = getBookedSeats(tripID);
        request.setAttribute("trip", trip);
        request.setAttribute("bookedSeats", bookedSeats);

        // Xử lý chuyến về nếu có
        if (returnTripIDStr != null && !returnTripIDStr.isEmpty()) {
            int returnTripID = Integer.parseInt(returnTripIDStr);
            Trip returnTrip = dao.getTripByID(returnTripID);
            List<String> returnBookedSeats = getBookedSeats(returnTripID);
            request.setAttribute("returnTrip", returnTrip);
            request.setAttribute("returnBookedSeats", returnBookedSeats);
        }

        request.setAttribute("ticketCount", ticketCount);
        request.getRequestDispatcher("views/public/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        int tripID = Integer.parseInt(request.getParameter("tripID"));
        String selectedSeats = request.getParameter("selectedSeats");
        String returnTripIDStr = request.getParameter("returnTripID");
        String returnSeatsStr = request.getParameter("returnSeats");
        double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));

        if (selectedSeats == null || selectedSeats.isEmpty()) {
            response.sendRedirect("booking?tripID=" + tripID);
            return;
        }

        String[] seats = selectedSeats.split(",");
        String[] returnSeats = (returnSeatsStr != null && !returnSeatsStr.isEmpty()) ? returnSeatsStr.split(",")
                : new String[0];

        DBContext db = new DBContext();

        try {
            // 1. Race condition checks
            for (String seat : seats) {
                if (isSeatBooked(db, tripID, seat)) {
                    response.sendRedirect("booking?tripID=" + tripID + "&error=SeatsUnavailable");
                    return;
                }
            }
            if (returnTripIDStr != null && !returnTripIDStr.isEmpty() && returnSeats.length > 0) {
                int retTripID = Integer.parseInt(returnTripIDStr);
                for (String seat : returnSeats) {
                    if (isSeatBooked(db, retTripID, seat)) {
                        response.sendRedirect("booking?tripID=" + tripID + "&error=SeatsUnavailable");
                        return;
                    }
                }
            }

            // 2. Insert User if Guest
            int bookingUserID = 0;
            if (user != null) {
                bookingUserID = user.getUserID();
            } else {
                String guestName = request.getParameter("guestName");
                String guestPhone = request.getParameter("guestPhone");
                String guestEmail = request.getParameter("guestEmail");
                
                String sqlGuest = "INSERT INTO Users (username, password, fullName, phoneNumber, email, role) VALUES (?, ?, ?, ?, ?, 'Guest')";
                PreparedStatement stG = db.connection.prepareStatement(sqlGuest, Statement.RETURN_GENERATED_KEYS);
                stG.setString(1, "guest_" + System.currentTimeMillis());
                stG.setString(2, "GUEST_PASSWORD");
                stG.setString(3, guestName);
                stG.setString(4, guestPhone);
                stG.setString(5, guestEmail);
                stG.executeUpdate();
                ResultSet rsG = stG.getGeneratedKeys();
                if(rsG.next()){
                    bookingUserID = rsG.getInt(1);
                }
            }

            // 3. Insert Booking
            String ticketCode = "TKT-" + System.currentTimeMillis() + "-" + (int) (Math.random() * 1000);
            String sqlBooking = "INSERT INTO Bookings (tripID, userID, totalPrice, status, ticketCode) VALUES (?, ?, ?, 'Pending', ?)";
            PreparedStatement st1 = db.connection.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS);
            st1.setInt(1, tripID);
            if (bookingUserID > 0) {
                st1.setInt(2, bookingUserID);
            } else {
                st1.setNull(2, java.sql.Types.INTEGER);
            }
            st1.setDouble(3, totalPrice);
            st1.setString(4, ticketCode);
            st1.executeUpdate();

            ResultSet rs = st1.getGeneratedKeys();
            int bookingID = 0;
            if (rs.next()) {
                bookingID = rs.getInt(1);
            }

            // 3. Insert Details for outbound
            String sqlDetail = "INSERT INTO BookingDetails (bookingID, seatNumber, price) VALUES (?, ?, ?)";
            PreparedStatement st2 = db.connection.prepareStatement(sqlDetail);
            Trip t = new TripDAO().getTripByID(tripID);
            for (String seat : seats) {
                st2.setInt(1, bookingID);
                st2.setString(2, seat);
                st2.setDouble(3, t.getPrice());
                st2.addBatch();
            }
            st2.executeBatch();

            // 4. Insert details for return trip if exists
            if (returnTripIDStr != null && !returnTripIDStr.isEmpty() && returnSeats.length > 0) {
                int retTripID = Integer.parseInt(returnTripIDStr);
                Trip returnsT = new TripDAO().getTripByID(retTripID);
                for (String seat : returnSeats) {
                    st2.setInt(1, bookingID);
                    st2.setString(2, seat);
                    st2.setDouble(3, returnsT.getPrice());
                    st2.addBatch();
                }
                st2.executeBatch();
            }

            // Redirect to Payment
            response.sendRedirect("payment?bookingID=" + bookingID);

        } catch (SQLException e) {
            System.out.println(e);
            response.sendRedirect("booking?tripID=" + tripID + "&error=BookingFailed");
        }
    }

    private boolean isSeatBooked(DBContext db, int tripID, String seat) throws SQLException {
        String checkSql = "SELECT count(*) FROM BookingDetails bd "
                + "JOIN Bookings b ON bd.bookingID = b.bookingID "
                + "WHERE b.tripID = ? AND bd.seatNumber = ? AND b.status != 'Cancelled'";
        PreparedStatement ck = db.connection.prepareStatement(checkSql);
        ck.setInt(1, tripID);
        ck.setString(2, seat);
        ResultSet rsCk = ck.executeQuery();
        return (rsCk.next() && rsCk.getInt(1) > 0);
    }
}
