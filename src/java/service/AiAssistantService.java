package service;

import dal.BookingDAO;
import dal.TripDAO;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.Normalizer;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import model.AiChatMessage;
import model.Booking;
import model.Route;
import model.Trip;
import model.User;

public class AiAssistantService {
    private static final String HISTORY_KEY = "aiChatHistory";
    private static final String LAST_BOOKING_KEY = "aiLastBooking";
    private static final int MAX_HISTORY_MESSAGES = 8;
    private static final DateTimeFormatter SEARCH_DATE = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DISPLAY_DATE_TIME = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
    private static final ZoneId APP_ZONE = ZoneId.of("Asia/Bangkok");
    private static final Pattern TICKET_CODE_PATTERN = Pattern.compile("TKT-[A-Z0-9]{4,}", Pattern.CASE_INSENSITIVE);
    private static final Pattern PHONE_PATTERN = Pattern.compile("(?:0|84)\\d{8,10}");
    private static final Pattern ISO_DATE_PATTERN = Pattern.compile("(20\\d{2}-\\d{2}-\\d{2})");
    private static final Pattern SLASH_DATE_PATTERN = Pattern.compile("(\\d{1,2}/\\d{1,2}(?:/\\d{4})?)");

    private static final String SYSTEM_PROMPT = String.join("\n",
            "Bạn là FUDA AI Assistant, trợ lý chăm sóc khách hàng của website đặt vé xe.",
            "Mục tiêu của bạn là hỗ trợ người dùng đặt vé, tra cứu vé, hỏi về thanh toán và chính sách cơ bản.",
            "Chỉ sử dụng thông tin có trong phần NGỮ CẢNH HỆ THỐNG được cung cấp.",
            "Nếu dữ liệu còn thiếu, hãy nói rõ là bạn chưa đủ thông tin và hỏi 1 câu ngắn để làm rõ.",
            "Không bịa mã vé, giờ xe, trạng thái thanh toán hay chính sách ngoài ngữ cảnh.",
            "Ưu tiên trả lời bằng tiếng Việt, giọng chat tự nhiên, thân thiện, xưng mình - bạn.",
            "Không lặp lại tên FUAI ở đầu mỗi câu và không mở đầu bằng đoạn chào hỏi dài khi người dùng đã hỏi thẳng.",
            "Nếu người dùng hỏi có tuyến hoặc có chuyến giữa hai nơi không, hãy trả lời trực tiếp là có hay chưa có trước, rồi mới gợi ý bước tiếp theo.",
            "Khi nhắc lại hành trình, luôn giữ đúng chiều người dùng hỏi.",
            "Nếu người dùng đang hỏi tiếp về cùng một vé, hãy giữ nguyên ngữ cảnh vé đó.",
            "Nếu người dùng hỏi về hoàn vé, hủy vé, đổi vé hoặc thanh toán, hãy ưu tiên giải thích bước tiếp theo thật rõ ràng.");

    private final BookingDAO bookingDAO = new BookingDAO();
    private final TripDAO tripDAO = new TripDAO();
    private final ZaiChatClient zaiChatClient = new ZaiChatClient();

    public String reply(String message, String currentPath, User currentUser, HttpSession session) {
        String normalizedMessage = normalizeWhitespace(message);
        if (normalizedMessage.isBlank()) {
            return "Bạn cứ nhắn như tìm chuyến, tra cứu vé hoặc hỏi thanh toán, mình hỗ trợ ngay.";
        }

        SupportSnapshot snapshot = buildSnapshot(normalizedMessage, currentPath, currentUser, session);
        String response = buildPriorityReply(normalizeText(normalizedMessage), snapshot);

        if (response == null) {
            List<AiChatMessage> payload = buildConversation(normalizedMessage, snapshot, session);
            try {
                response = zaiChatClient.chat(payload);
            } catch (IOException ignored) {
            }
        }

        if (response == null || response.isBlank()) {
            response = buildFallbackReply(normalizedMessage, snapshot);
        }

        if (snapshot.activeBooking != null && session != null) {
            session.setAttribute(LAST_BOOKING_KEY, snapshot.activeBooking);
        }
        storeHistory(session, normalizedMessage, response);
        return response;
    }

    private List<AiChatMessage> buildConversation(String currentMessage, SupportSnapshot snapshot, HttpSession session) {
        List<AiChatMessage> messages = new ArrayList<>();
        messages.add(new AiChatMessage("system", SYSTEM_PROMPT));
        messages.add(new AiChatMessage("system", snapshot.context));
        messages.addAll(getHistory(session));
        messages.add(new AiChatMessage("user", currentMessage));
        return messages;
    }

