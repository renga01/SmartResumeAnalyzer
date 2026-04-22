<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Resume Analyzer</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 600px;
            padding: 40px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
            font-size: 28px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
            font-size: 14px;
        }
        
        input[type="text"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s ease;
        }
        
        input[type="text"]:focus,
        input[type="file"]:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.2);
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .file-input-wrapper {
            position: relative;
        }
        
        input[type="file"] {
            padding: 10px;
        }
        
        .file-hint {
            font-size: 12px;
            color: #888;
            margin-top: 5px;
        }
        
        .section-divider {
            margin: 30px 0;
            padding: 20px 0;
            border-top: 2px solid #f0f0f0;
            border-bottom: 2px solid #f0f0f0;
            background-color: #fafafa;
        }
        
        .section-title {
            font-size: 16px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 15px;
        }
        
        .toggle-section {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .toggle-btn {
            flex: 1;
            padding: 10px;
            border: 2px solid #e0e0e0;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            color: #666;
            transition: all 0.3s ease;
        }
        
        .toggle-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .input-option {
            display: none;
        }
        
        .input-option.active {
            display: block;
        }
        
        button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            margin-top: 10px;
        }
        
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }
        
        button:active {
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📄 Smart Resume Analyzer</h1>
        
        <form method="POST" action="analyze" enctype="multipart/form-data">
            <!-- Name Section -->
            <div class="form-group">
                <label for="name">Your Name *</label>
                <input type="text" id="name" name="name" placeholder="Enter your full name" required>
            </div>
            
            <!-- Resume Section -->
            <div class="section-divider">
                <div class="section-title">Resume/Skills</div>
                
                <div class="toggle-section">
                    <button type="button" class="toggle-btn active" onclick="toggleResumeInput('pdf')">📤 Upload PDF</button>
                    <button type="button" class="toggle-btn" onclick="toggleResumeInput('text')">✏️ Enter Text</button>
                </div>
                
                <div id="resumePdfOption" class="input-option active">
                    <div class="form-group">
                        <label for="resumeFile">Upload Resume PDF</label>
                        <input type="file" id="resumeFile" name="resumeFile" accept=".pdf">
                        <div class="file-hint">Accepted format: PDF files only</div>
                    </div>
                </div>
                
                <div id="resumeTextOption" class="input-option">
                    <div class="form-group">
                        <label for="resumeSkills">Or Enter Your Skills</label>
                        <textarea id="resumeSkills" name="resumeSkills" placeholder="List your skills, experience, and qualifications..."></textarea>
                    </div>
                </div>
            </div>
            
            <!-- Job Requirements Section -->
            <div class="section-divider">
                <div class="section-title">Job Requirements</div>
                
                <div class="toggle-section">
                    <button type="button" class="toggle-btn active" onclick="toggleJobInput('pdf')">📤 Upload PDF</button>
                    <button type="button" class="toggle-btn" onclick="toggleJobInput('text')">✏️ Enter Text</button>
                </div>
                
                <div id="jobPdfOption" class="input-option active">
                    <div class="form-group">
                        <label for="jobSkillsFile">Upload Job Description PDF</label>
                        <input type="file" id="jobSkillsFile" name="jobSkillsFile" accept=".pdf">
                        <div class="file-hint">Accepted format: PDF files only</div>
                    </div>
                </div>
                
                <div id="jobTextOption" class="input-option">
                    <div class="form-group">
                        <label for="jobSkills">Or Enter Job Requirements</label>
                        <textarea id="jobSkills" name="jobSkills" placeholder="List the job requirements, skills needed, and qualifications..."></textarea>
                    </div>
                </div>
            </div>
            
            <!-- Submit Button -->
            <button type="submit">Analyze Resume 🚀</button>
        </form>
    </div>
    
    <script>
        function toggleResumeInput(type) {
            const pdfOption = document.getElementById('resumePdfOption');
            const textOption = document.getElementById('resumeTextOption');
            const pdfBtn = document.querySelectorAll('#resumePdfOption').parentElement;
            
            const buttons = document.querySelectorAll('.toggle-section button');
            
            if (type === 'pdf') {
                pdfOption.classList.add('active');
                textOption.classList.remove('active');
                // Clear text input when switching
                document.getElementById('resumeSkills').value = '';
            } else {
                pdfOption.classList.remove('active');
                textOption.classList.add('active');
                // Clear file input when switching
                document.getElementById('resumeFile').value = '';
            }
        }
        
        function toggleJobInput(type) {
            const pdfOption = document.getElementById('jobPdfOption');
            const textOption = document.getElementById('jobTextOption');
            
            if (type === 'pdf') {
                pdfOption.classList.add('active');
                textOption.classList.remove('active');
                // Clear text input when switching
                document.getElementById('jobSkills').value = '';
            } else {
                pdfOption.classList.remove('active');
                textOption.classList.add('active');
                // Clear file input when switching
                document.getElementById('jobSkillsFile').value = '';
            }
        }
        
        // Update button active state
        document.addEventListener('DOMContentLoaded', function() {
            const toggleButtons = document.querySelectorAll('.toggle-btn');
            toggleButtons.forEach((button, index) => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const section = this.parentElement;
                    const sibling = this.parentElement.parentElement;
                    const buttons = section.querySelectorAll('button');
                    
                    buttons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        });
    </script>
</body>
</html>