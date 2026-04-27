<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Applications - WorkHive</title>
    <style>
        :root {
            --bg-dark: #0b0e14;
            --card-bg: #151b23;
            --border-color: #30363d;
            --blue-accent: #58a6ff;
            --green-accent: #3fb950;
            --red-accent: #f85149;
        }

        body { background-color: var(--bg-dark); color: #ffffff; font-family: 'Inter', -apple-system, sans-serif; margin: 0; }
        .navbar { background-color: #12161d; padding: 1rem 2.5rem; border-bottom: 1px solid var(--border-color); }
        .container { padding: 3rem 2rem; max-width: 1200px; margin: auto; }
        
        /* Search/Filter Bar */
        .filter-bar { display: flex; gap: 12px; margin-bottom: 2rem; background: var(--card-bg); padding: 15px; border-radius: 10px; border: 1px solid var(--border-color); }
        .filter-input { flex: 1; padding: 12px; background: #0d1117; border: 1px solid var(--border-color); border-radius: 6px; color: white; font-size: 0.9rem; }
        .filter-input:focus { border-color: var(--blue-accent); outline: none; box-shadow: 0 0 0 3px rgba(88,166,255,0.1); }

        /* Table Styling */
        table { width: 100%; border-collapse: separate; border-spacing: 0 8px; }
        th { background-color: transparent; color: #8b949e; text-align: left; padding: 12px 20px; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; }
        tr.app-row { background-color: var(--card-bg); transition: transform 0.2s, background 0.2s; }
        tr.app-row:hover { background-color: #1c2128; transform: translateY(-2px); }
        
        td { padding: 20px; border-top: 1px solid var(--border-color); border-bottom: 1px solid var(--border-color); }
        td:first-child { border-left: 1px solid var(--border-color); border-top-left-radius: 10px; border-bottom-left-radius: 10px; }
        td:last-child { border-right: 1px solid var(--border-color); border-top-right-radius: 10px; border-bottom-right-radius: 10px; }

        /* Status Visual Cues (Left Border) */
        tr.status-Accepted { border-left: 4px solid var(--green-accent) !important; }
        tr.status-Rejected { border-left: 4px solid var(--red-accent) !important; }
        tr.status-Pending { border-left: 4px solid var(--blue-accent) !important; }

        .applicant-info { display: flex; flex-direction: column; gap: 4px; }
        .applicant-email { color: #f0f6fc; font-weight: 600; font-size: 1rem; }
        .applicant-meta { color: #8b949e; font-size: 0.85rem; line-height: 1.5; }
        .applicant-meta b { color: #c9d1d9; }

        /* Enhanced Skill Badges */
        .skill-badge {
            background-color: rgba(88, 166, 255, 0.1);
            color: var(--blue-accent);
            border: 1px solid rgba(88, 166, 255, 0.2);
            padding: 3px 10px;
            border-radius: 5px;
            font-size: 0.7rem;
            font-weight: 700;
            margin-right: 6px;
            display: inline-block;
            text-transform: uppercase;
            margin-top: 8px;
        }

        .status-badge { padding: 5px 12px; border-radius: 6px; font-size: 0.75rem; font-weight: 700; display: inline-block; }
        .status-Pending { background: rgba(88, 166, 255, 0.15); color: var(--blue-accent); }
        .status-Accepted { background: rgba(63, 185, 80, 0.15); color: var(--green-accent); }
        .status-Rejected { background: rgba(248, 81, 73, 0.15); color: var(--red-accent); }

        .btn-action { border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 0.85rem; transition: 0.2s; }
        .btn-accept { background-color: #238636; color: white; }
        .btn-accept:hover { background-color: #2ea043; }
        .btn-reject { background-color: transparent; color: #f85149; border: 1px solid rgba(248,81,73,0.3); }
        .btn-reject:hover { background-color: rgba(248,81,73,0.1); }
        
        .resume-link { color: var(--blue-accent); text-decoration: none; font-size: 0.85rem; font-weight: 500; display: flex; align-items: center; gap: 5px; margin-top: 10px; }
        .resume-link:hover { text-decoration: underline; }
        
        .back-link { display: inline-block; margin-top: 2rem; color: #8b949e; text-decoration: none; font-size: 0.9rem; }
    </style>
</head>
<body>

    <nav class="navbar">
        <span style="font-size: 1.4rem; font-weight: 700;">WorkHive <span style="color: #8b949e; font-weight: 400;">| Recruiter Console</span></span>
    </nav>

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <h2 style="margin: 0; letter-spacing: -0.5px;">Applicant Management</h2>
            <span style="color: #8b949e; font-size: 0.9rem;">Batch: 2024-2028</span>
        </div>

        <form action="viewApplications" method="GET" class="filter-bar">
            <input type="text" name="appSearch" class="filter-input" placeholder="Search by name, college, or specialization..." 
                   value="<%= (request.getParameter("appSearch") != null) ? request.getParameter("appSearch") : "" %>">
            <button type="submit" class="btn-action btn-accept" style="background-color: #1f6feb;">Apply Filter</button>
            <% if(request.getParameter("appSearch") != null) { %>
                <a href="viewApplications" class="btn-action" style="background:#30363d; color:white; text-decoration:none; display:flex; align-items:center;">Clear</a>
            <% } %>
        </form>
        
        <table>
            <thead>
                <tr>
                    <th style="width: 20%;">Job Position</th>
                    <th style="width: 45%;">Applicant Background</th>
                    <th style="width: 15%;">Timeline</th>
                    <th style="width: 20%;">Decision</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Map<String, String>> apps = (List<Map<String, String>>) request.getAttribute("applications");
                    if (apps != null && !apps.isEmpty()) {
                        for (Map<String, String> app : apps) {
                            String currentStatus = app.get("status");
                            String resumeFile = app.get("resumeFile");
                            
                            // Context for Highlighting
                            String textToScan = (app.get("specialization") + " " + app.get("instituteName") + " " + app.get("jobTitle")).toLowerCase();
                            String[] keywords = {"java", "python", "sql", "cse", "amrita", "developer", "analyst", "engineering"};
                %>
                    <tr class="app-row status-<%= currentStatus %>">
                        <td>
                            <div style="font-weight: 700; color: var(--blue-accent);"><%= app.get("jobTitle") %></div>
                            <div style="font-size: 0.75rem; color: #8b949e; margin-top: 4px;">ID: #<%= app.get("appId") %></div>
                        </td>
                        <td>
                            <div class="applicant-info">
                                <div class="applicant-email"><%= app.get("seekerEmail") %></div>
                                <div class="applicant-meta">
                                    🏢 <b><%= app.get("instituteName") %></b><br>
                                    🎓 <%= app.get("specialization") %> (<%= app.get("courseDuration") %>)
                                </div>

                                <div class="skill-container">
                                    <% for(String key : keywords) { 
                                        if(textToScan.contains(key)) { %>
                                            <span class="skill-badge"><%= key %></span>
                                    <%  } 
                                    } %>
                                </div>

                                <div class="applicant-meta" style="margin-top: 8px;">
                                    📍 <%= app.get("locationPref") %> | 🎓 Grad: <b><%= app.get("gradYear") %></b>
                                </div>
                                
                                <% if (resumeFile != null && !resumeFile.isEmpty()) { %>
                                    <a href="uploads/<%= resumeFile %>" target="_blank" class="resume-link">
                                        <span>📄</span> Download Resume PDF
                                    </a>
                                <% } %>
                            </div>
                        </td>
                        <td>
                            <div style="font-size: 0.85rem; color: #f0f6fc;"><%= app.get("appliedAt") %></div>
                            <div style="margin-top: 8px;">
                                <span class="status-badge status-<%= currentStatus %>"><%= currentStatus %></span>
                            </div>
                        </td>
                        <td>
                            <% if ("Pending".equalsIgnoreCase(currentStatus)) { %>
                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                    <form action="updateStatus" method="POST" style="margin: 0;">
                                        <input type="hidden" name="appId" value="<%= app.get("appId") %>">
                                        <input type="hidden" name="status" value="Accepted">
                                        <button type="submit" class="btn-action btn-accept" style="width: 100%;">Shortlist</button>
                                    </form>
                                    <form action="updateStatus" method="POST" style="margin: 0;">
                                        <input type="hidden" name="appId" value="<%= app.get("appId") %>">
                                        <input type="hidden" name="status" value="Rejected">
                                        <button type="submit" class="btn-action btn-reject" style="width: 100%;">Decline</button>
                                    </form>
                                </div>
                            <% } else { %>
                                <div style="color: #484f58; font-size: 0.8rem; font-style: italic; border: 1px dashed #30363d; padding: 10px; border-radius: 6px; text-align: center;">
                                    Candidate <%= currentStatus %>
                                </div>
                            <% } %>
                        </td>
                    </tr>
                <% 
                        }
                    } else { 
                %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 80px; color: #8b949e; border: 1px dashed var(--border-color); border-radius: 10px;">
                            <div style="font-size: 2rem; margin-bottom: 10px;">🔍</div>
                            No applications match your search. Try clearing filters.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <a href="dashboard.jsp" class="back-link">← Back to Recruiter Dashboard</a>
    </div>

</body>
</html>