    private SupportSnapshot buildSnapshot(String message, String currentPath, User currentUser, HttpSession session) {
        SupportSnapshot snapshot = new SupportSnapshot();
        String normalized = normalizeText(message);
        Booking sessionBooking = getLastBooking(session);

        StringBuilder context = new StringBuilder();
        context.append("NGỮ CẢNH HỆ THỐNG\n");
        context.append("Trang hiện tại: ").append(resolvePageLabel(currentPath)).append("\n\n");
        context.append("KHẢ NĂNG HỆ THỐNG\n");
        context.append("- Đặt vé một chiều và khứ hồi\n");
        context.append("- Chọn ghế theo từng chặng\n");
        context.append("- Thanh toán bằng VNPay sandbox và Stripe sandbox\n");
        context.append("- Khách có thể xem vé điện tử sau khi thanh toán\n\n");
        context.append("FAQ NỘI BỘ\n");
        context.append("- Trẻ em được tính 70% giá vé người lớn và vẫn cần ghế riêng.\n");
        context.append("- Nếu thanh toán chưa hoàn tất, đơn thường ở trạng thái Pending.\n");
        context.append("- User có thể hủy đơn Pending ở trang thanh toán.\n");
        context.append("- Vé đã thanh toán có thể xem lại ở trang lịch sử hoặc trang chi tiết vé.\n");
        context.append("- Nếu không tìm thấy dữ liệu thật, phải nói rõ là chưa tìm thấy.\n\n");

        if (currentUser != null) {
            context.append("NGƯỜI DÙNG ĐĂNG NHẬP\n");
            context.append("- Họ tên: ").append(safe(currentUser.getFullName(), currentUser.getUsername())).append("\n");
            context.append("- Email: ").append(safe(currentUser.getEmail(), "Không rõ")).append("\n");
            context.append("- Vai trò: ").append(safe(currentUser.getRole(), "Customer")).append("\n");
            List<Booking> recentBookings = bookingDAO.getBookingsByUserID(currentUser.getUserID());
            snapshot.recentBookings = limitBookings(recentBookings, 3);
            if (!snapshot.recentBookings.isEmpty()) {
                context.append("- 3 đơn gần nhất:\n");
                for (Booking booking : snapshot.recentBookings) {
                    context.append("  * ").append(formatBookingSummary(booking)).append("\n");
                }
            }
            context.append("\n");
        }

        snapshot.requestedTicketCode = extractTicketCode(message);
        snapshot.ticketBooking = resolveBookingByTicketCode(message);
        if (snapshot.ticketBooking != null) {
            snapshot.activeBooking = snapshot.ticketBooking;
            context.append("TRA CỨU THEO MÃ VÉ\n");
            context.append(formatBookingContext(snapshot.ticketBooking)).append("\n\n");
        }

        snapshot.phoneBookings = resolveBookingsByPhone(message);
        if (!snapshot.phoneBookings.isEmpty()) {
            if (snapshot.activeBooking == null) {
                snapshot.activeBooking = snapshot.phoneBookings.get(0);
            }
            context.append("TRA CỨU THEO SỐ ĐIỆN THOẠI\n");
            for (Booking booking : snapshot.phoneBookings) {
                context.append("- ").append(formatBookingSummary(booking)).append("\n");
            }
            context.append("\n");
        }

        if (snapshot.activeBooking == null && isBookingFollowUpIntent(normalized) && sessionBooking != null && !isTripSearchIntent(normalized)) {
            snapshot.activeBooking = sessionBooking;
        }

        if (snapshot.activeBooking == null && isBookingFollowUpIntent(normalized) && !snapshot.recentBookings.isEmpty() && !isTripSearchIntent(normalized)) {
            snapshot.activeBooking = snapshot.recentBookings.get(0);
        }

        if (snapshot.activeBooking != null && snapshot.ticketBooking == null) {
            context.append("ĐƠN ĐANG ĐƯỢC NHẮC TỚI\n");
            context.append(formatBookingContext(snapshot.activeBooking)).append("\n\n");
        }

        snapshot.routeOnly = resolveRouteMention(message);
        snapshot.cityMentions = extractCityMentions(message);
        snapshot.tripSearch = resolveTripSearch(message, snapshot.routeOnly);
        if (snapshot.tripSearch != null) {
            context.append("KẾT QUẢ TÌM CHUYẾN\n");
            context.append("- Hành trình: ").append(snapshot.tripSearch.route.getOrigin())
                    .append(" -> ").append(snapshot.tripSearch.route.getDestination()).append("\n");
            context.append("- Ngày đi: ").append(snapshot.tripSearch.date.format(SEARCH_DATE)).append("\n");
            if (snapshot.tripSearch.trips.isEmpty()) {
                context.append("- Không tìm thấy chuyến phù hợp.\n\n");
            } else {
                for (Trip trip : snapshot.tripSearch.trips) {
                    context.append("- ").append(formatTripSummary(trip)).append("\n");
                }
                context.append("\n");
            }
        } else if (snapshot.routeOnly != null && (isTripSearchIntent(normalized) || isRouteAvailabilityIntent(normalized))) {
            context.append("NHẬN DIỆN HÀNH TRÌNH\n");
            context.append("- Hành trình đang nhắc tới: ")
                    .append(snapshot.routeOnly.getOrigin()).append(" -> ")
                    .append(snapshot.routeOnly.getDestination()).append("\n\n");
        }

        snapshot.context = context.toString();
        return snapshot;
    }

