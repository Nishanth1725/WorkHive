<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.amrita.jobportal.util.DatabaseConnection" %>

<%
    // 1. Session Security Check
    HttpSession userSession = request.getSession(false); 
    String email = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;
    String role = (userSession != null) ? (String) userSession.getAttribute("userRole") : null;

    if (email == null || role == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkHive Dashboard</title>
    <style>
        :root {
            --primary: #1a73e8;
            --success: #34a853;
            --danger: #da3633;
            --bg: #f0f2f5;
            --text: #202124;
            --card-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        body { font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif; background-color: var(--bg); color: var(--text); margin: 0; }
        
        /* Navigation Bar */
        .navbar { 
            background-color: var(--primary); 
            color: white; 
            padding: 0.8rem 2.5rem; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            position: sticky; top: 0; z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-links { display: flex; align-items: center; gap: 20px; }
        .nav-link { color: white; text-decoration: none; font-size: 0.95rem; font-weight: 500; opacity: 0.9; transition: opacity 0.2s; }
        .nav-link:hover { opacity: 1; text-decoration: underline; }

        .container { padding: 2rem; max-width: 1000px; margin: auto; }
        
        /* Top Greeting Card */
        .user-card { 
            background: white; 
            padding: 2.5rem; 
            border-radius: 15px; 
            border-left: 8px solid var(--primary);
            box-shadow: var(--card-shadow); 
            margin-bottom: 2.5rem; 
        }

        /* Search Bar Styling */
        .search-container {
            background: white;
            padding: 1rem;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            display: flex;
            gap: 10px;
        }
        .search-input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid #dadce0;
            border-radius: 8px;
            font-size: 1rem;
            outline: none;
        }
        .search-input:focus { border-color: var(--primary); }

        /* Job Posting Grid */
        .job-list { display: grid; gap: 1.5rem; }
        
        .job-card { 
            background: white; 
            padding: 1.5rem; 
            border-radius: 12px; 
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .job-card:hover { 
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border-color: var(--primary);
        }

        .job-info h3 { margin: 0; color: var(--primary); font-size: 1.3rem; }
        .job-info p { margin: 5px 0; color: #5f6368; }

        /* Buttons & Components */
        .btn { 
            padding: 10px 20px; 
            border-radius: 8px; 
            text-decoration: none; 
            font-weight: 600; 
            transition: 0.2s;
            display: inline-block;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
        }
        
        .btn-logout { border: 1px solid rgba(255,255,255,0.6); color: white; background: transparent; padding: 6px 16px; }
        .btn-logout:hover { background: rgba(255,255,255,0.15); }
        
        .btn-apply { background: var(--success); color: white; }
        .btn-apply:hover { background: #2d8e47; transform: scale(1.05); }
        
        .btn-post { background: var(--primary); color: white; margin-top: 10px; margin-right: 12px; }
        .btn-view { background: #5f6368; color: white; margin-top: 10px; }
        .btn-view:hover { background: #3c4043; }
        
        .btn-delete { background: var(--danger); color: white; padding: 6px 12px; margin-left: 10px; }
        .btn-delete:hover { background: #b52b29; }

        .badge { 
            background: #e8f0fe; 
            color: var(--primary); 
            padding: 6px 14px; 
            border-radius: 20px; 
            font-size: 0.75rem; 
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .salary-tag { color: #188038; font-weight: bold; margin-top: 8px; }
        .no-jobs { text-align: center; padding: 4rem; background: white; border-radius: 15px; box-shadow: var(--card-shadow); }
        hr { border: 0; border-top: 1px solid #eee; margin: 1.5rem 0; }
    </style>
</head>
<body>

<nav class="navbar">
    <div style="display:flex; align-items:center; gap:12px;">
        <span style="font-size: 1.6rem;">🚀</span>
        <h2 style="margin:0; letter-spacing: -1px; font-weight: 800;">WorkHive</h2>
    </div>
    
    <div class="nav-links">
        <a href="profile" class="nav-link">My Profile</a>
        <a href="logout" class="btn btn-logout">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="user-card">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <span class="badge"><%= role %> Account</span>
            <span style="color: #5f6368; font-size: 0.9rem;">Logged in as: <strong><%= email %></strong></span>
        </div>
        
        <h1 style="margin: 15px 0;">Dashboard Overview</h1>
        <p style="color: #5f6368; line-height: 1.6;">Welcome back! Use the tools below to manage your professional journey at Amrita.</p>
        
        <hr>
        
        <% if ("RECRUITER".equals(role)) { %>
            <h3 style="margin-top: 0; font-size: 1.1rem;">Recruiter Management</h3>
            <a href="post-job.jsp" class="btn btn-post">+ Post a New Job</a>
            <a href="viewApplications" class="btn btn-view">Review Received Applications</a>
        <% } else if ("SEEKER".equals(role)) { %>
            <h3 style="margin-top: 0; font-size: 1.1rem;">Seeker Actions</h3>
            <a href="myApplications" class="btn btn-view">Check My Applications</a>
        <% } %>
    </div>

    <form action="dashboard.jsp" method="GET" class="search-container">
        <input type="text" name="search" class="search-input" placeholder="Search by job title, company or location..." 
               value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>">
        <button type="submit" class="btn btn-primary">Search</button>
        <% if(request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
            <a href="dashboard.jsp" class="btn btn-view" style="background:#f1f3f4; color:#5f6368;">Clear</a>
        <% } %>
    </form>

    <h2 style="margin-bottom: 1.5rem; font-weight: 700; color: #202124;">
        <%= (request.getParameter("search") != null) ? "Search Results" : "Latest Opportunities" %>
    </h2>
    
    <div class="job-list">
        <%
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            
            try {
                con = DatabaseConnection.getConnection();
                if (con == null) {
                    out.println("<div class='no-jobs' style='color:red;'>Database Connection Failed. Check DatabaseConnection.java</div>");
                } else {
                    String searchKey = request.getParameter("search");
                    String query;
                    
                    if (searchKey != null && !searchKey.trim().isEmpty()) {
                        query = "SELECT * FROM jobs WHERE title LIKE ? OR company LIKE ? OR location LIKE ? ORDER BY created_at DESC";
                        pst = con.prepareStatement(query);
                        String keyword = "%" + searchKey + "%";
                        pst.setString(1, keyword);
                        pst.setString(2, keyword);
                        pst.setString(3, keyword);
                    } else {
                        query = "SELECT * FROM jobs ORDER BY created_at DESC";
                        pst = con.prepareStatement(query);
                    }

                    rs = pst.executeQuery();

                    boolean foundJobs = false;
                    while (rs.next()) {
                        foundJobs = true;
                        int jobId = rs.getInt("job_id");
                        String title = rs.getString("title");
                        String company = rs.getString("company");
                        String location = rs.getString("location");
                        String salary = rs.getString("salary");
                        String postedBy = rs.getString("posted_by");
        %>
                        <div class="job-card">
                            <div class="job-info">
                                <h3><%= title %></h3>
                                <p><strong><%= company %></strong> &bull; <%= location %></p>
                                <p class="salary-tag">Estimated Salary: ₹<%= (salary != null) ? salary : "N/A" %></p>
                            </div>
                            
                            <div class="job-actions">
                                <% if ("SEEKER".equals(role)) { %>
                                    <a href="apply-job.jsp?jobId=<%= jobId %>" class="btn btn-apply">Apply Now</a>
                                <% } else { %>
                                    <div style="display: flex; align-items: center;">
                                        <span class="badge" style="background:#f1f3f4; color:#70757a; border: 1px solid #ddd;">Live Listing</span>
                                        
                                        <%-- Only show delete button if this recruiter posted it --%>
                                        <% if (email.equals(postedBy)) { %>
                                            <form action="deleteJob" method="POST" style="margin: 0;" onsubmit="return confirm('Are you sure you want to delete this job? All applications for it will also be lost.');">
                                                <input type="hidden" name="jobId" value="<%= jobId %>">
                                                <button type="submit" class="btn btn-delete">Delete</button>
                                            </form>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
        <%
                    }
                    if (!foundJobs) {
        %>
                        <div class="no-jobs">
                            <h3 style="color: #dadce0; font-size: 3rem; margin-bottom: 10px;">Empty</h3>
                            <p style="color: #70757a;">Try searching for something else or browse all jobs.</p>
                        </div>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("<div class='no-jobs' style='color:red;'>System Error: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (pst != null) try { pst.close(); } catch (SQLException e) {}
                if (con != null) try { con.close(); } catch (SQLException e) {}
            }
        %>
    </div>
</div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('msg') === 'applied') {
        alert("🎉 Application Sent! You can track it in 'Check My Applications'.");
    } else if (urlParams.get('msg') === 'jobposted') {
        alert("✅ Success! Your job listing is now live for seekers.");
    } else if (urlParams.get('msg') === 'deleted') {
        alert("🗑️ Job and its applications have been permanently deleted.");
    } else if (urlParams.get('msg') === 'error') {
        alert("⚠️ There was an error processing your request.");
    }
</script>

</body>
</html>