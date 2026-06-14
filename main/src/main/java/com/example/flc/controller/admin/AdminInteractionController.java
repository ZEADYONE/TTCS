package com.example.flc.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.flc.domain.DeckInteractionConfig;
import com.example.flc.domain.DTO.interaction.InteractionConfigRequest;
import com.example.flc.domain.DTO.interaction.InteractiveTaskRequest;
import com.example.flc.service.InteractiveGameException;
import com.example.flc.service.InteractiveGameService;

@Controller
@RequestMapping("/admin/course")
public class AdminInteractionController {

    private final InteractiveGameService interactiveGameService;

    public AdminInteractionController(InteractiveGameService interactiveGameService) {
        this.interactiveGameService = interactiveGameService;
    }

    @GetMapping("/{deckId}/interaction")
    public String viewInteraction(@PathVariable long deckId, Model model) {
        DeckInteractionConfig config = interactiveGameService.getOrCreateAdminConfig(deckId);
        model.addAttribute("deck", config.getDeck());
        model.addAttribute("config", config);
        model.addAttribute("cards", interactiveGameService.getCardsForAdmin(deckId));
        model.addAttribute("tasks", interactiveGameService.getTasksForAdmin(deckId));
        model.addAttribute("templates", interactiveGameService.getTemplates());
        model.addAttribute("themes", interactiveGameService.getThemes());
        model.addAttribute(
                "variants",
                interactiveGameService.getVariantsForTemplate(config.getTemplateKey()));
        return "admin/course/interaction";
    }

    @PostMapping("/{deckId}/interaction/config")
    public String saveConfig(
            @PathVariable long deckId,
            @ModelAttribute InteractionConfigRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            interactiveGameService.saveConfig(deckId, request);
            redirectAttributes.addFlashAttribute("successMessage", "Đã lưu cấu hình chung.");
        } catch (InteractiveGameException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return redirectToConfig(deckId);
    }

    @PostMapping("/{deckId}/interaction/tasks")
    public String saveTask(
            @PathVariable long deckId,
            @ModelAttribute InteractiveTaskRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            interactiveGameService.saveTask(deckId, request);
            redirectAttributes.addFlashAttribute("successMessage", "Đã lưu round.");
        } catch (InteractiveGameException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return redirectToConfig(deckId);
    }

    @PostMapping("/{deckId}/interaction/tasks/{taskId}/delete")
    public String deleteTask(
            @PathVariable long deckId,
            @PathVariable long taskId,
            RedirectAttributes redirectAttributes) {
        try {
            interactiveGameService.deleteTask(deckId, taskId);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa round.");
        } catch (InteractiveGameException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return redirectToConfig(deckId);
    }

    @PostMapping("/{deckId}/interaction/tasks/{taskId}/move")
    public String moveTask(
            @PathVariable long deckId,
            @PathVariable long taskId,
            @RequestParam String direction,
            RedirectAttributes redirectAttributes) {
        try {
            interactiveGameService.moveTask(deckId, taskId, direction);
        } catch (InteractiveGameException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return redirectToConfig(deckId);
    }

    @GetMapping("/{deckId}/interaction/preview")
    public String preview(@PathVariable long deckId) {
        interactiveGameService.requireAdminDeck(deckId);
        return "redirect:/client/interactive/" + deckId + "?preview=true";
    }

    private String redirectToConfig(long deckId) {
        return "redirect:/admin/course/" + deckId + "/interaction";
    }
}
