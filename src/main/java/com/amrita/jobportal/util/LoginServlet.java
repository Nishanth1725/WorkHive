package com.amrita.jobportal.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
// Import the library here too
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String plainTextPassword = request.getParameter("password");

        try (Connection con = DatabaseConnection.getConnection()) {
            // 1. We ONLY search by email now. We don't check the password in SQL anymore.
            String query = "SELECT password_hash, role FROM users WHERE email = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String role = rs.getString("role");

                // 2. Let BCrypt do the complex math to verify the password
                if (BCrypt.checkpw(plainTextPassword, storedHash)) {
                    // Passwords match! Set up the session.
                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userRole", role);
                    
                    response.sendRedirect("dashboard.jsp");
                } else {
                    // Password was wrong
                    response.sendRedirect("login.html?msg=invalid");
                }
            } else {
                // Email was not found
                response.sendRedirect("login.html?msg=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.html?msg=error");
        }
    }
}