package service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.StringJoiner;

import model.Booking;
import model.BookingPassenger;
import model.BookingSegment;
import model.Bus;
import model.Route;
import model.Trip;

public class InvoiceEmailTemplateBuilder {
    private static final Locale VIETNAMESE = new Locale("vi", "VN");
    private static final NumberFormat CURRENCY = NumberFormat.getCurrencyInstance(VIETNAMESE);
    private static final String DATE_TIME_PATTERN = "dd/MM/yyyy HH:mm";

    public EmailContent buildPaymentReceipt(Booking booking, String paymentMethod, String transactionId, String ticketUrl) {
        String customerName = safe(getCustomerName(booking));
        String bookingCode = safe(booking.getTicketCode());
        String bookingReference = bookingCode.isEmpty() ? "#" + booking.getBookingID() : bookingCode;
        String subject = "Fuda Bus | Xác nhận thanh toán " + bookingReference;

        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html><html><body style=\"margin:0;padding:0;background:#f5f8fd;font-family:'Segoe UI',Arial,sans-serif;color:#14213d;\">");
        html.append("<table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\" style=\"background:#f5f8fd;padding:24px 12px;\">");
        html.append("<tr><td align=\"center\">");
        html.append("<table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\" style=\"max-width:640px;background:#ffffff;border-radius:28px;overflow:hidden;box-shadow:0 20px 40px -28px rgba(20,33,61,0.24);\">");
        html.append("<tr><td style=\"padding:0;background:linear-gradient(135deg,#2563eb,#0ea5e9);\">");
        html.append("<div style=\"padding:34px 36px 28px;color:#ffffff;\">");
        html.append("<div style=\"font-size:12px;letter-spacing:0.14em;text-transform:uppercase;opacity:0.85;margin-bottom:14px;\">Fuda Bus</div>");
        html.append("<div style=\"display:inline-block;background:rgba(255,255,255,0.16);border:1px solid rgba(255,255,255,0.24);padding:8px 14px;border-radius:999px;font-size:12px;font-weight:700;margin-bottom:18px;\">Thanh toán thành công</div>");
        html.append("<h1 style=\"margin:0 0 10px;font-size:28px;line-height:1.2;color:#ffffff;\">Cảm ơn ");
        html.append(escapeHtml(customerName));
        html.append("</h1>");
        html.append("<p style=\"margin:0;font-size:15px;line-height:1.7;color:rgba(255,255,255,0.92);\">Đơn đặt vé của bạn đã được ghi nhận thành công. Chi tiết vé và thanh toán được tóm tắt ngay bên dưới.</p>");
        html.append("</div></td></tr>");
        html.append("<tr><td style=\"padding:28px 28px 8px;\">");
        html.append(buildHighlightCard(bookingReference, booking.getBookingID(), booking.getTotalPrice(), ticketUrl));
        html.append(buildQrSection(booking, ticketUrl));
        html.append(buildJourneySection(booking.getSegments()));
        html.append(buildPassengerSection(booking));
        html.append(buildPaymentSection(booking, paymentMethod, transactionId));
        html.append(buildNoticeSection(ticketUrl));
        html.append("</td></tr>");
        html.append("<tr><td style=\"padding:0 28px 28px;\">");
        html.append("<div style=\"border-top:1px solid #dce6f4;padding-top:18px;color:#5f6c84;font-size:12px;line-height:1.7;\">");
        html.append("Email này được gửi tự động từ hệ thống Fuda Bus. Nếu bạn cần hỗ trợ, vui lòng liên hệ ");
        html.append("<a href=\"mailto:support@fudabus.store\" style=\"color:#2563eb;text-decoration:none;\">support@fudabus.store</a>.");
        html.append("</div></td></tr>");
        html.append("</table></td></tr></table></body></html>");

