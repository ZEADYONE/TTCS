package com.example.flc.controller.api;

import com.example.flc.domain.DTO.AiFlashcardRequestDTO;
import com.example.flc.domain.DTO.AiFlashcardResponseDTO;
import com.example.flc.service.AiFlashcardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai/flashcards")
public class AiFlashcardRestController {

    private final AiFlashcardService aiFlashcardService;

    public AiFlashcardRestController(AiFlashcardService aiFlashcardService) {
        this.aiFlashcardService = aiFlashcardService;
    }

    @PostMapping("/generate")
    public ResponseEntity<?> generate(@RequestBody AiFlashcardRequestDTO requestDTO) {
        if (requestDTO == null || requestDTO.getWord() == null || requestDTO.getWord().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Word cannot be null or empty.");
        }
        if (requestDTO.getWord().length() > 100) {
            return ResponseEntity.badRequest().body("Word cannot exceed 100 characters.");
        }

        try {
            AiFlashcardResponseDTO response = aiFlashcardService.generateFlashcard(requestDTO);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error from AI: " + e.getMessage());
        }
    }
}
