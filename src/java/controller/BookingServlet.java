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
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.BookingSegment;
import model.Trip;
import model.User;
import service.BookingAccessService;
import service.BookingService;
import service.PaymentService;
import service.ServiceException;

@WebServlet(name = "BookingServlet", urlPatterns = { "/booking" })
public class BookingServlet extends HttpServlet {
    private final PaymentService paymentService = new PaymentService();

    private List<String> getBookedSeats(int tripID, Integer editableBookingID) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT bss.seatNumber FROM BookingSegmentSeats bss "
                + "JOIN BookingSegments bs ON bss.segmentID = bs.segmentID "
                + "JOIN Bookings b ON bs.bookingID = b.bookingID "
                + "WHERE bs.tripID = ? AND b.status IN ('Pending', 'Paid')";
        if (editableBookingID != null) {
            sql += " AND b.bookingID <> ?";
        }
        try {
            DBContext db = new DBContext();
            if (db.connection == null) {
                return list;
            }
            try (PreparedStatement st = db.connection.prepareStatement(sql)) {
                st.setInt(1, tripID);
                if (editableBookingID != null) {
                    st.setInt(2, editableBookingID);
                }
                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        list.add(rs.getString("seatNumber"));
                    }
                }
            }
            db.connection.close();
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

        if (tripIDStr == null) {
            response.sendRedirect("home");
            return;
        }

        int adultCount = parseCount(request.getParameter("adultCount"), 1);
        int childCount = parseCount(request.getParameter("childCount"), 0);
        int passengerCount = adultCount + childCount;
        HttpSession session = request.getSession();

        try {
            int tripID = Integer.parseInt(tripIDStr);
            Integer returnTripID = (returnTripIDStr == null || returnTripIDStr.isBlank())
                    ? null
                    : Integer.parseInt(returnTripIDStr);

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

            Booking editableBooking = resolveEditablePendingBooking(session);
            Integer editableBookingID = editableBooking == null ? null : editableBooking.getBookingID();

            request.setAttribute("trip", trip);
            request.setAttribute("bookedSeats", getBookedSeats(tripID, editableBookingID));
            request.setAttribute("editableBookingID", editableBookingID);
            request.setAttribute("preselectedOutboundSeats", resolvePreselectedSeats(editableBooking, "OUTBOUND", tripID));

            if (returnTripID != null) {
                Trip returnTrip = dao.getTripByID(returnTripID);
                request.setAttribute("returnTrip", returnTrip);
                request.setAttribute("returnBookedSeats", getBookedSeats(returnTripID, editableBookingID));
                request.setAttribute("preselectedReturnSeats", resolvePreselectedSeats(editableBooking, "RETURN", returnTripID));
            } else {
                request.setAttribute("preselectedReturnSeats", Collections.emptyList());
            }

            request.setAttribute("adultCount", adultCount);
            request.setAttribute("childCount", childCount);
            request.setAttribute("passengerCount", passengerCount);
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
            int adultCount = parseCount(request.getParameter("adultCount"), 1);
            int childCount = parseCount(request.getParameter("childCount"), 0);

            releaseEditablePendingBooking(session);

            BookingService.BookingCreationResult result = new BookingService().createBooking(
                    user,
                    tripID,
                    returnTripID,
                    adultCount,
                    childCount,
                    request.getParameter("selectedSeats"),
                    request.getParameter("returnSeats"),
                    request.getParameter("guestName"),
                    request.getParameter("guestPhone"),
                    request.getParameter("guestEmail"));

            if (result.isGuestBooking()) {
                BookingAccessService.grantGuestBookingAccess(session, result.getBookingID());
            }
            BookingAccessService.rememberEditablePendingBooking(session, result.getBookingID());

            response.sendRedirect("payment?bookingID=" + result.getBookingID());
        } catch (NumberFormatException ex) {
            response.sendRedirect("home?error=InvalidTrip");
        } catch (ServiceException ex) {
            String tripID = request.getParameter("tripID");
            StringBuilder redirect = new StringBuilder("booking?tripID=").append(tripID);
            if (request.getParameter("returnTripID") != null && !request.getParameter("returnTripID").isBlank()) {
                redirect.append("&returnTripID=").append(request.getParameter("returnTripID"));
            }
            redirect.append("&adultCount=").append(parseCount(request.getParameter("adultCount"), 1));
            redirect.append("&childCount=").append(parseCount(request.getParameter("childCount"), 0));
            redirect.append("&error=")
                    .append(URLEncoder.encode(ex.getMessage(), StandardCharsets.UTF_8));
            response.sendRedirect(redirect.toString());
        }
    }

    private Booking resolveEditablePendingBooking(HttpSession session) {
        Integer editableBookingID = BookingAccessService.getEditablePendingBookingId(session);
        if (editableBookingID == null) {
            return null;
        }

        Booking booking = paymentService.getBookingDetails(editableBookingID);
        if (booking == null || !BookingAccessService.canAccessBooking(session, booking)
                || !"Pending".equalsIgnoreCase(booking.getStatus())) {
            BookingAccessService.clearEditablePendingBooking(session, editableBookingID);
            return null;
        }
        return booking;
    }

    private List<String> resolvePreselectedSeats(Booking booking, String segmentType, Integer expectedTripID) {
        if (booking == null || expectedTripID == null) {
            return Collections.emptyList();
        }

        for (BookingSegment segment : booking.getSegments()) {
            if (segment != null
                    && segmentType.equalsIgnoreCase(segment.getSegmentType())
                    && segment.getTripID() == expectedTripID) {
                return segment.getSeatNumbers() == null ? Collections.emptyList() : segment.getSeatNumbers();
            }
        }
        return Collections.emptyList();
    }

    private void releaseEditablePendingBooking(HttpSession session) {
        Booking editableBooking = resolveEditablePendingBooking(session);
        if (editableBooking == null) {
            return;
        }

        try {
            paymentService.cancelPendingBooking(editableBooking.getBookingID());
        } catch (ServiceException ignored) {
        } finally {
            BookingAccessService.clearEditablePendingBooking(session, editableBooking.getBookingID());
        }
    }

    private int parseCount(String raw, int fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }
}
