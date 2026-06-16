package com.example.flc.controller.client;

import java.security.Principal;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.flc.domain.DTO.interaction.InteractiveGameResponse;
import com.example.flc.service.InteractiveGameException;
import com.example.flc.service.InteractiveGameService;

@Controller
class InteractiveGamePageController {

    private final InteractiveGameService interactiveGameService;

    InteractiveGamePageController(InteractiveGameService interactiveGameService) {
        this.interactiveGameService = interactiveGameService;
    }

    @GetMapping("/client/interactive/{deckId}")
    public String showGame(
            @PathVariable long deckId,
            @RequestParam(defaultValue = "false") boolean preview,
            Principal principal,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (principal == null) {
            return "redirect:/login";
        }

        try {
            InteractiveGameResponse game = interactiveGameService.getGameResponse(
                    deckId, preview, principal.getName());
            model.addAttribute("deckId", game.deckId());
            model.addAttribute("deckTitle", game.deckTitle());
            model.addAttribute("preview", preview);
            model.addAttribute(
                    "backUrl",
                    preview
                            ? "/admin/course/" + deckId + "/interaction"
                            : "/client/deck/" + deckId);
            return "client/deck/interactive-game";
        } catch (InteractiveGameException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
            if (preview) {
                return "redirect:/admin/course/" + deckId + "/interaction";
            }
            return "redirect:/client/deck/" + deckId;
        }
    }
}

@RestController
@RequestMapping("/api/decks")
public class InteractiveGameController {

    private final InteractiveGameService interactiveGameService;

    public InteractiveGameController(InteractiveGameService interactiveGameService) {
        this.interactiveGameService = interactiveGameService;
    }

    @GetMapping("/{deckId}/interactive-config")
    public ResponseEntity<?> getConfig(
            @PathVariable long deckId,
            @RequestParam(defaultValue = "false") boolean preview,
            Principal principal) {
        try {
            String email = principal == null ? null : principal.getName();
            return ResponseEntity.ok(interactiveGameService.getGameResponse(deckId, preview, email));
        } catch (InteractiveGameException exception) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ErrorResponse(exception.getMessage()));
        }
    }

    private record ErrorResponse(String message) {
    }
}