    private String extractTicketCode(String message) {
        Matcher matcher = TICKET_CODE_PATTERN.matcher(message);
        if (!matcher.find()) {
            return null;
        }
        return matcher.group().toUpperCase(Locale.ROOT);
    }

    private Booking resolveBookingByTicketCode(String message) {
        String ticketCode = extractTicketCode(message);
        if (ticketCode == null) {
            return null;
        }
        return bookingDAO.getBookingByTicketCode(ticketCode);
    }

    private List<Booking> resolveBookingsByPhone(String message) {
        Matcher matcher = PHONE_PATTERN.matcher(message.replaceAll("\\s+", ""));
        if (!matcher.find()) {
            return new ArrayList<>();
        }
        return bookingDAO.getBookingsByPhoneNumber(matcher.group(), 3);
    }

    private Route resolveRouteMention(String message) {
        String normalized = normalizeText(message);
        Route matchedRoute = null;
        int bestScore = -1;
        int bestDirectionScore = -1;
        for (Route route : tripDAO.getAllRoutes()) {
            String origin = normalizeText(route.getOrigin());
            String destination = normalizeText(route.getDestination());
            int originIndex = normalized.indexOf(origin);
            int destinationIndex = normalized.indexOf(destination);
            if (originIndex >= 0 && destinationIndex >= 0) {
                int score = origin.length() + destination.length();
                int directionScore = originIndex < destinationIndex ? 1 : 0;
                if (score > bestScore || (score == bestScore && directionScore > bestDirectionScore)) {
                    matchedRoute = route;
                    bestScore = score;
                    bestDirectionScore = directionScore;
                }
            }
        }
        return matchedRoute;
    }

    private List<String> extractCityMentions(String message) {
        String normalized = normalizeText(message);
        List<CityMention> mentions = new ArrayList<>();
        LinkedHashSet<String> seen = new LinkedHashSet<>();
        for (Route route : tripDAO.getAllRoutes()) {
            collectCityMention(mentions, seen, normalized, route.getOrigin());
            collectCityMention(mentions, seen, normalized, route.getDestination());
        }
        mentions.sort((left, right) -> Integer.compare(left.position, right.position));

        List<String> orderedMentions = new ArrayList<>();
        for (CityMention mention : mentions) {
            orderedMentions.add(mention.name);
            if (orderedMentions.size() >= 2) {
                break;
            }
        }
        return orderedMentions;
    }

    private void collectCityMention(List<CityMention> mentions, LinkedHashSet<String> seen, String normalizedMessage, String city) {
        if (city == null || city.isBlank() || seen.contains(city)) {
            return;
        }
        int position = normalizedMessage.indexOf(normalizeText(city));
        if (position >= 0) {
            mentions.add(new CityMention(city, position));
            seen.add(city);
        }
    }

    private TripSearchSnapshot resolveTripSearch(String message, Route preMatchedRoute) {
        LocalDate date = extractDate(message);
        if (date == null) {
            return null;
        }

        Route matchedRoute = preMatchedRoute != null ? preMatchedRoute : resolveRouteMention(message);
        if (matchedRoute == null) {
            return null;
        }

        List<Trip> trips = tripDAO.searchTrips(matchedRoute.getOrigin(), matchedRoute.getDestination(), date.format(SEARCH_DATE));
        TripSearchSnapshot snapshot = new TripSearchSnapshot();
        snapshot.route = matchedRoute;
        snapshot.date = date;
        snapshot.trips = limitTrips(trips, 4);
        return snapshot;
    }

