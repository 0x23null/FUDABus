package service;

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
        String subject = "Fuda Bus | Xac nhan thanh toan " + bookingReference;

        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html><html><body style=\"margin:0;padding:0;background:#f5f8fd;font-family:'Segoe UI',Arial,sans-serif;color:#14213d;\">");
        html.append("<table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\" style=\"background:#f5f8fd;padding:24px 12px;\">");
        html.append("<tr><td align=\"center\">");
        html.append("<table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\" style=\"max-width:640px;background:#ffffff;border-radius:28px;overflow:hidden;box-shadow:0 20px 40px -28px rgba(20,33,61,0.24);\">");
        html.append("<tr><td style=\"padding:0;background:linear-gradient(135deg,#2563eb,#0ea5e9);\">");
        html.append("<div style=\"padding:34px 36px 28px;color:#ffffff;\">");
        html.append("<div style=\"font-size:12px;letter-spacing:0.14em;text-transform:uppercase;opacity:0.85;margin-bottom:14px;\">Fuda Bus</div>");
        html.append("<div style=\"display:inline-block;background:rgba(255,255,255,0.16);border:1px solid rgba(255,255,255,0.24);padding:8px 14px;border-radius:999px;font-size:12px;font-weight:700;margin-bottom:18px;\">Thanh toan thanh cong</div>");
        html.append("<h1 style=\"margin:0 0 10px;font-size:28px;line-height:1.2;color:#ffffff;\">Cam on ");
        html.append(escapeHtml(customerName));
        html.append("</h1>");
        html.append("<p style=\"margin:0;font-size:15px;line-height:1.7;color:rgba(255,255,255,0.92);\">Don dat ve cua ban da duoc ghi nhan thanh cong. Chi tiet ve va thanh toan duoc tom tat ben duoi.</p>");
        html.append("</div></td></tr>");
        html.append("<tr><td style=\"padding:28px 28px 8px;\">");
        html.append(buildHighlightCard(bookingReference, booking.getBookingID(), booking.getTotalPrice(), ticketUrl));
        html.append(buildJourneySection(booking.getSegments()));
        html.append(buildPassengerSection(booking));
        html.append(buildPaymentSection(booking, paymentMethod, transactionId));
        html.append(buildNoticeSection(ticketUrl));
        html.append("</td></tr>");
        html.append("<tr><td style=\"padding:0 28px 28px;\">");
        html.append("<div style=\"border-top:1px solid #dce6f4;padding-top:18px;color:#5f6c84;font-size:12px;line-height:1.7;\">");
        html.append("Email nay duoc gui tu he thong Fuda Bus. Neu ban can ho tro, vui long lien he ");
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
        html.append("<div style=\"font-size:12px;text-transform:uppercase;letter-spacing:0.08em;color:#5f6c84;margin-bottom:8px;\">Ma dat ve</div>");
        html.append("<div style=\"font-size:24px;font-weight:800;color:#14213d;\">").append(escapeHtml(bookingReference)).append("</div>");
        html.append("<div style=\"margin-top:8px;font-size:14px;color:#5f6c84;\">Booking ID #").append(bookingId).append("</div>");
        html.append("</td>");
        html.append("<td style=\"padding:24px 22px;vertical-align:top;text-align:right;\">");
        html.append("<div style=\"font-size:12px;text-transform:uppercase;letter-spacing:0.08em;color:#5f6c84;margin-bottom:8px;\">Tong thanh toan</div>");
        html.append("<div style=\"font-size:28px;font-weight:800;color:#1d4ed8;\">").append(escapeHtml(formatCurrency(totalPrice))).append("</div>");
        html.append("<a href=\"").append(escapeHtml(ticketUrl)).append("\" style=\"display:inline-block;margin-top:16px;background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#ffffff;text-decoration:none;padding:12px 20px;border-radius:999px;font-size:14px;font-weight:700;\">Xem ve cua ban</a>");
        html.append("</td>");
        html.append("</tr>");
        html.append("</table>");
        return html.toString();
    }

    private String buildJourneySection(List<BookingSegment> segments) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:18px;border:1px solid #dce6f4;border-radius:22px;background:#ffffff;\">");
        html.append("<div style=\"padding:20px 22px 10px;font-size:18px;font-weight:800;color:#14213d;\">Lich trinh</div>");
        if (segments == null || segments.isEmpty()) {
            html.append("<div style=\"padding:0 22px 22px;color:#5f6c84;font-size:14px;\">Thong tin chuyen di se duoc cap nhat trong trang ve.</div>");
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
                html.append(escapeHtml(route != null ? safe(route.getOrigin()) : "Dang cap nhat"));
                html.append(" -> ");
                html.append(escapeHtml(route != null ? safe(route.getDestination()) : "Dang cap nhat"));
                html.append("</div>");
                html.append("<div style=\"margin-top:10px;font-size:14px;color:#5f6c84;line-height:1.7;\">");
                html.append("Khoi hanh: <strong style=\"color:#14213d;\">").append(escapeHtml(formatDateTime(trip != null ? trip.getDepartureTime() : null))).append("</strong><br>");
                html.append("Den noi: <strong style=\"color:#14213d;\">").append(escapeHtml(formatDateTime(trip != null ? trip.getArrivalTime() : null))).append("</strong><br>");
                html.append("Ghe: <strong style=\"color:#14213d;\">").append(escapeHtml(joinList(segment != null ? segment.getSeatNumbers() : null))).append("</strong>");
                if (bus != null && !safe(bus.getBusType()).isEmpty()) {
                    html.append("<br>Loai xe: <strong style=\"color:#14213d;\">").append(escapeHtml(safe(bus.getBusType()))).append("</strong>");
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
        html.append("<div style=\"padding:20px 22px 10px;font-size:18px;font-weight:800;color:#14213d;\">Hanh khach</div>");
        html.append("<div style=\"padding:0 22px 22px;font-size:14px;color:#5f6c84;line-height:1.8;\">");
        html.append("Nguoi dat: <strong style=\"color:#14213d;\">").append(escapeHtml(getCustomerName(booking))).append("</strong><br>");
        html.append("So luong: <strong style=\"color:#14213d;\">").append(booking.getTotalPassengerCount()).append(" hanh khach</strong><br>");
        html.append("Chi tiet: <strong style=\"color:#14213d;\">").append(escapeHtml(buildPassengerSummary(booking.getPassengers()))).append("</strong>");
        html.append("</div></div>");
        return html.toString();
    }

    private String buildPaymentSection(Booking booking, String paymentMethod, String transactionId) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:18px;border:1px solid #dce6f4;border-radius:22px;background:#ffffff;\">");
        html.append("<div style=\"padding:20px 22px 10px;font-size:18px;font-weight:800;color:#14213d;\">Thanh toan</div>");
        html.append("<div style=\"padding:0 22px 22px;font-size:14px;color:#5f6c84;line-height:1.8;\">");
        html.append("Trang thai: <strong style=\"color:#16a34a;\">Da thanh toan</strong><br>");
        html.append("Phuong thuc: <strong style=\"color:#14213d;\">").append(escapeHtml(safe(paymentMethod))).append("</strong><br>");
        html.append("Tong tien: <strong style=\"color:#14213d;\">").append(escapeHtml(formatCurrency(booking.getTotalPrice()))).append("</strong><br>");
        html.append("Ma giao dich: <strong style=\"color:#14213d;\">").append(escapeHtml(safe(transactionId))).append("</strong><br>");
        html.append("Thoi gian dat: <strong style=\"color:#14213d;\">").append(escapeHtml(formatDateTime(booking.getBookingDate()))).append("</strong>");
        html.append("</div></div>");
        return html.toString();
    }

    private String buildNoticeSection(String ticketUrl) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"margin-bottom:8px;border-radius:22px;background:#14213d;padding:22px;color:#ffffff;\">");
        html.append("<div style=\"font-size:18px;font-weight:800;margin-bottom:10px;\">Can xem lai ve bat cu luc nao</div>");
        html.append("<div style=\"font-size:14px;line-height:1.8;color:rgba(255,255,255,0.84);margin-bottom:16px;\">Ban co the mo trang ve de xem ma QR, thong tin ghe va lich trinh chi tiet.</div>");
        html.append("<a href=\"").append(escapeHtml(ticketUrl)).append("\" style=\"display:inline-block;background:#ffffff;color:#14213d;text-decoration:none;padding:12px 18px;border-radius:999px;font-size:14px;font-weight:700;\">Mo trang ve</a>");
        html.append("</div>");
        return html.toString();
    }

    private String buildTextVersion(Booking booking, String paymentMethod, String transactionId, String ticketUrl,
            String bookingReference) {
        StringBuilder text = new StringBuilder();
        text.append("Fuda Bus - Xac nhan thanh toan").append('\n');
        text.append("Ma dat ve: ").append(bookingReference).append('\n');
        text.append("Nguoi dat: ").append(getCustomerName(booking)).append('\n');
        text.append("Tong tien: ").append(formatCurrency(booking.getTotalPrice())).append('\n');
        text.append("Phuong thuc thanh toan: ").append(safe(paymentMethod)).append('\n');
        text.append("Ma giao dich: ").append(safe(transactionId)).append('\n');
        text.append("Thoi gian dat: ").append(formatDateTime(booking.getBookingDate())).append('\n');
        text.append('\n');
        if (booking.getSegments() != null) {
            for (BookingSegment segment : booking.getSegments()) {
                Trip trip = segment != null ? segment.getTrip() : null;
                Route route = trip != null ? trip.getRoute() : null;
                text.append(getSegmentLabel(segment)).append(": ");
                text.append(route != null ? safe(route.getOrigin()) : "Dang cap nhat");
                text.append(" -> ");
                text.append(route != null ? safe(route.getDestination()) : "Dang cap nhat");
                text.append('\n');
                text.append("Khoi hanh: ").append(formatDateTime(trip != null ? trip.getDepartureTime() : null)).append('\n');
                text.append("Ghe: ").append(joinList(segment != null ? segment.getSeatNumbers() : null)).append('\n');
                text.append('\n');
            }
        }
        text.append("Xem ve tai: ").append(ticketUrl).append('\n');
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
        return "quy khach";
    }

    private String buildPassengerSummary(List<BookingPassenger> passengers) {
        if (passengers == null || passengers.isEmpty()) {
            return "Thong tin hanh khach se hien thi trong trang ve";
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
        return summary.isEmpty() ? "Thong tin hanh khach se hien thi trong trang ve" : summary;
    }

    private String getSegmentLabel(BookingSegment segment) {
        if (segment == null) {
            return "Chang di";
        }
        return "RETURN".equalsIgnoreCase(segment.getSegmentType()) ? "Chuyen ve" : "Chuyen di";
    }

    private String formatCurrency(double amount) {
        synchronized (CURRENCY) {
            return CURRENCY.format(amount);
        }
    }

    private String formatDateTime(Timestamp timestamp) {
        if (timestamp == null) {
            return "Dang cap nhat";
        }
        return new SimpleDateFormat(DATE_TIME_PATTERN).format(timestamp);
    }

    private String joinList(List<String> values) {
        if (values == null || values.isEmpty()) {
            return "Dang cap nhat";
        }
        StringJoiner joiner = new StringJoiner(", ");
        for (String value : values) {
            String safeValue = safe(value);
            if (!safeValue.isEmpty()) {
                joiner.add(safeValue);
            }
        }
        String result = joiner.toString();
        return result.isEmpty() ? "Dang cap nhat" : result;
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
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
