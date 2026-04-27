package com.amrita.jobportal.util;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    // 1. Fetch data to show on the profile page
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String email = (String) session.getAttribute("userEmail");

        try (Connection con = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM users WHERE email = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                request.setAttribute("fullName", rs.getString("full_name"));
                request.setAttribute("phone", rs.getString("phone"));
                request.setAttribute("bio", rs.getString("bio"));
                request.setAttribute("skills", rs.getString("skills"));
            }
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 2. Save the updated data from the form
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String email = (String) session.getAttribute("userEmail");
        
        String name = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String bio = request.getParameter("bio");
        String skills = request.getParameter("skills");

        try (Connection con = DatabaseConnection.getConnection()) {
            String query = "UPDATE users SET full_name = ?, phone = ?, bio = ?, skills = ? WHERE email = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, name);
            pst.setString(2, phone);
            pst.setString(3, bio);
            pst.setString(4, skills);
            pst.setString(5, email);
            
            pst.executeUpdate();
            response.sendRedirect("profile?msg=updated");
        } catch (Exception e) { e.printStackTrace(); }
    }
}