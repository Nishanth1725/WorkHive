<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - WorkHive</title>
    <style>
        body { background-color: #0b0e14; color: #ffffff; font-family: 'Inter', sans-serif; margin: 0; }
        .navbar { background-color: #12161d; padding: 1rem 2.5rem; border-bottom: 1px solid #2d333b; }
        .nav-brand { font-size: 1.4rem; font-weight: 700; color: #f0f6fc; text-decoration: none; }
        .container { padding: 3rem 2rem; max-width: 900px; margin: auto; }
        
        .app-card { 
            background: #151b23; 
            border: 1px solid #30363d; 
            padding: 1.8rem; 
            border-radius: 12px; 
            margin-bottom: 1.5rem; 
            transition: transform 0.2s;
        }
        .app-card:hover { transform: translateY(-3px); border-color: #444c56; }

        /* Progress Stepper Styling */
        .progress-track {
            display: flex;
            justify-content: space-between;
            margin-top: 2rem;
            position: relative;
            max-width: 500px;
        }

        /* The horizontal line behind steps */
        .progress-track::before {
            content: "";
            position: absolute;
            top: 13px;
            left: 0;
            right: 0;
            height: 2px;
            background: #30363d;
            z-index: 1;
        }

        .step-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            z-index: 2;
            width: 80px;
        }

        .step-circle {
            width: 28px;
            height: 28px;
            background: #0d1117;
            border: 2px solid #30363d;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
            transition: 0.3s;
        }

        .step-label {
            font-size: 0.7rem;
            color: #8b949e;
            margin-top: 8px;
            text-align: center;
        }

        /* Dynamic Step States */
        .step-completed { background: #238636; border-color: #238636; color: white; }
        .step-active { border-color: #58a6ff; color: #58a6ff; box-shadow: 0 0 10px rgba(88, 166, 255, 0.3); }
        .step-rejected { background: #da3633; border-color: #da3633; color: white; }

        .back-link { display: inline-block; margin-top: 2rem; color: #8b949e; text-decoration: none; }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="dashboard.jsp" class="nav-brand">WorkHive</a>
    </nav>

    <div class="container">
        <h2>My Job Applications</h2>

        <% 
            List<Map<String, String>> myApps = (List<Map<String, String>>) request.getAttribute("myApps");
            if (myApps != null && !myApps.isEmpty()) {
                for (Map<String, String> app : myApps) {
                    String status = app.get("status");
        %>
            <div class="app-card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                        <h3 style="margin: 0; color: #f0f6fc;"><%= app.get("title") %></h3>
                        <p style="color: #8b949e; margin: 5px 0;">
                            <strong><%= app.get("company") %></strong> &bull; Applied on <%= app.get("date") %>
                        </p>
                    </div>
                </div>

                <div class="progress-track">
                    <div class="step-item">
                        <div class="step-circle step-completed">✓</div>
                        <span class="step-label">Submitted</span>
                    </div>

                    <div class="step-item">
                        <%-- If Pending, this is the current active step. If Accepted/Rejected, it's completed --%>
                        <div class="step-circle <%= "Pending".equalsIgnoreCase(status) ? "step-active" : "step-completed" %>">
                            <%= "Pending".equalsIgnoreCase(status) ? "2" : "✓" %>
                        </div>
                        <span class="step-label">Reviewing</span>
                    </div>

                    <div class="step-item">
                        <% if ("Rejected".equalsIgnoreCase(status)) { %>
                            <div class="step-circle step-rejected">✕</div>
                            <span class="step-label" style="color: #f85149;">Closed</span>
                        <% } else if ("Accepted".equalsIgnoreCase(status)) { %>
                            <div class="step-circle step-completed">✓</div>
                            <span class="step-label" style="color: #3fb950;">Shortlisted</span>
                        <% } else { %>
                            <div class="step-circle">3</div>
                            <span class="step-label">Decision</span>
                        <% } %>
                    </div>
                </div>
            </div>
        <% 
                } 
            } else { 
        %>
            <div style="text-align: center; padding: 4rem; background: #151b23; border-radius: 12px; border: 1px dashed #30363d;">
                <p style="color: #8b949e;">No applications found. Time to apply!</p>
                <a href="dashboard.jsp" style="color: #58a6ff; text-decoration: none;">Browse Jobs →</a>
            </div>
        <% } %>

        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

</body>
</html>