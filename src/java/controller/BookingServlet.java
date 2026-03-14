package controller;

import dal.DBContext;
import dal.TripDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Trip;
import model.User;
import service.BookingAccessService;
import service.BookingService;
import service.ServiceException;

@WebServlet(name = "BookingServlet", urlPatterns = { "/booking" })
public class BookingServlet extends HttpServlet {

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

        try {
            int tripID = Integer.parseInt(tripIDStr);
            int ticketCount = (ticketCountStr != null && !ticketCountStr.isEmpty())
                    ? Integer.parseInt(ticketCountStr)
                    : 1;

            TripDAO dao = new TripDAO();
            Trip trip = dao.getTripByID(tripID);

            if (trip == null) {
                response.sendRedirect("home");
                return;
            }

            if (trip.getDepartureTime().before(new Timestamp(System.currentTimeMillis()))) {
                response.sendRedirect("home?error=TripExpired");
                return;
            }

            request.setAttribute("trip", trip);
            request.setAttribute("bookedSeats", getBookedSeats(tripID));

            if (returnTripIDStr != null && !returnTripIDStr.isEmpty()) {
                int returnTripID = Integer.parseInt(returnTripIDStr);
                Trip returnTrip = dao.getTripByID(returnTripID);
                request.setAttribute("returnTrip", returnTrip);
                request.setAttribute("returnBookedSeats", getBookedSeats(returnTripID));
            }

            request.setAttribute("ticketCount", ticketCount);
            request.getRequestDispatcher("views/public/booking.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidTrip");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            int tripID = Integer.parseInt(request.getParameter("tripID"));
            String returnTripIDStr = request.getParameter("returnTripID");
            Integer returnTripID = (returnTripIDStr == null || returnTripIDStr.trim().isEmpty())
                    ? null
                    : Integer.parseInt(returnTripIDStr);

            BookingService.BookingCreationResult result = new BookingService().createBooking(
                    user,
                    tripID,
                    returnTripID,
                    request.getParameter("selectedSeats"),
                    request.getParameter("returnSeats"),
                    request.getParameter("guestName"),
                    request.getParameter("guestPhone"),
                    request.getParameter("guestEmail"));

            if (result.isGuestBooking()) {
                BookingAccessService.grantGuestBookingAccess(session, result.getBookingID());
            }

            response.sendRedirect("payment?bookingID=" + result.getBookingID());
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidTrip");
        } catch (ServiceException ex) {
            String tripID = request.getParameter("tripID");
            String error = URLEncoder.encode(ex.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect("booking?tripID=" + tripID + "&error=" + error);
        }
    }
}
