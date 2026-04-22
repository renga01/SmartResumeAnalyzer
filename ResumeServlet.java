package com.smartresumeanalyzer;

import java.io.IOException;
import java.io.InputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/analyze")
@MultipartConfig
public class ResumeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        
        // Extract resume text from PDF or manual input
        Part resumeFilePart = request.getPart("resumeFile");
        String resumeText = "";

        if (resumeFilePart != null && resumeFilePart.getSize() > 0) {
            // PDF uploaded — extract text from it
            InputStream fileStream = resumeFilePart.getInputStream();
            resumeText = PDFExtractorService.extractText(fileStream);
        } else {
            // No PDF — fall back to manual text input
            resumeText = request.getParameter("resumeSkills");
            if (resumeText == null) resumeText = "";
        }

        // Extract job skills from PDF or manual input
        Part jobSkillsFilePart = request.getPart("jobSkillsFile");
        String jobSkills = "";

        if (jobSkillsFilePart != null && jobSkillsFilePart.getSize() > 0) {
            // PDF uploaded — extract text from it
            InputStream fileStream = jobSkillsFilePart.getInputStream();
            jobSkills = PDFExtractorService.extractText(fileStream);
        } else {
            // No PDF — fall back to manual text input
            jobSkills = request.getParameter("jobSkills");
            if (jobSkills == null) jobSkills = "";
        }

        // Calculate score
        double score = SimilarityService.calculateSimilarity(resumeText, jobSkills);

        // Save to DB
        Resume resume = new Resume(name, resumeText, score);
        ResumeDAO dao = new ResumeDAO();
        dao.saveResume(resume);

        // Pass data to result page
        request.setAttribute("score", score);
        request.setAttribute("name", name);
        request.setAttribute("resumeText", resumeText);
        request.setAttribute("jobSkills", jobSkills);
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}