        String text = buildTextVersion(booking, paymentMethod, transactionId, ticketUrl, bookingReference);
        return new EmailContent(subject, html.toString(), text);
    }

    private String buildHighlightCard(String bookingReference, int bookingId, double totalPrice, String ticketUrl) {
        StringBuilder html = new StringBuilder();
        html.append("<table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\" style=\"margin-bottom:18px;border:1px solid #dce6f4;border-radius:22px;background:#f8fbff;\">");
        html.append("<tr>");
        html.append("<td style=\"padding:24px 22px;vertical-align:top;\">");
        html.append("<div style=\"font-size:12px;text-transform:uppercase;letter-spacing:0.08em;color:#5f6c84;margin-bottom:8px;\">Mã đặt vé</div>");
        html.append("<div style=\"font-size:24px;font-weight:800;color:#14213d;\">").append(escapeHtml(bookingReference)).append("</div>");
        html.append("<div style=\"margin-top:8px;font-size:14px;color:#5f6c84;\">Mã đơn #").append(bookingId).append("</div>");
        html.append("</td>");
        html.append("<td style=\"padding:24px 22px;vertical-align:top;text-align:right;\">");
        html.append("<div style=\"font-size:12px;text-transform:uppercase;letter-spacing:0.08em;color:#5f6c84;margin-bottom:8px;\">Tổng thanh toán</div>");
        html.append("<div style=\"font-size:28px;font-weight:800;color:#1d4ed8;\">").append(escapeHtml(formatCurrency(totalPrice))).append("</div>");
        html.append("<a href=\"").append(escapeHtml(ticketUrl)).append("\" style=\"display:inline-block;margin-top:16px;background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#ffffff;text-decoration:none;padding:12px 20px;border-radius:999px;font-size:14px;font-weight:700;\">Xem vé của bạn</a>");
        html.append("</td>");
        html.append("</tr>");
        html.append("</table>");
        return html.toString();
    }

    private String buildQrSection(Booking booking, String ticketUrl) {
        String qrImageUrl = buildQrImageUrl(booking, ticketUrl);
        if (qrImageUrl.isEmpty()) {
            return "";
        }

        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:18px;border:1px solid #dce6f4;border-radius:22px;background:#ffffff;\">");
        html.append("<div style=\"padding:20px 22px 12px;font-size:18px;font-weight:800;color:#14213d;\">Mã QR lên xe</div>");
        html.append("<div style=\"padding:0 22px 22px;text-align:center;\">");
        html.append("<p style=\"margin:0 0 16px;font-size:14px;line-height:1.8;color:#5f6c84;\">Bạn có thể đưa mã QR này khi check-in, hoặc mở trang vé nếu ứng dụng email chặn tải ảnh tự động.</p>");
        html.append("<img src=\"").append(escapeHtml(qrImageUrl)).append("\" alt=\"Mã QR vé xe\" width=\"180\" height=\"180\" style=\"display:block;margin:0 auto 14px;border:1px solid #dce6f4;border-radius:18px;padding:10px;background:#ffffff;\">");
        html.append("<div style=\"font-size:13px;color:#5f6c84;line-height:1.7;\">Nếu không thấy mã QR, vui lòng mở <a href=\"")
                .append(escapeHtml(ticketUrl))
                .append("\" style=\"color:#2563eb;text-decoration:none;\">trang vé của bạn</a>.</div>");
        html.append("</div></div>");
        return html.toString();
    }

    private String buildJourneySection(List<BookingSegment> segments) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:18px;border:1px solid #dce6f4;border-radius:22px;background:#ffffff;\">");
        html.append("<div style=\"padding:20px 22px 10px;font-size:18px;font-weight:800;color:#14213d;\">Hành trình</div>");
        if (segments == null || segments.isEmpty()) {
            html.append("<div style=\"padding:0 22px 22px;color:#5f6c84;font-size:14px;\">Thông tin chuyến đi sẽ được cập nhật trong trang vé.</div>");
        } else {
            for (BookingSegment segment : segments) {
                Trip trip = segment != null ? segment.getTrip() : null;
                Route route = trip != null ? trip.getRoute() : null;
                Bus bus = trip != null ? trip.getBus() : null;
                html.append("<div style=\"margin:0 18px 18px;padding:18px;border-radius:18px;background:#f8fbff;border:1px solid #e0ecfb;\">");
                html.append("<div style=\"display:inline-block;padding:6px 10px;border-radius:999px;background:#e8f0ff;color:#1d4ed8;font-size:12px;font-weight:700;margin-bottom:12px;\">");
                html.append(escapeHtml(getSegmentLabel(segment)));
                html.append("</div>");
                html.append("<div style=\"font-size:18px;font-weight:800;color:#14213d;line-height:1.4;\">");
                html.append(escapeHtml(route != null ? safe(route.getOrigin()) : "Đang cập nhật"));
                html.append(" → ");
                html.append(escapeHtml(route != null ? safe(route.getDestination()) : "Đang cập nhật"));
                html.append("</div>");
                html.append("<div style=\"margin-top:10px;font-size:14px;color:#5f6c84;line-height:1.7;\">");
                html.append("Khởi hành: <strong style=\"color:#14213d;\">").append(escapeHtml(formatDateTime(trip != null ? trip.getDepartureTime() : null))).append("</strong><br>");
                html.append("Đến nơi: <strong style=\"color:#14213d;\">").append(escapeHtml(formatDateTime(trip != null ? trip.getArrivalTime() : null))).append("</strong><br>");
                html.append("Ghế: <strong style=\"color:#14213d;\">").append(escapeHtml(joinList(segment != null ? segment.getSeatNumbers() : null))).append("</strong>");
                if (bus != null && !safe(bus.getBusNumber()).isEmpty()) {
                    html.append("<br>Biển số xe: <strong style=\"color:#14213d;\">").append(escapeHtml(safe(bus.getBusNumber()))).append("</strong>");
                }
                if (bus != null && !safe(bus.getBusType()).isEmpty()) {
                    html.append("<br>Loại xe: <strong style=\"color:#14213d;\">").append(escapeHtml(safe(bus.getBusType()))).append("</strong>");
                }
                html.append("</div></div>");
            }
        }
        html.append("</div>");
        return html.toString();
    }

    private String buildPassengerSection(Booking booking) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:18px;border:1px solid #dce6f4;border-radius:22px;background:#ffffff;\">");
        html.append("<div style=\"padding:20px 22px 10px;font-size:18px;font-weight:800;color:#14213d;\">Hành khách</div>");
        html.append("<div style=\"padding:0 22px 22px;font-size:14px;color:#5f6c84;line-height:1.8;\">");
        html.append("Người đặt: <strong style=\"color:#14213d;\">").append(escapeHtml(getCustomerName(booking))).append("</strong><br>");
        html.append("Số lượng: <strong style=\"color:#14213d;\">").append(booking.getTotalPassengerCount()).append(" hành khách</strong><br>");
        html.append("Chi tiết: <strong style=\"color:#14213d;\">").append(escapeHtml(buildPassengerSummary(booking.getPassengers()))).append("</strong>");
        html.append("</div></div>");
        return html.toString();
    }

    private String buildPaymentSection(Booking booking, String paymentMethod, String transactionId) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:18px;border:1px solid #dce6f4;border-radius:22px;background:#ffffff;\">");
        html.append("<div style=\"padding:20px 22px 10px;font-size:18px;font-weight:800;color:#14213d;\">Thanh toán</div>");
        html.append("<div style=\"padding:0 22px 22px;font-size:14px;color:#5f6c84;line-height:1.8;\">");
        html.append("Trạng thái: <strong style=\"color:#16a34a;\">Đã thanh toán</strong><br>");
        html.append("Phương thức: <strong style=\"color:#14213d;\">").append(escapeHtml(safe(paymentMethod))).append("</strong><br>");
        html.append("Tổng tiền: <strong style=\"color:#14213d;\">").append(escapeHtml(formatCurrency(booking.getTotalPrice()))).append("</strong><br>");
        html.append("Mã giao dịch: <strong style=\"color:#14213d;\">").append(escapeHtml(safe(transactionId))).append("</strong><br>");
        html.append("Thời gian đặt: <strong style=\"color:#14213d;\">").append(escapeHtml(formatDateTime(booking.getBookingDate()))).append("</strong>");
        html.append("</div></div>");
        return html.toString();
    }

    private String buildNoticeSection(String ticketUrl) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:8px;border-radius:22px;background:#14213d;padding:22px;color:#ffffff;\">");
        html.append("<div style=\"font-size:18px;font-weight:800;margin-bottom:10px;\">Bạn có thể xem lại vé bất cứ lúc nào</div>");
        html.append("<div style=\"font-size:14px;line-height:1.8;color:rgba(255,255,255,0.84);margin-bottom:16px;\">Mở trang vé để xem mã QR, thông tin ghế và hành trình chi tiết bất cứ khi nào cần.</div>");
        html.append("<a href=\"").append(escapeHtml(ticketUrl)).append("\" style=\"display:inline-block;background:#ffffff;color:#14213d;text-decoration:none;padding:12px 18px;border-radius:999px;font-size:14px;font-weight:700;\">Mở trang vé</a>");
        html.append("</div>");
        return html.toString();
    }

    private String buildTextVersion(Booking booking, String paymentMethod, String transactionId, String ticketUrl,
            String bookingReference) {
        StringBuilder text = new StringBuilder();
        text.append("Fuda Bus - Xác nhận thanh toán").append('\n');
        text.append("Mã đặt vé: ").append(bookingReference).append('\n');
        text.append("Người đặt: ").append(getCustomerName(booking)).append('\n');
        text.append("Tổng tiền: ").append(formatCurrency(booking.getTotalPrice())).append('\n');
        text.append("Phương thức thanh toán: ").append(safe(paymentMethod)).append('\n');
        text.append("Mã giao dịch: ").append(safe(transactionId)).append('\n');
        text.append("Thời gian đặt: ").append(formatDateTime(booking.getBookingDate())).append('\n');
        text.append("Mã QR: ").append(buildQrImageUrl(booking, ticketUrl)).append('\n');
        text.append('\n');
        if (booking.getSegments() != null) {
            for (BookingSegment segment : booking.getSegments()) {
                Trip trip = segment != null ? segment.getTrip() : null;
                Route route = trip != null ? trip.getRoute() : null;
                Bus bus = trip != null ? trip.getBus() : null;
                text.append(getSegmentLabel(segment)).append(": ");
                text.append(route != null ? safe(route.getOrigin()) : "Đang cập nhật");
                text.append(" → ");
                text.append(route != null ? safe(route.getDestination()) : "Đang cập nhật");
                text.append('\n');
                text.append("Khởi hành: ").append(formatDateTime(trip != null ? trip.getDepartureTime() : null)).append('\n');
                if (bus != null && !safe(bus.getBusNumber()).isEmpty()) {
                    text.append("Biển số xe: ").append(safe(bus.getBusNumber())).append('\n');
                }
                text.append("Ghế: ").append(joinList(segment != null ? segment.getSeatNumbers() : null)).append('\n');
                text.append('\n');
            }
        }
        text.append("Xem vé tại: ").append(ticketUrl).append('\n');
        return text.toString();
    }

    private String getCustomerName(Booking booking) {
        if (booking != null && booking.getUser() != null) {
            String fullName = safe(booking.getUser().getFullName());
            if (!fullName.isEmpty()) {
                return fullName;
            }
            String email = safe(booking.getUser().getEmail());
            if (!email.isEmpty()) {
                return email;
            }
        }
        return "Quý khách";
    }

    private String buildPassengerSummary(List<BookingPassenger> passengers) {
        if (passengers == null || passengers.isEmpty()) {
            return "Thông tin hành khách sẽ hiển thị trong trang vé";
        }
        StringJoiner joiner = new StringJoiner(", ");
        for (BookingPassenger passenger : passengers) {
            if (passenger == null) {
                continue;
            }
            String label = safe(passenger.getDisplayLabel());
            joiner.add(label.isEmpty() ? safe(passenger.getPassengerType()) : label);
        }
        String summary = joiner.toString();
        return summary.isEmpty() ? "Thông tin hành khách sẽ hiển thị trong trang vé" : summary;
    }

    private String getSegmentLabel(BookingSegment segment) {
        if (segment == null) {
            return "Chặng đi";
        }
        return "RETURN".equalsIgnoreCase(segment.getSegmentType()) ? "Chuyến về" : "Chuyến đi";
    }

    private String formatCurrency(double amount) {
        synchronized (CURRENCY) {
            return CURRENCY.format(amount);
        }
    }

    private String formatDateTime(Timestamp timestamp) {
        if (timestamp == null) {
            return "Đang cập nhật";
        }
        return new SimpleDateFormat(DATE_TIME_PATTERN).format(timestamp);
    }

    private String joinList(List<String> values) {
        if (values == null || values.isEmpty()) {
            return "Đang cập nhật";
        }
        StringJoiner joiner = new StringJoiner(", ");
        for (String value : values) {
            String safeValue = safe(value);
            if (!safeValue.isEmpty()) {
                joiner.add(safeValue);
            }
        }
        String result = joiner.toString();
        return result.isEmpty() ? "Đang cập nhật" : result;
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private String buildQrImageUrl(Booking booking, String ticketUrl) {
        if (booking != null) {
            String qrCodeUrl = safe(booking.getQrCodeURL());
            if (!qrCodeUrl.isEmpty()) {
                return qrCodeUrl;
            }
        }

        String payload = safe(ticketUrl);
        if (payload.isEmpty() && booking != null) {
            payload = safe(booking.getTicketCode());
        }
        if (payload.isEmpty()) {
            return "";
        }

        return "https://api.qrserver.com/v1/create-qr-code/?size=180x180&data="
                + URLEncoder.encode(payload, StandardCharsets.UTF_8);
    }

    private String escapeHtml(String value) {
        String input = value == null ? "" : value;
        StringBuilder escaped = new StringBuilder(input.length());
        for (int i = 0; i < input.length(); i++) {
            char current = input.charAt(i);
            switch (current) {
                case '&':
                    escaped.append("&amp;");
                    break;
                case '<':
                    escaped.append("&lt;");
                    break;
                case '>':
                    escaped.append("&gt;");
                    break;
                case '"':
                    escaped.append("&quot;");
                    break;
                case '\'':
                    escaped.append("&#39;");
                    break;
                default:
                    escaped.append(current);
            }
        }
        return escaped.toString();
    }
}
