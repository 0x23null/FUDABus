package service;

import java.nio.charset.StandardCharsets;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import util.ConfigUtils;

public class EmailService {

    public boolean isConfigured() {
        return ConfigUtils.MAIL_ENABLED
                && !isBlank(ConfigUtils.MAIL_SMTP_HOST)
                && !isBlank(ConfigUtils.MAIL_SMTP_PORT)
                && !isBlank(ConfigUtils.MAIL_SMTP_USERNAME)
                && !isBlank(ConfigUtils.MAIL_SMTP_PASSWORD)
                && !isBlank(ConfigUtils.MAIL_FROM);
    }

    public void sendEmail(String recipient, EmailContent content) throws MessagingException {
        if (!isConfigured()) {
            throw new MessagingException("Mail service is not configured.");
        }

        Session session = Session.getInstance(buildProperties(), new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        ConfigUtils.MAIL_SMTP_USERNAME,
                        ConfigUtils.MAIL_SMTP_PASSWORD);
            }
        });

        MimeMessage message = new MimeMessage(session);
        try {
            message.setFrom(new InternetAddress(
                    ConfigUtils.MAIL_FROM,
                    ConfigUtils.MAIL_FROM_NAME,
                    StandardCharsets.UTF_8.name()));
            if (!isBlank(ConfigUtils.MAIL_REPLY_TO)) {
                message.setReplyTo(new InternetAddress[] {
                        new InternetAddress(ConfigUtils.MAIL_REPLY_TO)
                });
            }
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient, false));
            message.setSubject(content.getSubject(), StandardCharsets.UTF_8.name());
            message.setContent(buildContent(content));
            Transport.send(message);
        } catch (Exception ex) {
            if (ex instanceof MessagingException) {
                throw (MessagingException) ex;
            }
            throw new MessagingException("Unable to send email.", ex);
        }
    }

    private Properties buildProperties() {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", ConfigUtils.MAIL_SMTP_HOST);
        properties.put("mail.smtp.port", ConfigUtils.MAIL_SMTP_PORT);
        properties.put("mail.smtp.connectiontimeout", "10000");
        properties.put("mail.smtp.timeout", "10000");
        properties.put("mail.smtp.writetimeout", "10000");
        return properties;
    }

    private MimeMultipart buildContent(EmailContent content) throws MessagingException {
        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setText(content.getTextBody(), StandardCharsets.UTF_8.name());

        MimeBodyPart htmlPart = new MimeBodyPart();
        htmlPart.setContent(content.getHtmlBody(), "text/html; charset=UTF-8");

        MimeMultipart multipart = new MimeMultipart("alternative");
        multipart.addBodyPart(textPart);
        multipart.addBodyPart(htmlPart);
        return multipart;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
