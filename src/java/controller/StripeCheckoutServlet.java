package controller;

import dal.DBContext;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.StripeUtils;

@WebServlet(name = "StripeCheckoutServlet", urlPatterns = { "/stripe-checkout" })
public class StripeCheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIDStr = request.getParameter("bookingID");
        if (bookingIDStr == null) {
            response.sendRedirect("home");
            return;
        }
        int bookingID = Integer.parseInt(bookingIDStr);
        double amount = 0;
        
        DBContext db = new DBContext();
        try {
            String sql = "SELECT totalPrice FROM Bookings WHERE bookingID = ?";
            PreparedStatement st = db.connection.prepareStatement(sql);
            st.setInt(1, bookingID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                amount = rs.getDouble("totalPrice");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (amount > 0) {
            String name = "Bus Ticket #" + bookingID;
            String checkoutUrl = StripeUtils.createCheckoutSession(bookingID, amount, name);
            if (checkoutUrl != null) {
                response.sendRedirect(checkoutUrl);
                return;
            }
        }
        response.sendRedirect("payment?bookingID=" + bookingID + "&error=StripeFailed");
    }
}