    private LocalDate extractDate(String message) {
        LocalDate today = LocalDate.now(APP_ZONE);
        String normalized = normalizeText(message);
        if (normalized.contains("hom nay")) {
            return today;
        }
        if (normalized.contains("ngay mai") || normalized.contains("mai")) {
            return today.plusDays(1);
        }

        Matcher isoMatcher = ISO_DATE_PATTERN.matcher(message);
        if (isoMatcher.find()) {
            try {
                return LocalDate.parse(isoMatcher.group(1), SEARCH_DATE);
            } catch (DateTimeParseException ignored) {
            }
        }

        Matcher slashMatcher = SLASH_DATE_PATTERN.matcher(message);
        if (slashMatcher.find()) {
            String raw = slashMatcher.group(1);
            String[] parts = raw.split("/");
            try {
                int day = Integer.parseInt(parts[0]);
                int month = Integer.parseInt(parts[1]);
                int year = parts.length >= 3 ? Integer.parseInt(parts[2]) : today.getYear();
                return LocalDate.of(year, month, day);
            } catch (RuntimeException ignored) {
            }
        }
        return null;
    }

    private String buildPriorityReply(String normalized, SupportSnapshot snapshot) {
        if (isGreeting(normalized)) {
            return "Chào bạn, mình là FUAI của FUDA Bus. Bạn muốn tìm chuyến, tra cứu vé hay cần hỗ trợ thanh toán?";
        }

        if (snapshot.requestedTicketCode != null && snapshot.ticketBooking == null) {
            return "Mình chưa tìm thấy vé " + snapshot.requestedTicketCode + ". Bạn kiểm tra lại mã vé hoặc gửi số điện thoại đặt vé để mình tìm tiếp nhé.";
        }

        if (snapshot.ticketBooking != null) {
            return buildBookingLookupReply(snapshot.ticketBooking);
        }

        if (!snapshot.phoneBookings.isEmpty()) {
            StringBuilder builder = new StringBuilder("Mình tìm thấy vài đơn gần nhất theo số điện thoại bạn gửi:\n");
            for (Booking booking : snapshot.phoneBookings) {
                builder.append("- ").append(formatBookingSummary(booking)).append("\n");
            }
            builder.append("Bạn muốn mình kiểm tra kỹ đơn nào?");
            return builder.toString().trim();
        }

        if (snapshot.tripSearch != null) {
            if (snapshot.tripSearch.trips.isEmpty()) {
                return "Hiện mình chưa thấy chuyến phù hợp cho tuyến "
                        + snapshot.tripSearch.route.getOrigin() + " - " + snapshot.tripSearch.route.getDestination()
                        + " vào ngày " + snapshot.tripSearch.date.format(SEARCH_DATE)
                        + ". Bạn thử đổi ngày hoặc nhắn tuyến khác nhé.";
            }
            StringBuilder builder = new StringBuilder("Mình tìm được các chuyến này:\n");
            for (Trip trip : snapshot.tripSearch.trips) {
                builder.append("- ").append(formatTripSummary(trip)).append("\n");
            }
            builder.append("Nếu muốn, mình lọc tiếp theo giờ đi hoặc mức giá cho bạn.");
            return builder.toString().trim();
        }

        if (snapshot.activeBooking != null && isBookingFollowUpIntent(normalized) && !isTripSearchIntent(normalized)) {
            return buildBookingFollowUpReply(snapshot.activeBooking, normalized);
        }

        if (snapshot.routeOnly != null && (isRouteAvailabilityIntent(normalized) || isTripSearchIntent(normalized))) {
            return buildRouteAvailableReply(snapshot.routeOnly);
        }

        if (snapshot.cityMentions.size() >= 2 && (isRouteAvailabilityIntent(normalized) || isTripSearchIntent(normalized))) {
            return buildRouteUnavailableReply(snapshot.cityMentions.get(0), snapshot.cityMentions.get(1));
        }

        if (containsAny(normalized, "tre em", "nguoi lon", "hanh khach")) {
            return "Hiện tại trẻ em được tính 70% giá vé người lớn và vẫn cần ghế riêng. Nếu cần, mình có thể gợi ý cách chọn số lượng hành khách cho đúng.";
        }

        if (containsAny(normalized, "thanh toan", "vnpay", "stripe", "qr")) {
            return "Nếu thanh toán chưa xong thì đơn thường vẫn ở trạng thái chờ thanh toán. Bạn có thể mở lại trang thanh toán để thử lại, hoặc gửi mã vé hay số điện thoại để mình kiểm tra giúp.";
        }

        if (containsAny(normalized, "thoi tiet", "du lich", "di choi", "o dau dep")) {
            return "Mình đang hỗ trợ chính về tìm chuyến, tra cứu vé và thanh toán trên FUDA Bus. Nếu muốn, mình vẫn có thể gợi ý vài tuyến du lịch phổ biến cho bạn.";
        }

        return null;
    }

