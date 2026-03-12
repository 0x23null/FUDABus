package controller;

import dal.DBContext;
import java.io.IOException;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StripeSuccessServlet", urlPatterns = { "/stripe-success" })
public class StripeSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIDStr = request.getParameter("bookingID");
        if (bookingIDStr != null) {
            int bookingID = Integer.parseInt(bookingIDStr);
            DBContext db = new DBContext();
            try {
                // Update Status to Paid
                String sql = "UPDATE Bookings SET status = 'Paid' WHERE bookingID = ?";
                PreparedStatement st = db.connection.prepareStatement(sql);
                st.setInt(1, bookingID);
                st.executeUpdate();

                // Log Payment
                String sqlPay = "INSERT INTO Payments (bookingID, amount, paymentMethod, status) VALUES (?, 0, 'Stripe/CC', 'Success')";
                PreparedStatement st2 = db.connection.prepareStatement(sqlPay);
                st2.setInt(1, bookingID);
                st2.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("ticket?id=" + bookingID);
        } else {
            response.sendRedirect("home");
        }
    }
}
