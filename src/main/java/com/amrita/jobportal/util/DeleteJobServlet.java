package com.amrita.jobportal.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/deleteJob")
public class DeleteJobServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;
        String jobId = request.getParameter("jobId");

        // Security check: Only recruiters can delete jobs
        if (email == null || !"RECRUITER".equals(role) || jobId == null) {
            response.sendRedirect("login.html");
            return;
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            // STEP 1: Delete all applications tied to this job to prevent Foreign Key errors
            String deleteAppsQuery = "DELETE FROM applications WHERE job_id = ?";
            PreparedStatement pstApps = con.prepareStatement(deleteAppsQuery);
            pstApps.setInt(1, Integer.parseInt(jobId));
            pstApps.executeUpdate();

            // STEP 2: Delete the job itself (AND ensure only the owner can delete it)
            String deleteJobQuery = "DELETE FROM jobs WHERE job_id = ? AND posted_by = ?";
            PreparedStatement pstJob = con.prepareStatement(deleteJobQuery);
            pstJob.setInt(1, Integer.parseInt(jobId));
            pstJob.setString(2, email);
            
            int result = pstJob.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("dashboard.jsp?msg=deleted");
            } else {
                response.sendRedirect("dashboard.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Database Error: " + e.getMessage());
        }
    }
}