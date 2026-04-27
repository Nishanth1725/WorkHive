<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security: Redirect if not a seeker
    String role = (String) session.getAttribute("userRole");
    String jobId = request.getParameter("jobId");
    
    if (role == null || !"SEEKER".equals(role) || jobId == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Application - WorkHive</title>
    <style>
        :root {
            --primary: #1f6feb;
            --bg: #0b0e14;
            --card: #151b23;
            --border: #30363d;
            --text-muted: #8b949e;
        }

        body { background-color: var(--bg); color: #ffffff; font-family: 'Inter', sans-serif; margin: 0; }
        .navbar { background-color: #12161d; padding: 1rem 2.5rem; border-bottom: 1px solid var(--border); }
        .container { padding: 3rem 2rem; max-width: 750px; margin: auto; }
        
        .apply-card {
            background-color: var(--card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 2.5rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
        }

        h2 { margin: 0 0 10px 0; color: #f0f6fc; }
        h3 { font-size: 1.1rem; color: #f0f6fc; margin: 25px 0 15px 0; border-bottom: 1px solid var(--border); padding-bottom: 8px; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 1.5rem; display: flex; flex-direction: column; }
        .full-width { grid-column: span 2; }

        label { margin-bottom: 8px; font-size: 0.9rem; font-weight: 600; color: #f0f6fc; }
        label span { color: #f85149; } /* Asterisk for required */

        input, select {
            padding: 10px 12px;
            background-color: #0d1117;
            border: 1px solid var(--border);
            border-radius: 6px;
            color: white;
            font-size: 0.95rem;
        }

        input:focus { border-color: var(--primary); outline: none; }

        .upload-section {
            background: rgba(31, 111, 235, 0.05);
            border: 2px dashed var(--border);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            margin-top: 10px;
        }

        .btn-submit {
            background-color: #238636;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            font-size: 1rem;
            margin-top: 20px;
        }
        .btn-submit:hover { background-color: #2ea043; }
        
        .back-link { display: block; text-align: center; margin-top: 1.5rem; color: var(--text-muted); text-decoration: none; font-size: 0.9rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <div style="font-size: 1.4rem; font-weight: 700; color: #f0f6fc;">WorkHive</div>
</nav>

<div class="container">
    <div class="apply-card">
        <h2>Application Form</h2>
        <p style="color: var(--text-muted);">Applying for Job ID: <strong><%= jobId %></strong></p>

        <form action="apply" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="jobId" value="<%= jobId %>">

            <h3>Academic Information</h3>
            <div class="form-group">
                <label>Institute Name <span>*</span></label>
                <input type="text" name="institute" value="Amrita Vishwa vidhyapeetham, Amritapuri" required>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Course Specialization <span>*</span></label>
                    <select name="specialization" required>
                        <option value="Computer Science and Engineering">Computer Science and Engineering</option>
                        <option value="Electronics and Communication">Electronics and Communication</option>
                        <option value="Mechanical Engineering">Mechanical Engineering</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Course Duration <span>*</span></label>
                    <select name="duration" required>
                        <option value="4 Years">4 Years</option>
                        <option value="3 Years">3 Years</option>
                        <option value="2 Years">2 Years</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Graduating Year <span>*</span></label>
                <div style="display: flex; gap: 10px;">
                    <label style="font-weight: normal;"><input type="radio" name="gradYear" value="2026" required> 2026</label>
                    <label style="font-weight: normal;"><input type="radio" name="gradYear" value="2027"> 2027</label>
                    <label style="font-weight: normal;"><input type="radio" name="gradYear" value="2028" checked> 2028</label>
                    <label style="font-weight: normal;"><input type="radio" name="gradYear" value="2029"> 2029</label>
                </div>
            </div>

            <h3>Personal Details</h3>
            <div class="form-group">
                <label>Current Location <span>*</span></label>
                <input type="text" name="locationPref" placeholder="e.g. Hyderabad, India" required>
            </div>

            <h3>Documents</h3>
            <div class="upload-section">
                <label>Upload Resume (PDF only) <span>*</span></label>
                <input type="file" name="resume" accept=".pdf" required>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 10px;">
                    Make sure your resume is up to date and highlights your CSE skills.
                </p>
            </div>

            <div style="margin-top: 20px; font-size: 0.85rem; color: var(--text-muted);">
                <input type="checkbox" required> I agree to share my academic and personal data with the recruiter for analysis and outreach.
            </div>

            <button type="submit" class="btn-submit">Submit Application</button>
        </form>
        
        <a href="dashboard.jsp" class="back-link">← Cancel and return</a>
    </div>
</div>

</body>
</html>