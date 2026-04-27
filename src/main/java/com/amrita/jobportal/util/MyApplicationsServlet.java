package com.amrita.jobportal.util;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/myApplications")
public class MyApplicationsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String seekerEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (seekerEmail == null) {
            response.sendRedirect("login.html");
            return;
        }

        List<Map<String, String>> myApps = new ArrayList<>();

        try (Connection con = DatabaseConnection.getConnection()) {
            // JOIN query to get job details for the seeker's applications
            String query = "SELECT j.title, j.company, a.applied_at, a.status " +
                           "FROM jobs j " +
                           "JOIN applications a ON j.job_id = a.job_id " +
                           "WHERE a.seeker_email = ? ORDER BY a.applied_at DESC";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, seekerEmail);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Map<String, String> app = new HashMap<>();
                app.put("title", rs.getString("title"));
                app.put("company", rs.getString("company"));
                app.put("date", rs.getString("applied_at"));
                app.put("status", rs.getString("status"));
                myApps.add(app);
            }
            
            request.setAttribute("myApps", myApps);
            request.getRequestDispatcher("my-applications.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}