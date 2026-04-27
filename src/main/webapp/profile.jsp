<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security: Redirect to login if session is invalid
    String email = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");
    if (email == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - WorkHive</title>
    <style>
        body { background-color: #0b0e14; color: #ffffff; font-family: 'Inter', -apple-system, sans-serif; margin: 0; }
        .navbar { background-color: #12161d; padding: 1rem 2.5rem; border-bottom: 1px solid #2d333b; display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { font-size: 1.4rem; font-weight: 700; color: #f0f6fc; text-decoration: none; }

        .container { padding: 3rem 2rem; max-width: 700px; margin: auto; }
        
        .profile-card {
            background-color: #151b23;
            border: 1px solid #30363d;
            border-radius: 12px;
            padding: 2.5rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
        }

        h2 { margin-top: 0; color: #f0f6fc; font-size: 1.8rem; }
        .subtitle { color: #8b949e; margin-bottom: 2rem; font-size: 0.9rem; }

        .form-group { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 8px; color: #8b949e; font-size: 0.85rem; font-weight: 600; }
        
        input, textarea {
            width: 100%;
            padding: 12px;
            background-color: #0d1117;
            border: 1px solid #30363d;
            border-radius: 6px;
            color: white;
            box-sizing: border-box;
            font-size: 1rem;
            font-family: inherit;
        }
        input:focus, textarea:focus { border-color: #58a6ff; outline: none; box-shadow: 0 0 0 3px rgba(88,166,255,0.1); }
        
        .static-email { background-color: #161b22; color: #484f58; cursor: not-allowed; }

        .btn-save {
            background-color: #1f6feb;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.2s;
        }
        .btn-save:hover { background-color: #388bfd; }
        
        .msg-success {
            background: rgba(57, 211, 83, 0.1);
            color: #3fb950;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid rgba(57, 211, 83, 0.2);
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            text-align: center;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="dashboard.jsp" class="nav-brand">WorkHive</a>
        <a href="dashboard.jsp" style="color: #8b949e; text-decoration: none; font-size: 0.9rem;">Back to Dashboard</a>
    </nav>

    <div class="container">
        <div class="profile-card">
            <h2>User Profile</h2>
            <p class="subtitle">Update your personal information and skills to stand out to recruiters.</p>

            <% if (request.getParameter("msg") != null) { %>
                <div class="msg-success">✅ Profile updated successfully!</div>
            <% } %>

            <form action="profile" method="POST">
                <div class="form-group">
                    <label>Email Address (Account ID)</label>
                    <input type="email" class="static-email" value="<%= email %>" readonly>
                </div>

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="Enter your full name" 
                           value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>">
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" placeholder="+91 XXXXX XXXXX" 
                           value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                </div>

                <div class="form-group">
                    <label>Skills (Comma separated)</label>
                    <input type="text" name="skills" placeholder="Java, SQL, HTML, CSS" 
                           value="<%= request.getAttribute("skills") != null ? request.getAttribute("skills") : "" %>">
                </div>

                <div class="form-group">
                    <label>Short Bio</label>
                    <textarea name="bio" rows="4" placeholder="Tell recruiters about yourself..."><%= request.getAttribute("bio") != null ? request.getAttribute("bio") : "" %></textarea>
                </div>

                <button type="submit" class="btn-save">Save Profile Changes</button>
            </form>
        </div>
    </div>

</body>
</html>