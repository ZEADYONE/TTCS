package com.example.flc.controller.client;

import java.security.Principal;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.flc.domain.DTO.ProgressRequest;
import com.example.flc.service.ProgressService;

@RestController
@RequestMapping("/api/progress")
public class ProgressController {

    private final ProgressService progressService;

    public ProgressController(ProgressService progressService) {
        this.progressService = progressService;
    }

    @PostMapping("/save")
    public ResponseEntity<?> save(@RequestBody ProgressRequest req,
            Principal principal) {

        String email = principal.getName();

        progressService.save(email, req.getCardId(), req.isCorrect());

        return ResponseEntity.ok().build();
    }
}
