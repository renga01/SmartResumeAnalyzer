package com.smartresumeanalyzer;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/analyze")
public class ResumeServlet extends HttpServlet {
	

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    String name = request.getParameter("name");
	    String resumeSkills = request.getParameter("resumeSkills");
	    String jobSkills = request.getParameter("jobSkills");

	    double score = SimilarityService.calculateSimilarity(resumeSkills, jobSkills);

	    Resume resume = new Resume(name, resumeSkills, score);
	    ResumeDAO dao = new ResumeDAO();
	    dao.saveResume(resume);

	    // Redirect back to JSP with results
	    response.sendRedirect("index.jsp?score=" + score 
	        + "&name=" + java.net.URLEncoder.encode(name, "UTF-8")
	        + "&resumeSkills=" + java.net.URLEncoder.encode(resumeSkills, "UTF-8")
	        + "&jobSkills=" + java.net.URLEncoder.encode(jobSkills, "UTF-8"));
	}
}