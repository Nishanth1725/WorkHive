<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security check: Only Recruiters can access this page
    String role = (String) session.getAttribute("userRole");
    if (role == null || !role.equals("RECRUITER")) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Post a Job - WorkHive</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .form-card { background: white; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        h2 { color: #1a73e8; text-align: center; }
        input, textarea, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background-color: #34a853; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; }
        button:hover { background-color: #2d8e47; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>Post a New Opening</h2>
        <form action="postJob" method="POST">
            <input type="text" name="title" placeholder="Job Title (e.g. Java Developer)" required>
            <input type="text" name="company" placeholder="Company Name" required>
            <input type="text" name="location" placeholder="Location (e.g. Coimbatore or Remote)" required>
            <input type="text" name="salary" placeholder="Salary (e.g. 10k - 15k)" required>
            <textarea name="description" rows="4" placeholder="Detailed Job Description" required></textarea>
            <button type="submit">Publish Job</button>
        </form>
        <p style="text-align:center;"><a href="dashboard.jsp" style="color: #666; text-decoration: none;">← Back to Dashboard</a></p>
    </div>
</body>
</html>