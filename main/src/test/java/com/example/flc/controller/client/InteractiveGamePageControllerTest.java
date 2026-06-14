package com.example.flc.controller.client;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.security.Principal;

import org.junit.jupiter.api.Test;
import org.springframework.ui.ConcurrentModel;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import com.example.flc.service.InteractiveGameException;
import com.example.flc.service.InteractiveGameService;

class InteractiveGamePageControllerTest {

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
}
