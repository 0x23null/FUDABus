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
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            session.setAttribute("redirectAfterLogin", "booking?tripID=" + request.getParameter("tripID"));
            response.sendRedirect("login");
            return;
        }

        int tripID = Integer.parseInt(request.getParameter("tripID"));
        TripDAO dao = new TripDAO();
        Trip trip = dao.getTripByID(tripID);

        if (trip == null) {
            response.sendRedirect("home");
            return;
        }

        List<String> bookedSeats = getBookedSeats(tripID);

        request.setAttribute("trip", trip);
        request.setAttribute("bookedSeats", bookedSeats);
        request.getRequestDispatcher("views/public/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int tripID = Integer.parseInt(request.getParameter("tripID"));
        String selectedSeats = request.getParameter("selectedSeats"); // Comma separated: "1A,1B"
        double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));

        if (selectedSeats == null || selectedSeats.isEmpty()) {
            response.sendRedirect("booking?tripID=" + tripID);
            return;
        }

        String[] seats = selectedSeats.split(",");
        DBContext db = new DBContext();

        // 0. Check availability again (Race condition prevention)
        try {
            for (String seat : seats) {
                String checkSql = "SELECT count(*) FROM BookingDetails bd "
                        + "JOIN Bookings b ON bd.bookingID = b.bookingID "
                        + "WHERE b.tripID = ? AND bd.seatNumber = ? AND b.status != 'Cancelled'";
                PreparedStatement ck = db.connection.prepareStatement(checkSql);
                ck.setInt(1, tripID);
                ck.setString(2, seat);
                ResultSet rsCk = ck.executeQuery();
                if (rsCk.next() && rsCk.getInt(1) > 0) {
                    response.sendRedirect("booking?tripID=" + tripID + "&error=SeatsUnavailable");
                    return;
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
            response.sendRedirect("booking?tripID=" + tripID + "&error=DatabaseError");
            return;
        }
        try {
            // 1. Insert Booking
            String ticketCode = "TKT-" + System.currentTimeMillis() + "-" + (int) (Math.random() * 1000); // Simple ID
                                                                                                          // generation
            String sqlBooking = "INSERT INTO Bookings (tripID, userID, totalPrice, status, ticketCode) VALUES (?, ?, ?, 'Pending', ?)";
            PreparedStatement st1 = db.connection.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS);
            st1.setInt(1, tripID);
            st1.setInt(2, user.getUserID());
            st1.setDouble(3, totalPrice);
            st1.setString(4, ticketCode);
            st1.executeUpdate();

            ResultSet rs = st1.getGeneratedKeys();
            int bookingID = 0;
            if (rs.next()) {
                bookingID = rs.getInt(1);
            }

            // 2. Insert Booking Details

            String sqlDetail = "INSERT INTO BookingDetails (bookingID, seatNumber, price) VALUES (?, ?, ?)";
            PreparedStatement st2 = db.connection.prepareStatement(sqlDetail);

            Trip t = new TripDAO().getTripByID(tripID); // Get current price per seat

            for (String seat : seats) {
                st2.setInt(1, bookingID);
                st2.setString(2, seat);
                st2.setDouble(3, t.getPrice());
                st2.addBatch();
            }
            st2.executeBatch();

            // Redirect to Payment/Confirmation
            response.sendRedirect("payment?bookingID=" + bookingID);

        } catch (SQLException e) {
            System.out.println(e);
            response.sendRedirect("booking?tripID=" + tripID + "&error=BookingFailed");
        }
    }
}
