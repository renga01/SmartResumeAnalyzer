package com.smartresumeanalyzer;
 
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import java.io.InputStream;
 
public class PDFExtractorService {
 
    public static String extractText(InputStream inputStream) {
        PDDocument document = null;
        try {
            byte[] bytes = inputStream.readAllBytes();
            document = Loader.loadPDF(bytes);
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document);
            return text;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        } finally {
            // Ensure document is closed
            if (document != null) {
                try {
                    document.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}