
package com.smartresumeanalyzer;

import opennlp.tools.tokenize.SimpleTokenizer;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class SimilarityService {

	private static final Set<String> STOP_WORDS = new HashSet<>(Arrays.asList(
		    // Articles
		    "a", "an", "the",

		    // Prepositions
		    "in", "on", "at", "by", "for", "with", "about", "against", "between",
		    "into", "through", "during", "before", "after", "above", "below",
		    "to", "from", "up", "down", "out", "off", "over", "under",

		    // Conjunctions
		    "and", "or", "but", "if", "while", "although", "because",

		    // Pronouns
		    "i", "me", "my", "we", "our", "you", "your", "he", "she", "it", "they",

		    // Auxiliary / verbs
		    "is", "are", "was", "were", "be", "been", "being",
		    "have", "has", "had", "do", "does", "did",

		    // Common resume fluff words
		    "experience", "experienced", "knowledge", "skills", "skill",
		    "ability", "abilities", "proficient", "proficiency",
		    "familiar", "familiarity", "expert", "expertise",
		    "working", "worked", "developed", "development",
		    "responsible", "responsibility",

		    // Job description fillers
		    "looking", "seeking", "candidate", "role", "position",
		    "requirement", "requirements", "preferred",
		    "job", "opportunity",

		    // Misc noise words
		    "etc", "also", "very", "more", "such", "using", "use"
		));
    public static double calculateSimilarity(String resumeSkills, String jobSkills) {

        if (resumeSkills == null || jobSkills == null ||
            resumeSkills.isEmpty() || jobSkills.isEmpty()) {
            return 0.0;
        }

        SimpleTokenizer tokenizer = SimpleTokenizer.INSTANCE;

        String[] resumeTokens = tokenizer.tokenize(resumeSkills.toLowerCase());
        String[] jobTokens = tokenizer.tokenize(jobSkills.toLowerCase());

        Set<String> resumeSet = filterStopWords(resumeTokens);
        Set<String> jobSet = filterStopWords(jobTokens);

        if (jobSet.isEmpty()) return 0.0;

        Set<String> matched = new HashSet<>(jobSet);
        matched.retainAll(resumeSet);

        System.out.println("Matched skills: " + matched);

        double score = (double) matched.size() / jobSet.size() * 100;
        return Math.round(score * 100.0) / 100.0;
    }

    private static Set<String> filterStopWords(String[] tokens) {
        Set<String> filtered = new HashSet<>();
        for (String token : tokens) {
            if (token.length() > 1 &&
                !STOP_WORDS.contains(token) &&
                token.matches("[a-zA-Z0-9+#.]+")) {
                filtered.add(token);
            }
        }
        return filtered;
    }
}