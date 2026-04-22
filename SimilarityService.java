package com.smartresumeanalyzer;

import java.util.*;

public class SimilarityService {

    // Common English stop words to exclude
    private static final Set<String> STOP_WORDS = new HashSet<>(Arrays.asList(
        "the", "a", "an", "and", "or", "but", "if", "in", "of", "to", "for", "is", "are",
        "was", "were", "be", "been", "being", "have", "has", "had", "do", "does", "did",
        "will", "would", "could", "should", "may", "might", "must", "can", "as", "at",
        "by", "from", "with", "about", "into", "through", "during", "before", "after",
        "above", "below", "up", "down", "out", "off", "over", "under", "again", "further",
        "then", "once", "here", "there", "when", "looking","where", "why", "how", "all", "each",
        "every", "both", "few", "more", "most", "other", "some", "such", "no", "nor",
        "not", "only", "own", "same", "so", "than", "too", "very", "just", "am", "we",
        "him", "her", "it", "they", "them", "what", "which", "who", "whom", "this",
        "that", "these", "those", "i", "you", "he", "she", "he", "its", "our", "your",
        "their", "my", "his", "hers", "yours", "ours", "theirs", "me", "him", "her",
        "us", "them", "on", "while", "advantage", "added", "required", "methodology",
        "programming", "boot", "candidate", "database", "developer", "docker"
    ));

    /**
     * Calculate similarity between resume text and job requirements
     * Returns a score between 0 and 100
     */
    public static double calculateSimilarity(String resumeText, String jobRequirements) {
        if (resumeText == null || jobRequirements == null || 
            resumeText.isEmpty() || jobRequirements.isEmpty()) {
            return 0.0;
        }

        // Extract skills from both texts
        Set<String> resumeSkills = extractSkills(resumeText);
        Set<String> jobSkills = extractSkills(jobRequirements);

        if (jobSkills.isEmpty()) {
            return 0.0;
        }

        // Calculate matched skills
        Set<String> matchedSkills = new HashSet<>(resumeSkills);
        matchedSkills.retainAll(jobSkills);

        // Calculate similarity score
        double score = (double) matchedSkills.size() / jobSkills.size() * 100;
        return Math.min(score, 100.0); // Cap at 100
    }

    /**
     * Extract skills and filter out stop words and short words
     */
    private static Set<String> extractSkills(String text) {
        Set<String> skills = new HashSet<>();
        
        // Convert to lowercase and split by non-word characters
        String[] words = text.toLowerCase().split("[\\W_]+");
        
        for (String word : words) {
            // Skip empty strings, stop words, and words less than 3 characters
            if (!word.isEmpty() && 
                !STOP_WORDS.contains(word) && 
                word.length() >= 3) {
                skills.add(word);
            }
        }
        
        return skills;
    }

    /**
     * Get matched skills between resume and job requirements
     */
    public static Set<String> getMatchedSkills(String resumeText, String jobRequirements) {
        Set<String> resumeSkills = extractSkills(resumeText);
        Set<String> jobSkills = extractSkills(jobRequirements);
        
        Set<String> matched = new HashSet<>(resumeSkills);
        matched.retainAll(jobSkills);
        return matched;
    }

    /**
     * Get missing skills from job requirements
     */
    public static Set<String> getMissingSkills(String resumeText, String jobRequirements) {
        Set<String> resumeSkills = extractSkills(resumeText);
        Set<String> jobSkills = extractSkills(jobRequirements);
        
        Set<String> missing = new HashSet<>(jobSkills);
        missing.removeAll(resumeSkills);
        return missing;
    }
}