    private String buildFallbackReply(String message, SupportSnapshot snapshot) {
        String normalized = normalizeText(message);

        if (isGreeting(normalized)) {
            return "Chào bạn, mình là FUAI của FUDA Bus. Bạn muốn tìm chuyến, tra cứu vé hay cần hỗ trợ thanh toán?";
        }

        if (snapshot.requestedTicketCode != null && snapshot.ticketBooking == null) {
            return "Mình chưa tìm thấy vé " + snapshot.requestedTicketCode + ". Bạn kiểm tra lại mã vé hoặc gửi số điện thoại đặt vé để mình tìm tiếp nhé.";
        }

        if (snapshot.ticketBooking != null) {
            return buildBookingLookupReply(snapshot.ticketBooking);
        }

        if (!snapshot.phoneBookings.isEmpty()) {
            StringBuilder builder = new StringBuilder("Mình tìm thấy vài đơn gần nhất theo số điện thoại bạn gửi:\n");
            for (Booking booking : snapshot.phoneBookings) {
                builder.append("- ").append(formatBookingSummary(booking)).append("\n");
            }
            builder.append("Bạn muốn mình kiểm tra kỹ đơn nào?");
            return builder.toString().trim();
        }

        if (snapshot.tripSearch != null) {
            if (snapshot.tripSearch.trips.isEmpty()) {
                return "Hiện mình chưa thấy chuyến phù hợp cho tuyến "
                        + snapshot.tripSearch.route.getOrigin() + " - " + snapshot.tripSearch.route.getDestination()
                        + " vào ngày " + snapshot.tripSearch.date.format(SEARCH_DATE) + ". Bạn thử đổi ngày hoặc nhắn tuyến khác nhé.";
            }
            StringBuilder builder = new StringBuilder("Mình tìm được các chuyến này:\n");
            for (Trip trip : snapshot.tripSearch.trips) {
                builder.append("- ").append(formatTripSummary(trip)).append("\n");
            }
            builder.append("Nếu muốn, mình lọc tiếp theo giờ đi hoặc mức giá cho bạn.");
            return builder.toString().trim();
        }

        if (snapshot.routeOnly != null && (isRouteAvailabilityIntent(normalized) || isTripSearchIntent(normalized))) {
            return "Có nhé, bên mình đang có tuyến " + snapshot.routeOnly.getOrigin() + " - " + snapshot.routeOnly.getDestination()
                    + ". Bạn muốn đi ngày nào để mình tìm chuyến phù hợp luôn?";
        }

        if (snapshot.cityMentions.size() >= 2 && (isRouteAvailabilityIntent(normalized) || isTripSearchIntent(normalized))) {
            return "Hiện mình chưa thấy tuyến trực tiếp " + snapshot.cityMentions.get(0) + " - " + snapshot.cityMentions.get(1)
                    + " trong hệ thống. Nếu muốn, mình có thể gợi ý tuyến gần nhất hoặc kiểm tra hành trình khác cho bạn.";
        }

        if (snapshot.activeBooking != null && isBookingFollowUpIntent(normalized) && !isTripSearchIntent(normalized)) {
            return buildBookingFollowUpReply(snapshot.activeBooking, normalized);
        }

        if (containsAny(normalized, "thoi tiet", "du lich", "di choi", "o dau dep")) {
            return "Mình đang hỗ trợ chính về tìm chuyến, tra cứu vé và thanh toán trên FUDA Bus. Nếu muốn, mình vẫn có thể gợi ý vài tuyến du lịch phổ biến cho bạn.";
        }

        if (containsAny(normalized, "tre em", "nguoi lon", "hanh khach")) {
            return "Hiện tại trẻ em được tính 70% giá vé người lớn và vẫn cần ghế riêng. Nếu cần, mình có thể gợi ý cách chọn số lượng hành khách cho đúng.";
        }

        if (containsAny(normalized, "thanh toan", "vnpay", "stripe", "qr")) {
            return "Nếu thanh toán chưa xong thì đơn thường vẫn ở trạng thái chờ thanh toán. Bạn có thể mở lại trang thanh toán để thử lại, hoặc gửi mã vé hay số điện thoại để mình kiểm tra giúp.";
        }

        return "Mình có thể giúp bạn tìm chuyến, tra cứu vé theo mã vé hoặc số điện thoại, và hỗ trợ thanh toán. Bạn cứ nhắn kiểu như 'Có tuyến Hà Nội đi Đà Nẵng không?', 'Tìm chuyến Hà Nội đi Đà Nẵng ngày 2026-03-16' hoặc 'Tra cứu vé TKT-ABCD1234'.";
    }

