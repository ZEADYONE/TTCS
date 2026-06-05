package com.example.flc.service;

import com.example.flc.domain.DTO.AiFlashcardRequestDTO;
import com.example.flc.domain.DTO.AiFlashcardResponseDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
public class AiFlashcardService {

    @Value("${ai.gemini.api-key:}")
    private String geminiApiKey;

    @Value("${ai.gemini.model:gemini-1.5-flash}")
    private String geminiModel;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AiFlashcardResponseDTO generateFlashcard(AiFlashcardRequestDTO requestDTO) {
        if (geminiApiKey == null || geminiApiKey.trim().isEmpty()) {
            throw new RuntimeException("Gemini API key is not configured.");
        }

        String url = "https://generativelanguage.googleapis.com/v1beta/models/" + geminiModel + ":generateContent?key=" + geminiApiKey;

        String prompt = "You are an English learning assistant for Vietnamese students.\n" +
                "Given one English word, generate flashcard information.\n" +
                "Return only valid JSON with these fields: word, transliteration, vietnamese, example, definition.\n" +
                "The Vietnamese meaning must be natural and easy to understand.\n" +
                "The example sentence must be simple.\n" +
                "The definition must be in English and suitable for learners.\n" +
                "Do not include any extra text or markdown formatting.\n" +
                "Word: " + requestDTO.getWord();

        try {
            Map<String, Object> requestBody = Map.of(
                    "contents", List.of(
                            Map.of("parts", List.of(
                                    Map.of("text", prompt)
                            ))
                    )
            );

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            Map<String, Object> body = response.getBody();

            if (body != null && body.containsKey("candidates")) {
                List<Map<String, Object>> candidates = (List<Map<String, Object>>) body.get("candidates");
                if (!candidates.isEmpty()) {
                    Map<String, Object> content = (Map<String, Object>) candidates.get(0).get("content");
                    List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
                    if (!parts.isEmpty()) {
                        String text = (String) parts.get(0).get("text");
                        // Clean up markdown if Gemini ignores instructions
                        if (text.startsWith("```json")) {
                            text = text.substring(7);
                        }
                        if (text.startsWith("```")) {
                            text = text.substring(3);
                        }
                        if (text.endsWith("```")) {
                            text = text.substring(0, text.length() - 3);
                        }
                        text = text.trim();
                        return objectMapper.readValue(text, AiFlashcardResponseDTO.class);
                    }
                }
            }
            throw new RuntimeException("Invalid response from Gemini AI.");
        } catch (Exception e) {
            throw new RuntimeException("Error calling Gemini API: " + e.getMessage(), e);
        }
    }
}
