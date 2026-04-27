package com.amrita.jobportal.util;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    // Using doGet because clicking a standard <a> link sends a GET request
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Fetch the current session. The 'false' means: don't create a new one if it doesn't exist.
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // This destroys the session and clears userEmail and userRole
            session.invalidate();
        }
        
        // Redirect back to the login page with a logged-out message
        response.sendRedirect("login.html?msg=logout");
    }
}