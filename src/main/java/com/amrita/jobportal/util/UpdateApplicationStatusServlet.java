package com.amrita.jobportal.util;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateStatus")
public class UpdateApplicationStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appId = request.getParameter("appId");
        String status = request.getParameter("status");

        try (Connection con = DatabaseConnection.getConnection()) {
            // 1. Update the status in the database
            String updateQuery = "UPDATE applications SET status = ? WHERE app_id = ?";
            PreparedStatement pst = con.prepareStatement(updateQuery);
            pst.setString(1, status);
            pst.setInt(2, Integer.parseInt(appId));
            int result = pst.executeUpdate();

            if (result > 0) {
                // 2. Fetch the Seeker's Email and Job Title for the email message
                String fetchQuery = "SELECT a.seeker_email, j.title FROM applications a JOIN jobs j ON a.job_id = j.job_id WHERE a.app_id = ?";
                PreparedStatement fetchPst = con.prepareStatement(fetchQuery);
                fetchPst.setInt(1, Integer.parseInt(appId));
                ResultSet rs = fetchPst.executeQuery();

                if (rs.next()) {
                    String seekerEmail = rs.getString("seeker_email");
                    String jobTitle = rs.getString("title");

                    // 3. Draft the email content
                    String subject = "WorkHive Application Update: " + jobTitle;
                    String message = "Hello,\n\nYour application for the position of '" + jobTitle + "' has been updated.\n\n"
                                   + "New Status: " + status.toUpperCase() + "\n\n"
                                   + "Log into your WorkHive dashboard for more details.\n\nBest,\nThe WorkHive Team";

                    // 4. Send the email! (This runs in the background)
                    EmailUtility.sendEmail(seekerEmail, subject, message);
                }
                
                response.sendRedirect("viewApplications");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error updating status: " + e.getMessage());
        }
    }
}