package controller;

import dal.DBContext;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TicketServlet", urlPatterns = { "/ticket" })
public class TicketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("home");
            return;
        }

        int bookingID = Integer.parseInt(idStr);
        DBContext db = new DBContext();

        // Fetch full ticket details
        // Joined query to get User, Trip, Route, Bus info
        String sql = "SELECT b.bookingID, b.bookingDate, b.totalPrice, b.status, b.ticketCode, " +
                "u.fullName, u.email, " +
                "t.departureTime, t.arrivalTime, " +
                "r.origin, r.destination, " +
                "bs.busNumber, bs.busType " +
                "FROM Bookings b " +
                "JOIN Users u ON b.userID = u.userID " +
                "JOIN Trips t ON b.tripID = t.tripID " +
                "JOIN Routes r ON t.routeID = r.routeID " +
                "JOIN Buses bs ON t.busID = bs.busID " +
                "WHERE b.bookingID = ?";

        try {
            PreparedStatement st = db.connection.prepareStatement(sql);
            st.setInt(1, bookingID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                request.setAttribute("bookingID", rs.getInt("bookingID"));
                request.setAttribute("ticketCode", rs.getString("ticketCode"));
                request.setAttribute("bookingDate", rs.getTimestamp("bookingDate"));
                request.setAttribute("bookingDate", rs.getTimestamp("bookingDate"));
                request.setAttribute("totalPrice", rs.getDouble("totalPrice"));
                request.setAttribute("status", rs.getString("status"));
                request.setAttribute("fullName", rs.getString("fullName"));
                request.setAttribute("email", rs.getString("email"));
                request.setAttribute("departureTime", rs.getTimestamp("departureTime"));
                request.setAttribute("arrivalTime", rs.getTimestamp("arrivalTime"));
                request.setAttribute("origin", rs.getString("origin"));
                request.setAttribute("destination", rs.getString("destination"));
                request.setAttribute("busNumber", rs.getString("busNumber"));
                request.setAttribute("busType", rs.getString("busType"));

                // Fetch Seats
                List<String> seats = new ArrayList<>();
                PreparedStatement st2 = db.connection
                        .prepareStatement("SELECT seatNumber FROM BookingDetails WHERE bookingID = ?");
                st2.setInt(1, bookingID);
                ResultSet rs2 = st2.executeQuery();
                while (rs2.next()) {
                    seats.add(rs2.getString("seatNumber"));
                }
                request.setAttribute("seats", String.join(", ", seats));

                request.getRequestDispatcher("views/public/ticket.jsp").forward(request, response);
            } else {
                response.sendRedirect("home");
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