    private String buildBookingLookupReply(Booking booking) {
        StringBuilder builder = new StringBuilder();
        builder.append("Mình đã tìm thấy vé ").append(safe(booking.getTicketCode(), "không rõ mã")).append(".\n");
        builder.append("- Trạng thái: ").append(humanizeStatus(booking.getStatus())).append("\n");
        builder.append("- Hành trình: ").append(formatRouteLabel(booking)).append("\n");
        String busNumber = extractBusNumber(booking);
        if (busNumber != null) {
            builder.append("- Biển số xe: ").append(busNumber).append("\n");
        }
        builder.append("- Tổng tiền: ").append(maskPrice(booking.getTotalPrice())).append("\n");
        if (booking.getUser() != null && booking.getUser().getPhoneNumber() != null) {
            builder.append("- Số điện thoại: ").append(maskPhone(booking.getUser().getPhoneNumber())).append("\n");
        }
        builder.append("Nếu cần, bạn có thể hỏi tiếp về thanh toán, đổi vé hoặc hoàn vé của đơn này.");
        return builder.toString().trim();
    }

    private String buildBookingFollowUpReply(Booking booking, String normalizedMessage) {
        String code = safe(booking.getTicketCode(), "đơn hiện tại");
        String route = formatRouteLabel(booking);
        String status = humanizeStatus(booking.getStatus());

        if (containsAny(normalizedMessage, "huong dan", "cach hoan", "lam sao hoan", "hoan tien di", "hoan tien", "hoan ve") && !containsAny(normalizedMessage, "doi")) {
            return "Với vé " + code + " cho hành trình " + route + ", bạn có thể làm theo 3 bước: chuẩn bị mã vé và số điện thoại đặt vé, gửi yêu cầu hỗ trợ hoàn vé cho bộ phận chăm sóc khách hàng, rồi chờ hệ thống xác nhận xử lý. Website hiện chưa hỗ trợ tự hoàn vé trực tiếp. Nếu muốn, mình có thể giúp bạn soạn sẵn nội dung yêu cầu.";
        }

        if (containsAny(normalizedMessage, "hoan", "huy", "doi")) {
            if ("Pending".equalsIgnoreCase(booking.getStatus())) {
                return "Mình đã kiểm tra vé " + code + " cho hành trình " + route
                        + ". Vé này hiện đang ở trạng thái " + status
                        + ", nên bạn có thể mở lại trang thanh toán để hủy đơn ngay trên hệ thống. Nếu cần, mình hướng dẫn từng bước luôn.";
            }
            return "Mình đã kiểm tra vé " + code + " cho hành trình " + route
                    + ". Vé này hiện ở trạng thái " + status
                    + ". Với vé đã thanh toán, hệ thống chưa hỗ trợ tự hoàn vé trực tiếp trên web. Nếu muốn, mình có thể hướng dẫn bước tiếp theo.";
        }

        if (containsAny(normalizedMessage, "cach", "lam sao", "duoc khong", "the nao")) {
            return "Với vé " + code + " cho hành trình " + route
                    + ", hiện hệ thống chưa hỗ trợ hoàn vé trực tiếp trên web. Cách phù hợp nhất là gửi yêu cầu hỗ trợ để bộ phận chăm sóc khách hàng kiểm tra thêm. Nếu muốn, mình có thể hướng dẫn ngay bước tiếp theo.";
        }

        if (containsAny(normalizedMessage, "thanh toan", "paid", "pending", "trang thai", "da thanh toan", "chua thanh toan")) {
            return "Vé " + code + " hiện ở trạng thái " + status + " cho hành trình " + route + ". Nếu cần, mình có thể hướng dẫn bước tiếp theo phù hợp với trạng thái này.";
        }

        return "Mình vẫn đang theo dõi vé " + code + " cho hành trình " + route
                + ". Bạn muốn mình hỗ trợ về thanh toán, hoàn vé hay thông tin chuyến đi?";
    }

