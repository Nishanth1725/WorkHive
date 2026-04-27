package com.amrita.jobportal.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtility {
    
    // Replace these with a real Gmail address and generated App Password
    private static final String SENDER_EMAIL = "nishanth9192r@gmail.com"; 
    private static final String APP_PASSWORD = "qcvehtislewbzhzi";

    public static void sendEmail(String recipientEmail, String subject, String messageContent) {
        // 1. Setup Gmail SMTP Server Properties
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");

        // 2. Create the Session with Authentication
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            // 3. Draft and Send the Message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "WorkHive Notifications"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setText(messageContent);

            Transport.send(message);
            System.out.println("Email successfully sent to: " + recipientEmail);

        } catch (Exception e) {
            System.err.println("Failed to send email.");
            e.printStackTrace();
        }
    }
}