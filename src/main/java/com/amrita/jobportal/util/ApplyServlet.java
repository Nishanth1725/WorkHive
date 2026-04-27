package com.amrita.jobportal.util;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/apply")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ApplyServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String seekerEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String jobId = request.getParameter("jobId");

        // 1. Backend Security & Validation
        if (seekerEmail == null || jobId == null) {
            response.sendRedirect("login.html");
            return;
        }

        // Capture and trim inputs to prevent whitespace-only entries
        String institute = request.getParameter("institute").trim();
        String specialization = request.getParameter("specialization");
        String duration = request.getParameter("duration");
        String gradYearStr = request.getParameter("gradYear");
        String locationPref = request.getParameter("locationPref").trim();

        // Basic validation check
        if (institute.isEmpty() || locationPref.isEmpty() || gradYearStr == null) {
            response.sendRedirect("apply-job.jsp?jobId=" + jobId + "&msg=error");
            return;
        }

        // 2. Handle File Upload Logic
        Part filePart = request.getPart("resume");
        // Verify it's actually a PDF
        if (!filePart.getContentType().equals("application/pdf")) {
            response.sendRedirect("apply-job.jsp?jobId=" + jobId + "&msg=invalidFormat");
            return;
        }

        String fileName = "resume_" + seekerEmail.split("@")[0] + "_" + System.currentTimeMillis() + ".pdf";
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        filePart.write(uploadPath + File.separator + fileName);

        // 3. Database Logic
        try (Connection con = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO applications " +
                           "(job_id, seeker_email, resume_file, status, institute_name, specialization, course_duration, grad_year, location_pref) " +
                           "VALUES (?, ?, ?, 'Pending', ?, ?, ?, ?, ?)";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, Integer.parseInt(jobId));
            pst.setString(2, seekerEmail);
            pst.setString(3, fileName);
            pst.setString(4, institute);
            pst.setString(5, specialization);
            pst.setString(6, duration);
            pst.setInt(7, Integer.parseInt(gradYearStr));
            pst.setString(8, locationPref);

            int result = pst.executeUpdate();
            if (result > 0) {
                // Success redirect
                response.sendRedirect("dashboard.jsp?msg=applied");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Database Error: " + e.getMessage());
        }
    }
}