    private void storeHistory(HttpSession session, String userMessage, String assistantMessage) {
        List<AiChatMessage> history = getHistory(session);
        history.add(new AiChatMessage("user", userMessage));
        history.add(new AiChatMessage("assistant", assistantMessage));
        while (history.size() > MAX_HISTORY_MESSAGES) {
            history.remove(0);
        }
        if (session != null) {
            session.setAttribute(HISTORY_KEY, history);
        }
    }

    @SuppressWarnings("unchecked")
    private List<AiChatMessage> getHistory(HttpSession session) {
        if (session == null) {
            return new ArrayList<>();
        }
        Object raw = session.getAttribute(HISTORY_KEY);
        if (raw instanceof List<?>) {
            return (List<AiChatMessage>) raw;
        }
        List<AiChatMessage> history = new ArrayList<>();
        session.setAttribute(HISTORY_KEY, history);
        return history;
    }

    private Booking getLastBooking(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object raw = session.getAttribute(LAST_BOOKING_KEY);
        if (raw instanceof Booking) {
            return (Booking) raw;
        }
        return null;
    }

    private boolean isGreeting(String normalized) {
        return normalized.equals("xin chao")
                || normalized.equals("hello")
                || normalized.equals("hi")
                || normalized.equals("chao")
                || normalized.equals("alo");
    }

    private boolean isTripSearchIntent(String normalized) {
        return containsAny(normalized,
                "tim chuyen", "tim tuyen", "lich trinh", "chuyen nao", "tuyen nao", "dat ve di",
                "di ha noi", "di da nang", "di da lat", "di kon tum");
    }

    private boolean isRouteAvailabilityIntent(String normalized) {
        if (containsAny(normalized, "co tuyen", "co chuyen", "con tuyen", "con chuyen", "co xe", "con xe")) {
            return true;
        }
        return normalized.contains("khong") && containsAny(normalized, "tuyen", "chuyen");
    }

    private boolean isBookingFollowUpIntent(String normalized) {
        return containsAny(normalized,
                "ve nay", "ve cua toi", "don nay", "ma ve", "thanh toan", "paid", "pending",
                "huy ve", "huy don", "hoan ve", "hoan tien", "doi ve", "trang thai",
                "hoan", "huy", "doi", "cach hoan", "cach huy", "duoc khong", "the nao", "lam sao", "huong dan");
    }

    private List<Booking> limitBookings(List<Booking> bookings, int limit) {
        List<Booking> limited = new ArrayList<>();
        for (Booking booking : bookings) {
            limited.add(booking);
            if (limited.size() >= limit) {
                break;
            }
        }
        return limited;
    }

    private List<Trip> limitTrips(List<Trip> trips, int limit) {
        List<Trip> limited = new ArrayList<>();
        for (Trip trip : trips) {
            limited.add(trip);
            if (limited.size() >= limit) {
                break;
            }
        }
        return limited;
    }

    private String resolvePageLabel(String currentPath) {
        if (currentPath == null || currentPath.isBlank()) {
            return "Không rõ";
        }
        if (currentPath.contains("payment")) {
            return "Trang thanh toán";
        }
        if (currentPath.contains("booking")) {
            return "Trang chọn ghế";
        }
        if (currentPath.contains("ticket")) {
            return "Trang chi tiết vé";
        }
        if (currentPath.contains("support")) {
            return "Trang hỗ trợ";
        }
        if (currentPath.contains("search")) {
            return "Trang kết quả tìm chuyến";
        }
        return "Trang chung";
    }

    private String formatTripSummary(Trip trip) {
        String origin = trip.getRoute() != null ? safe(trip.getRoute().getOrigin(), "Không rõ") : "Không rõ";
        String destination = trip.getRoute() != null ? safe(trip.getRoute().getDestination(), "Không rõ") : "Không rõ";
        String busType = trip.getBus() != null ? safe(trip.getBus().getBusType(), "Không rõ") : "Không rõ";
        if (trip.getDepartureTime() == null) {
            return origin + " -> " + destination + " | " + maskPrice(trip.getPrice()) + " | " + busType;
        }
        return origin + " -> " + destination
                + " | " + trip.getDepartureTime().toLocalDateTime().format(DISPLAY_DATE_TIME)
                + " | " + maskPrice(trip.getPrice())
                + " | " + busType;
    }

    private String formatBookingSummary(Booking booking) {
        return booking.getTicketCode() + " | " + formatRouteLabel(booking) + " | " + humanizeStatus(booking.getStatus())
                + " | tổng tiền " + maskPrice(booking.getTotalPrice());
    }

