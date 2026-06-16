package com.example.flc.controller.client;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.security.Principal;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.ui.ConcurrentModel;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import com.example.flc.service.InteractiveGameException;
import com.example.flc.service.InteractiveGameService;
import com.example.flc.domain.DTO.interaction.InteractiveGameResponse;

class InteractiveGamePageControllerTest {

    @Test
    void normalGameReturnsToClientDeck() {
        InteractiveGameService service = mock(InteractiveGameService.class);
        Principal principal = () -> "user@example.com";
        when(service.getGameResponse(16L, false, principal.getName()))
                .thenReturn(gameResponse(16L));

        ConcurrentModel model = new ConcurrentModel();
        String view = new InteractiveGamePageController(service).showGame(
                16L,
                false,
                principal,
                model,
                new RedirectAttributesModelMap());

        assertEquals("client/deck/interactive-game", view);
        assertEquals("/client/deck/16", model.getAttribute("backUrl"));
    }

    @Test
    void previewReturnsToAdminInteractionConfig() {
        InteractiveGameService service = mock(InteractiveGameService.class);
        Principal principal = () -> "admin@example.com";
        when(service.getGameResponse(16L, true, principal.getName()))
                .thenReturn(gameResponse(16L));

        ConcurrentModel model = new ConcurrentModel();
        String view = new InteractiveGamePageController(service).showGame(
                16L,
                true,
                principal,
                model,
                new RedirectAttributesModelMap());

        assertEquals("client/deck/interactive-game", view);
        assertEquals("/admin/course/16/interaction", model.getAttribute("backUrl"));
    }

    @Test
    void invalidPreviewReturnsToAdminConfigWithMessage() {
        InteractiveGameService service = mock(InteractiveGameService.class);
        Principal principal = () -> "admin@example.com";
        String message = "Hãy thêm ít nhất 1 round trước khi Preview hoặc bật game.";
        when(service.getGameResponse(16L, true, principal.getName()))
                .thenThrow(new InteractiveGameException(message));

        RedirectAttributesModelMap redirectAttributes = new RedirectAttributesModelMap();
        String view = new InteractiveGamePageController(service).showGame(
                16L,
                true,
                principal,
                new ConcurrentModel(),
                redirectAttributes);

        assertEquals("redirect:/admin/course/16/interaction", view);
        assertEquals(message, redirectAttributes.getFlashAttributes().get("errorMessage"));
    }

    private InteractiveGameResponse gameResponse(long deckId) {
        return new InteractiveGameResponse(
                deckId,
                "Fruits",
                "FEED",
                "feed",
                "GARDEN_FEAST",
                "theme--garden-feast",
                true,
                "Bunny",
                "🐰",
                "Bắt đầu",
                "Hoàn thành",
                List.of(),
                List.of());
    }
}
