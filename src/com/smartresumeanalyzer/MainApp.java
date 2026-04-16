package com.smartresumeanalyzer;

import java.util.Scanner;

public class MainApp {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Enter Candidate Name:");
        String name = sc.nextLine();

        System.out.println("Enter Resume Skills (comma-separated):");
        String resumeSkills = sc.nextLine();

        System.out.println("Enter Job Required Skills (comma-separated):");
        String jobSkills = sc.nextLine();

        // 🔹 AI Logic
        double score = SimilarityService.calculateSimilarity(resumeSkills, jobSkills);

        System.out.println(" Match Score: " + score + "%");

        // 🔹 Save to DB
        Resume resume = new Resume(name, resumeSkills, score);

        ResumeDAO dao = new ResumeDAO();
        dao.saveResume(resume);

        dao.viewResumes();
    }
}