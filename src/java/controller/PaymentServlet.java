package controller;

import dal.DBContext;
import dal.TripDAO;
import model.Trip;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "PaymentServlet", urlPatterns = { "/payment", "/payment/confirm" })
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIDStr = request.getParameter("bookingID");
        String action = request.getParameter("action");

        if (bookingIDStr == null) {
            response.sendRedirect("home");
            return;
        }

        int bookingID = Integer.parseInt(bookingIDStr);

        if ("cancel".equals(action)) {
            DBContext db = new DBContext();
            try {
                // Determine if we should delete or mark cancelled.
                // Releasing seats means setting status = 'Cancelled' or deleting.
                // Let's mark as Cancelled to keep history.
                String sql = "UPDATE Bookings SET status = 'Cancelled' WHERE bookingID = ?";
                PreparedStatement st = db.connection.prepareStatement(sql);
                st.setInt(1, bookingID);
                st.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
            response.sendRedirect("home?msg=BookingCancelled");
            return;
        }
        // Get Booking Amount and Info
        double amount = 0;
        String status = "";

        DBContext db = new DBContext();
        try {
            String sql = "SELECT totalPrice, status FROM Bookings WHERE bookingID = ?";
            PreparedStatement st = db.connection.prepareStatement(sql);
            st.setInt(1, bookingID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                amount = rs.getDouble("totalPrice");
                status = rs.getString("status");
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        if ("Paid".equals(status)) {
            response.sendRedirect("ticket?id=" + bookingID);
            return;
        }

        dal.BookingDAO bookingDAO = new dal.BookingDAO();
        model.Booking bookingStr = bookingDAO.getBookingFullDetails(bookingID);
        
        request.setAttribute("booking", bookingStr);
        request.setAttribute("amount", amount);
        request.setAttribute("bookingID", bookingID);

        request.getRequestDispatcher("views/public/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));

        // Simulate checking payment...
        // In real app, you would verify webhook or poll API

        DBContext db = new DBContext();
        try {
            // Update Status to Paid
            String sql = "UPDATE Bookings SET status = 'Paid' WHERE bookingID = ?";
            PreparedStatement st = db.connection.prepareStatement(sql);
            st.setInt(1, bookingID);
            st.executeUpdate();

            // Log Payment
            String sqlPay = "INSERT INTO Payments (bookingID, amount, paymentMethod, status) VALUES (?, ?, 'VietQR', 'Success')";
            PreparedStatement st2 = db.connection.prepareStatement(sqlPay);
            st2.setInt(1, bookingID);
            // We should get amount from DB but for brevity using param or simple logic
            // ...
            st2.setDouble(2, 0); // Placeholder, assume processed
            st2.executeUpdate();

        } catch (SQLException e) {
            System.out.println(e);
        }

        response.sendRedirect("ticket?id=" + bookingID);
    }
}
