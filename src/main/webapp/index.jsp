<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Smart Resume Analyzer</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'DM Sans', sans-serif; background: #f5f4f0; min-height: 100vh; display: flex; align-items: flex-start; justify-content: center; padding: 2rem 1rem; }
    .wrap { width: 100%; max-width: 700px; }

    .header { margin-bottom: 2rem; }
    .logo { display: flex; align-items: center; gap: 12px; margin-bottom: 6px; }
    .logo-icon { width: 40px; height: 40px; border-radius: 12px; background: #dbeafe; display: flex; align-items: center; justify-content: center; }
    .logo-icon svg { width: 22px; height: 22px; }
    h1 { font-family: 'DM Serif Display', serif; font-size: 28px; font-weight: 400; color: #1a1a1a; }
    .subtitle { font-size: 14px; color: #6b6b6b; margin-top: 4px; }

    .card { background: #fff; border: 0.5px solid #e0ded8; border-radius: 14px; padding: 1.5rem; margin-bottom: 1rem; }
    label { font-size: 11px; font-weight: 500; color: #888; text-transform: uppercase; letter-spacing: 0.07em; display: block; margin-bottom: 8px; }
    input[type="text"], textarea {
      width: 100%; padding: 10px 12px; font-size: 14px; font-family: 'DM Sans', sans-serif;
      border: 0.5px solid #d4d2cc; border-radius: 8px; background: #fafaf8;
      color: #1a1a1a; resize: vertical;
    }
    input[type="text"] { height: 42px; }
    input[type="text"]:focus, textarea:focus { outline: none; border-color: #aaa; }

    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
    @media (max-width: 520px) { .grid { grid-template-columns: 1fr; } }

    .btn {
      width: 100%; padding: 13px; font-size: 15px; font-family: 'DM Sans', sans-serif;
      font-weight: 500; background: #1a1a1a; color: #fff; border: none;
      border-radius: 8px; cursor: pointer; margin-top: 1rem; letter-spacing: 0.01em; transition: opacity 0.15s;
    }
    .btn:hover { opacity: 0.85; }
    .btn:active { transform: scale(0.99); }

    .result { display: none; }
    .result.show { display: block; }

    .score-wrap { display: flex; align-items: center; gap: 1.5rem; padding: 1.25rem; background: #f5f4f0; border-radius: 10px; margin-bottom: 1rem; }
    .score-num { font-family: 'DM Serif Display', serif; font-size: 52px; line-height: 1; color: #1a1a1a; }
    .score-label { font-size: 13px; color: #888; margin-top: 4px; }
    .bar-bg { height: 6px; background: #e0ded8; border-radius: 99px; margin-top: 10px; overflow: hidden; }
    .bar-fill { height: 100%; border-radius: 99px; background: #1a1a1a; transition: width 0.8s cubic-bezier(.4,0,.2,1); width: 0%; }
    .verdict { font-size: 12px; color: #6b6b6b; margin-top: 6px; }

    hr { border: none; border-top: 0.5px solid #e0ded8; margin: 1rem 0; }
    .section-title { font-size: 11px; font-weight: 500; color: #888; text-transform: uppercase; letter-spacing: 0.07em; margin: 1rem 0 6px; }
    .tag-row { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 6px; }
    .tag { font-size: 12px; padding: 4px 10px; border-radius: 99px; }
    .tag.match { background: #dbeafe; color: #1e40af; }
    .tag.miss { background: #fee2e2; color: #991b1b; }
    .result-name { font-size: 13px; color: #6b6b6b; margin-bottom: 1rem; }
    .result-name span { font-weight: 500; color: #1a1a1a; }
  </style>
</head>
<body>
<div class="wrap">

  <div class="header">
    <div class="logo">
      <div class="logo-icon">
        <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
          <rect x="3" y="2" width="10" height="13" rx="2" stroke="#1d4ed8" stroke-width="1.5"/>
          <path d="M6 6h4M6 9h4M6 12h2" stroke="#1d4ed8" stroke-width="1.5" stroke-linecap="round"/>
          <circle cx="14.5" cy="14.5" r="3" stroke="#1d4ed8" stroke-width="1.5"/>
          <path d="M17 17l1.5 1.5" stroke="#1d4ed8" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
      </div>
      <h1>Smart Resume Analyzer</h1>
    </div>
    <p class="subtitle">Paste your skills and the job requirements to get your match score</p>
  </div>

  <form action="analyze" method="post" id="resumeForm">
    <div class="card">
      <label for="name">Your name</label>
      <input type="text" id="name" name="name" placeholder="e.g. Arjun Sharma"/>
    </div>

    <div class="card">
      <div class="grid">
        <div>
          <label for="resumeSkills">Your resume skills</label>
          <textarea id="resumeSkills" name="resumeSkills" rows="6" placeholder="e.g. Java, Python, SQL, Spring Boot, REST APIs, Git..."></textarea>
        </div>
        <div>
          <label for="jobSkills">Job required skills</label>
          <textarea id="jobSkills" name="jobSkills" rows="6" placeholder="e.g. Python, Docker, Kubernetes, SQL, CI/CD..."></textarea>
        </div>
      </div>
      <button type="submit" class="btn">Analyze match</button>
    </div>
  </form>

  <%
    String scoreParam = request.getParameter("score");
    String nameParam = request.getParameter("name");
    String resumeParam = request.getParameter("resumeSkills");
    String jobParam = request.getParameter("jobSkills");
    if (scoreParam != null) {
  %>
  <div class="card result show">
    <% if (nameParam != null && !nameParam.isEmpty()) { %>
      <p class="result-name">Results for <span><%= nameParam %></span></p>
    <% } %>
    <div class="score-wrap">
      <div>
        <div class="score-num"><%= scoreParam %>%</div>
        <div class="score-label">match score</div>
      </div>
      <div style="flex:1">
        <div class="bar-bg"><div class="bar-fill" id="bar"></div></div>
        <div class="verdict" id="verdict"></div>
      </div>
    </div>
    <hr/>
    <div class="section-title">Matched skills</div>
    <div class="tag-row" id="matchedTags"></div>
    <div class="section-title" style="margin-top:0.75rem;">Missing skills</div>
    <div class="tag-row" id="missingTags"></div>
  </div>
  <script>
    var score = <%= scoreParam %>;
    var resume = "<%= resumeParam != null ? resumeParam.toLowerCase().replace("\"", "\\\"") : "" %>";
    var job = "<%= jobParam != null ? jobParam.toLowerCase().replace("\"", "\\\"") : "" %>";
    var stopWords = new Set(['and','or','the','a','an','in','on','at','to','for','of','with','is','are','was','were','have','has','experience','knowledge','skills','ability','proficient']);
    function tokenize(t) { return t.split(/[\s,;\/\n]+/).map(s=>s.replace(/[^a-z0-9+#.]/g,'')).filter(s=>s.length>1&&!stopWords.has(s)); }
    var resumeSet = new Set(tokenize(resume));
    var jobSet = new Set(tokenize(job));
    var matched = [...jobSet].filter(s=>resumeSet.has(s));
    var missing = [...jobSet].filter(s=>!resumeSet.has(s));
    document.getElementById('matchedTags').innerHTML = matched.length ? matched.map(s=>'<span class="tag match">'+s+'</span>').join('') : '<span style="font-size:13px;color:#888">None found</span>';
    document.getElementById('missingTags').innerHTML = missing.length ? missing.map(s=>'<span class="tag miss">'+s+'</span>').join('') : '<span style="font-size:13px;color:#888">None — perfect match!</span>';
    var verdict = score>=75?'Strong match — great fit!':score>=50?'Decent match — some gaps to address':score>=25?'Partial match — consider upskilling':'Low match — significant gaps found';
    document.getElementById('verdict').textContent = verdict;
    setTimeout(function(){ document.getElementById('bar').style.width = score+'%'; }, 100);
  </script>
  <% } %>

</div>
</body>
</html>
