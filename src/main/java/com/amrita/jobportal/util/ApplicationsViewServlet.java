package com.amrita.jobportal.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/viewApplications")
public class ApplicationsViewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String recruiterEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (recruiterEmail == null) {
            response.sendRedirect("login.html");
            return;
        }

        // 1. Get the search parameter from the filter bar
        String appSearch = request.getParameter("appSearch");
        List<Map<String, String>> appList = new ArrayList<>();

        try (Connection con = DatabaseConnection.getConnection()) {
            String query;
            PreparedStatement pst;

            // 2. Base Query string
            String baseQuery = "SELECT a.app_id, j.title, a.seeker_email, a.applied_at, a.status, a.resume_file, " +
                               "a.institute_name, a.specialization, a.course_duration, a.grad_year, a.location_pref " +
                               "FROM jobs j " +
                               "JOIN applications a ON j.job_id = a.job_id " +
                               "WHERE j.posted_by = ?";

            // 3. Dynamic SQL: If search is present, append the LIKE clauses
            if (appSearch != null && !appSearch.trim().isEmpty()) {
                query = baseQuery + " AND (a.institute_name LIKE ? OR a.specialization LIKE ? OR a.grad_year LIKE ?)";
                pst = con.prepareStatement(query);
                
                String keyword = "%" + appSearch + "%";
                pst.setString(1, recruiterEmail);
                pst.setString(2, keyword);
                pst.setString(3, keyword);
                pst.setString(4, keyword);
            } else {
                pst = con.prepareStatement(baseQuery);
                pst.setString(1, recruiterEmail);
            }

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Map<String, String> app = new HashMap<>();
                app.put("appId", rs.getString("app_id")); 
                app.put("jobTitle", rs.getString("title"));
                app.put("seekerEmail", rs.getString("seeker_email"));
                app.put("appliedAt", rs.getString("applied_at"));
                app.put("status", rs.getString("status"));
                app.put("resumeFile", rs.getString("resume_file")); 
                
                app.put("instituteName", rs.getString("institute_name"));
                app.put("specialization", rs.getString("specialization"));
                app.put("courseDuration", rs.getString("course_duration"));
                app.put("gradYear", rs.getString("grad_year"));
                app.put("locationPref", rs.getString("location_pref"));
                
                appList.add(app);
            }
            
            request.setAttribute("applications", appList);
            request.getRequestDispatcher("manage-applications.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Database Error: " + e.getMessage());
        }
    }
}