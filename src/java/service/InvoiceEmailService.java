package service;

import jakarta.mail.MessagingException;
import model.Booking;
import util.ConfigUtils;

public class InvoiceEmailService {
    private final PaymentService paymentService = new PaymentService();
    private final InvoiceEmailTemplateBuilder templateBuilder = new InvoiceEmailTemplateBuilder();
    private final EmailService emailService = new EmailService();

    public void sendPaidBookingReceiptAsync(int bookingID, String paymentMethod, String transactionID) {
        if (!emailService.isConfigured()) {
            System.out.println("Skipping receipt email because mail service is not configured.");
            return;
        }

        EmailDispatcher.submit(() -> {
            try {
                sendPaidBookingReceipt(bookingID, paymentMethod, transactionID);
            } catch (Exception ex) {
                System.out.println("Failed to send receipt email for booking #" + bookingID + ": " + ex.getMessage());
            }
        });
    }

    private void sendPaidBookingReceipt(int bookingID, String paymentMethod, String transactionID)
            throws MessagingException {
        Booking booking = paymentService.getBookingDetails(bookingID);
        if (booking == null || booking.getUser() == null) {
            System.out.println("Skipping receipt email because booking details are unavailable for #" + bookingID);
            return;
        }

        String recipient = booking.getUser().getEmail();
        if (recipient == null || recipient.trim().isEmpty()) {
            System.out.println("Skipping receipt email because recipient email is missing for booking #" + bookingID);
            return;
        }

        String ticketUrl = ConfigUtils.APP_BASE_URL + "/ticket?id=" + bookingID;
        EmailContent content = templateBuilder.buildPaymentReceipt(booking, paymentMethod, transactionID, ticketUrl);
        emailService.sendEmail(recipient, content);
        System.out.println("Receipt email sent for booking #" + bookingID + " to " + recipient);
    }
}
