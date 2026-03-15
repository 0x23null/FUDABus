package controller;

import dal.BusDAO;
import dal.RouteDAO;
import dal.TripDAO;
import dal.BookingDAO;
import model.Booking;
import model.Bus;
import model.Route;
import model.Trip;
import model.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminServlet", urlPatterns = { "/admin", "/admin/buses", "/admin/routes", "/admin/trips",
        "/admin/bookings",
        "/admin/bus/add", "/admin/bus/delete", "/admin/route/add", "/admin/route/delete", "/admin/trip/add",
        "/admin/trip/delete" })
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Simple Admin Check (should be a Filter in production)
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if (path.equals("/admin")) {
            List<Bus> buses = new BusDAO().getAll();
            List<Route> routes = new RouteDAO().getAll();
            List<Trip> trips = new TripDAO().getAll();
            List<Booking> bookings = new BookingDAO().getAllBookings();

            long scheduledTripCount = trips.stream()
                    .filter(trip -> trip != null && "Scheduled".equalsIgnoreCase(trip.getStatus()))
                    .count();
            long pendingBookingCount = bookings.stream()
                    .filter(booking -> booking != null && "Pending".equalsIgnoreCase(booking.getStatus()))
                    .count();
            double paidRevenue = bookings.stream()
                    .filter(booking -> booking != null && "Paid".equalsIgnoreCase(booking.getStatus()))
                    .mapToDouble(Booking::getTotalPrice)
                    .sum();

            request.setAttribute("busCount", buses.size());
            request.setAttribute("routeCount", routes.size());
            request.setAttribute("tripCount", trips.size());
            request.setAttribute("scheduledTripCount", scheduledTripCount);
            request.setAttribute("bookingCount", bookings.size());
            request.setAttribute("pendingBookingCount", pendingBookingCount);
            request.setAttribute("paidRevenue", paidRevenue);
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        } else if (path.equals("/admin/buses")) {
            BusDAO busDAO = new BusDAO();
            List<Bus> list = busDAO.getAll();
            request.setAttribute("buses", list);
            request.getRequestDispatcher("/views/admin/bus-list.jsp").forward(request, response);
        } else if (path.equals("/admin/routes")) {
            RouteDAO routeDAO = new RouteDAO();
            List<Route> list = routeDAO.getAll();
            request.setAttribute("routes", list);
            request.getRequestDispatcher("/views/admin/route-list.jsp").forward(request, response);
        } else if (path.equals("/admin/trips")) {
            TripDAO tripDAO = new TripDAO();
            List<Trip> list = tripDAO.getAll();

            // Need lists for Dropdowns in Add Form
            request.setAttribute("trips", list);
            request.setAttribute("buses", new BusDAO().getAll());
            request.setAttribute("routes", new RouteDAO().getAll());

            request.getRequestDispatcher("/views/admin/trip-list.jsp").forward(request, response);
        } else if (path.equals("/admin/bookings")) {
            dal.BookingDAO bookingDAO = new dal.BookingDAO();
            List<model.Booking> list = bookingDAO.getAllBookings();
            request.setAttribute("bookings", list);
            request.getRequestDispatcher("/views/admin/booking-list.jsp").forward(request, response);
        } else if (path.equals("/admin/bus/delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            new BusDAO().delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/buses");
        } else if (path.equals("/admin/route/delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            new RouteDAO().delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/routes");
        } else if (path.equals("/admin/trip/delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            new TripDAO().delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/trips");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        request.setCharacterEncoding("UTF-8");

        if (path.equals("/admin/bus/add")) {
            String number = request.getParameter("busNumber");
            int capacity = Integer.parseInt(request.getParameter("seatCapacity"));
            String type = request.getParameter("busType");
            String img = request.getParameter("imageURL");

            Bus b = new Bus(0, number, capacity, type, img);
            new BusDAO().insert(b);
            response.sendRedirect(request.getContextPath() + "/admin/buses");

        } else if (path.equals("/admin/route/add")) {
            String origin = request.getParameter("origin");
            String dest = request.getParameter("destination");
            double dist = Double.parseDouble(request.getParameter("distance"));
            int duration = Integer.parseInt(request.getParameter("duration"));
            String desc = request.getParameter("description");

            Route r = new Route(0, origin, dest, dist, duration, desc);
            new RouteDAO().insert(r);
            response.sendRedirect(request.getContextPath() + "/admin/routes");

        } else if (path.equals("/admin/trip/add")) {
            int routeID = Integer.parseInt(request.getParameter("routeID"));
            int busID = Integer.parseInt(request.getParameter("busID"));
            String depStr = request.getParameter("departureTime"); // 2023-10-27T10:00
            double priceInput = Double.parseDouble(request.getParameter("price"));

            // Price is input in thousands (k VNĐ), so multiply by 1000
            double price = priceInput * 1000;

            // Calculate Arrival Time based on Route Duration
            Route route = new RouteDAO().getRouteByID(routeID);
            LocalDateTime dep = LocalDateTime.parse(depStr);
            LocalDateTime arr = dep.plusMinutes(route.getDuration());

            Trip t = new Trip(0, routeID, busID, Timestamp.valueOf(dep), Timestamp.valueOf(arr), price, "Scheduled");
            new TripDAO().insert(t);
            response.sendRedirect(request.getContextPath() + "/admin/trips");
        }
    }
}
