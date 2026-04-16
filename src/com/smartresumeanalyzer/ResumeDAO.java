package com.smartresumeanalyzer;

import java.sql.*;

public class ResumeDAO {

    public void saveResume(Resume resume) {
        try {
            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO resumes(name, skills, score) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setString(1, resume.getName());
            pst.setString(2, resume.getSkills());
            pst.setDouble(3, resume.getScore());

            pst.executeUpdate();

            System.out.println("✅ Resume saved!");

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void viewResumes() {
        try {
            Connection con = DBConnection.getConnection();

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM resumes");

            System.out.println("\n📄 Stored Resumes:");

            while (rs.next()) {
                System.out.println(
                        rs.getInt("id") + " | " +
                        rs.getString("name") + " | " +
                        rs.getString("skills") + " | Score: " +
                        rs.getDouble("score")
                );
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}