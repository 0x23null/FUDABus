package service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.LinkedHashSet;
import java.util.Set;
import model.Booking;
import model.User;

public final class BookingAccessService {
    private static final String GUEST_BOOKING_ACCESS_IDS = "guestBookingAccessIds";
    private static final String EDITABLE_PENDING_BOOKING_ID = "editablePendingBookingId";

    private BookingAccessService() {
    }

    public static void grantGuestBookingAccess(HttpSession session, int bookingId) {
        if (session == null) {
            return;
        }

        session.setAttribute(GUEST_BOOKING_ACCESS_IDS, getGuestBookingAccessIds(session, true));
        getGuestBookingAccessIds(session, true).add(bookingId);
    }


    public static void rememberEditablePendingBooking(HttpSession session, int bookingId) {
        if (session == null) {
            return;
        }
        session.setAttribute(EDITABLE_PENDING_BOOKING_ID, bookingId);
    }

    public static Integer getEditablePendingBookingId(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object raw = session.getAttribute(EDITABLE_PENDING_BOOKING_ID);
        if (raw instanceof Integer) {
            return (Integer) raw;
        }
        if (raw instanceof String) {
            try {
                return Integer.valueOf((String) raw);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    public static void clearEditablePendingBooking(HttpSession session, Integer bookingId) {
        if (session == null) {
            return;
        }

        Integer currentId = getEditablePendingBookingId(session);
        if (bookingId == null || (currentId != null && currentId.equals(bookingId))) {
            session.removeAttribute(EDITABLE_PENDING_BOOKING_ID);
        }
    }
    public static boolean canAccessBooking(HttpSession session, Booking booking) {
        if (booking == null) {
            return false;
        }

        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser != null) {
            if ("Admin".equalsIgnoreCase(currentUser.getRole())) {
                return true;
            }
            return booking.getUserID() > 0 && booking.getUserID() == currentUser.getUserID();
        }

        return getGuestBookingAccessIds(session, false).contains(booking.getBookingID());
    }

    public static boolean isGuestBooking(Booking booking) {
        return booking != null
                && booking.getUser() != null
                && "Guest".equalsIgnoreCase(booking.getUser().getRole());
    }

    public static void rememberRedirectAfterLogin(HttpServletRequest request) {
        if (request == null) {
            return;
        }

        HttpSession session = request.getSession();
        StringBuilder target = new StringBuilder(request.getRequestURI());
        if (request.getQueryString() != null && !request.getQueryString().isEmpty()) {
            target.append("?").append(request.getQueryString());
        }
        session.setAttribute("redirectAfterLogin", target.toString());
    }

    @SuppressWarnings("unchecked")
    private static Set<Integer> getGuestBookingAccessIds(HttpSession session, boolean create) {
        if (session == null) {
            return new LinkedHashSet<>();
        }

        Object raw = session.getAttribute(GUEST_BOOKING_ACCESS_IDS);
        if (raw instanceof Set<?>) {
            return (Set<Integer>) raw;
        }

        if (!create) {
            return new LinkedHashSet<>();
        }

        Set<Integer> ids = new LinkedHashSet<>();
        session.setAttribute(GUEST_BOOKING_ACCESS_IDS, ids);
        return ids;
    }
}