    private String formatBookingContext(Booking booking) {
        StringBuilder builder = new StringBuilder();
        builder.append("- Mã vé: ").append(safe(booking.getTicketCode(), "Không rõ")).append("\n");
        builder.append("- Trạng thái: ").append(humanizeStatus(booking.getStatus())).append("\n");
        builder.append("- Hành trình: ").append(formatRouteLabel(booking)).append("\n");
        String busNumber = extractBusNumber(booking);
        if (busNumber != null) {
            builder.append("- Biển số xe: ").append(busNumber).append("\n");
        }
        builder.append("- Tổng tiền: ").append(maskPrice(booking.getTotalPrice())).append("\n");
        if (booking.getUser() != null && booking.getUser().getPhoneNumber() != null) {
            builder.append("- Số điện thoại: ").append(maskPhone(booking.getUser().getPhoneNumber())).append("\n");
        }
        return builder.toString().trim();
    }

    private String formatRouteLabel(Booking booking) {
        Trip trip = booking.getTrip();
        if (trip != null && trip.getRoute() != null) {
            return trip.getRoute().getOrigin() + " -> " + trip.getRoute().getDestination();
        }
        return "Không rõ hành trình";
    }

    private String extractBusNumber(Booking booking) {
        if (booking == null || booking.getTrip() == null || booking.getTrip().getBus() == null) {
            return null;
        }
        String busNumber = booking.getTrip().getBus().getBusNumber();
        return busNumber == null || busNumber.isBlank() ? null : busNumber;
    }

    private String humanizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "Đang cập nhật";
        }
        if ("Paid".equalsIgnoreCase(status)) {
            return "Đã thanh toán";
        }
        if ("Pending".equalsIgnoreCase(status)) {
            return "Chờ thanh toán";
        }
        if ("Cancelled".equalsIgnoreCase(status) || "Canceled".equalsIgnoreCase(status)) {
            return "Đã hủy";
        }
        return status;
    }

    private String safe(String primary, String fallback) {
        return primary == null || primary.isBlank() ? fallback : primary;
    }

    private String maskPhone(String phone) {
        if (phone == null || phone.isBlank()) {
            return "Không rõ";
        }
        String digits = phone.replaceAll("\\s+", "");
        if (digits.length() <= 4) {
            return "****";
        }
        int prefixLength = Math.min(3, digits.length() - 2);
        int suffixLength = Math.min(2, digits.length() - prefixLength);
        return digits.substring(0, prefixLength) + "****" + digits.substring(digits.length() - suffixLength);
    }

    private String maskPrice(double amount) {
        String formatted = String.format(Locale.US, "%,.0f", amount);
        int lastComma = formatted.lastIndexOf(',');
        if (lastComma >= 0) {
            return formatted.substring(0, lastComma + 1) + "*** VND";
        }
        if (formatted.length() > 3) {
            return formatted.substring(0, formatted.length() - 3) + "*** VND";
        }
        return "*** VND";
    }

    private boolean containsAny(String value, String... keywords) {
        for (String keyword : keywords) {
            if (value.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    private String normalizeWhitespace(String input) {
        if (input == null) {
            return "";
        }
        return input.replaceAll("\\s+", " ").trim();
    }

    private String normalizeText(String input) {
        String normalized = normalizeWhitespace(input).toLowerCase(Locale.ROOT);
        normalized = Normalizer.normalize(normalized, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('đ', 'd');
        return normalized;
    }

    private String buildRouteAvailableReply(Route route) {
        return "Có nhé, bên mình đang có tuyến " + route.getOrigin() + " - " + route.getDestination()
                + ". Bạn muốn đi ngày nào để mình tìm chuyến phù hợp luôn?";
    }

    private String buildRouteUnavailableReply(String origin, String destination) {
        return "Hiện mình chưa thấy tuyến trực tiếp " + origin + " - " + destination
                + " trong hệ thống. Nếu muốn, mình có thể gợi ý tuyến gần nhất hoặc kiểm tra hành trình khác cho bạn.";
    }

    private static class SupportSnapshot {
        private String context;
        private String requestedTicketCode;
        private Booking ticketBooking;
        private Booking activeBooking;
        private Route routeOnly;
        private List<String> cityMentions = new ArrayList<>();
        private List<Booking> phoneBookings = new ArrayList<>();
        private List<Booking> recentBookings = new ArrayList<>();
        private TripSearchSnapshot tripSearch;
    }

    private static class TripSearchSnapshot {
        private Route route;
        private LocalDate date;
        private List<Trip> trips = new ArrayList<>();
    }

    private static class CityMention {
        private final String name;
        private final int position;

        private CityMention(String name, int position) {
            this.name = name;
            this.position = position;
        }
    }
}


