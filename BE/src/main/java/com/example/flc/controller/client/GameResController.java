package com.example.flc.controller.client;

import java.security.Principal;
import java.time.LocalDateTime;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.flc.domain.GameRes;
import com.example.flc.domain.User;
import com.example.flc.domain.DTO.GameResDTO;
import com.example.flc.service.DeckService;
import com.example.flc.service.GameResService;
import com.example.flc.service.UserService;

@RestController
@RequestMapping("/api/game")
public class GameResController {

    private final GameResService gameResService;
    private final UserService userService;
    private final DeckService deckService;

    public GameResController(GameResService gameResService, UserService userService, DeckService deckService) {
        this.gameResService = gameResService;
        this.userService = userService;
        this.deckService = deckService;
    }

    @PostMapping("/save")
    public ResponseEntity<?> saveResult(@RequestBody GameResDTO dto, Principal principal) {
        GameRes result = new GameRes();
        result.setCorrect(dto.getCorrect());
        result.setWrong(dto.getWrong());
        result.setPlayAt(LocalDateTime.now().toString());
        result.setDeck(this.deckService.getDeckById(dto.getDeckId()));

        String username = principal.getName();
        User user = this.userService.getUserByEmail(username);
        result.setUser(user);
        // result.setUser(userService.findById(dto.getUserId()));
        // result.setDeck(deckService.findById(dto.getDeckId()));

        this.gameResService.handleSaveGame(result);
        return ResponseEntity.ok("Saved successfully");
    }
}
