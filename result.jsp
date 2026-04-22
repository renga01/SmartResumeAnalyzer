<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartresumeanalyzer.SimilarityService" %>
<%@ page import="java.util.Set" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analysis Results - Smart Resume Analyzer</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 40px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .header h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }
        
        .header p {
            color: #666;
            font-size: 18px;
        }
        
        .candidate-name {
            color: #667eea;
            font-weight: 600;
        }
        
        .score-section {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            color: white;
        }
        
        .score-value {
            font-size: 64px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .score-label {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .score-bar {
            width: 100%;
            height: 20px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            overflow: hidden;
            margin-top: 20px;
        }
        
        .score-fill {
            height: 100%;
            background: #4CAF50;
            transition: width 0.3s ease;
            border-radius: 10px;
        }
        
        .skills-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .matched-skills .section-title {
            color: #4CAF50;
        }
        
        .missing-skills .section-title {
            color: #f44336;
        }
        
        .skills-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            padding: 20px;
            background: #f5f5f5;
            border-radius: 8px;
            min-height: 60px;
        }
        
        .skill-tag {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 14px;
            display: inline-block;
        }
        
        .skill-tag.matched {
            background-color: #c8e6c9;
            color: #2e7d32;
            border: 1px solid #81c784;
        }
        
        .skill-tag.missing {
            background-color: #ffcdd2;
            color: #c62828;
            border: 1px solid #ef5350;
        }
        
        .no-skills {
            color: #999;
            font-style: italic;
        }
        
        .extracted-text {
            margin-top: 40px;
            padding: 20px;
            background: #f9f9f9;
            border-left: 4px solid #667eea;
            border-radius: 5px;
        }
        
        .extracted-text h3 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .extracted-text-content {
            background: white;
            padding: 15px;
            border-radius: 5px;
            line-height: 1.6;
            color: #555;
            max-height: 250px;
            overflow-y: auto;
            font-size: 14px;
        }
        
        .action-buttons {
            margin-top: 30px;
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #f0f0f0;
            color: #333;
            border: 2px solid #ddd;
        }
        
        .btn-secondary:hover {
            background: #e0e0e0;
        }
        
        .summary {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            padding: 20px;
            background: #f5f5f5;
            border-radius: 8px;
            text-align: center;
        }
        
        .summary-card h4 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .summary-card .number {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Analysis Results</h1>
            <p>Candidate: <span class="candidate-name"><%= request.getAttribute("name") %></span></p>
        </div>
        
        <%
            String resumeText = (String) request.getAttribute("resumeText");
            String jobSkills = (String) request.getAttribute("jobSkills");
            Double score = (Double) request.getAttribute("score");
            
            Set<String> matchedSkills = SimilarityService.getMatchedSkills(resumeText, jobSkills);
            Set<String> missingSkills = SimilarityService.getMissingSkills(resumeText, jobSkills);
            
            if (score == null) score = 0.0;
        %>
        
        <!-- Score Section -->
        <div class="score-section">
            <div class="score-value"><%= String.format("%.1f", score) %>%</div>
            <div class="score-label">Resume Match Score</div>
            <div class="score-bar">
                <div class="score-fill" style="width: <%= String.format("%.1f", score) %>%"></div>
            </div>
        </div>
        
        <!-- Summary Cards -->
        <div class="summary">
            <div class="summary-card">
                <h4>Matched Skills</h4>
                <div class="number"><%= matchedSkills.size() %></div>
            </div>
            <div class="summary-card">
                <h4>Missing Skills</h4>
                <div class="number"><%= missingSkills.size() %></div>
            </div>
        </div>
        
        <!-- Matched Skills -->
        <div class="skills-section matched-skills">
            <div class="section-title">
                <span>✅</span> Matched Skills (<%= matchedSkills.size() %>)
            </div>
            <div class="skills-container">
                <% if (matchedSkills.isEmpty()) { %>
                    <span class="no-skills">No matched skills found</span>
                <% } else { %>
                    <% for (String skill : matchedSkills) { %>
                        <span class="skill-tag matched"><%= skill %></span>
                    <% } %>
                <% } %>
            </div>
        </div>
        
        <!-- Missing Skills -->
        <div class="skills-section missing-skills">
            <div class="section-title">
                <span>❌</span> Missing Skills (<%= missingSkills.size() %>)
            </div>
            <div class="skills-container">
                <% if (missingSkills.isEmpty()) { %>
                    <span class="no-skills">All required skills are present! 🎉</span>
                <% } else { %>
                    <% for (String skill : missingSkills) { %>
                        <span class="skill-tag missing"><%= skill %></span>
                    <% } %>
                <% } %>
            </div>
        </div>
        
        <!-- Extracted Resume Text -->
        <div class="extracted-text">
            <h3>📄 Extracted Resume Text</h3>
            <div class="extracted-text-content">
                <%= resumeText != null && !resumeText.isEmpty() ? resumeText : "No resume text available" %>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="index.jsp" class="btn btn-primary">← Analyze Another Resume</a>
        </div>
    </div>
</body>
</html>