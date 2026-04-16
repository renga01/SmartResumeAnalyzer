package com.smartresumeanalyzer;

public class Resume {

    private int id;
    private String name;
    private String skills;
    private double score;

    public Resume(String name, String skills, double score) {
        this.name = name;
        this.skills = skills;
        this.score = score;
    }

    public String getName() { return name; }
    public String getSkills() { return skills; }
    public double getScore() { return score; }
}