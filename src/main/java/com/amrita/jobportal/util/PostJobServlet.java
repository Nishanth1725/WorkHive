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

@WebServlet("/postJob")
public class PostJobServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String recruiterEmail = (String) session.getAttribute("userEmail");

        String title = request.getParameter("title");
        String company = request.getParameter("company");
        String location = request.getParameter("location");
        String salary = request.getParameter("salary");
        String description = request.getParameter("description");

        try (Connection con = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO jobs (title, company, location, salary, description, posted_by) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, title);
            pst.setString(2, company);
            pst.setString(3, location);
            pst.setString(4, salary);
            pst.setString(5, description);
            pst.setString(6, recruiterEmail);

            int result = pst.executeUpdate();
            if (result > 0) {
                response.sendRedirect("dashboard.jsp?msg=jobposted");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}