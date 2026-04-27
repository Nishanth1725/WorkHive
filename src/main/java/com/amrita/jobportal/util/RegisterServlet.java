package com.amrita.jobportal.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
// Import the new library
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String plainTextPassword = request.getParameter("password");
        String role = request.getParameter("role");

        // 1. Hash the password before doing anything else
        // gensalt() creates a random string added to the hash for extra security
        String hashedPassword = BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());

        try (Connection con = DatabaseConnection.getConnection()) {
            // Notice we are matching your column name: password_hash
            String query = "INSERT INTO users (email, password_hash, role) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, hashedPassword); // Save the scrambled version!
            pst.setString(3, role);

            int result = pst.executeUpdate();
            if (result > 0) {
                response.sendRedirect("login.html?msg=registered");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.html?msg=error");
        }
    }
}