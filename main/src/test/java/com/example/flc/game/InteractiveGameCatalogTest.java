package com.example.flc.game;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class InteractiveGameCatalogTest {

    private final InteractiveGameCatalog catalog = new InteractiveGameCatalog();

    @Test
    void actionTemplateRequiresVariantAndSupportsItsThemeVariants() {
        GameTemplateDefinition action = catalog.findTemplate("ACTION").orElseThrow();
        ThemePackDefinition playground = catalog.findTheme("PLAYGROUND_ADVENTURE").orElseThrow();

        assertTrue(action.requiresVariant());
        assertEquals("ACTION", playground.templateKey());
        assertTrue(playground.supportsVariant("JUMP"));
        assertTrue(playground.supportsVariant("SWIM"));
        assertTrue(playground.supportsVariant("RUN"));
    }

    @Test
    void feedTemplateDoesNotExposeActionVariants() {
        GameTemplateDefinition feed = catalog.findTemplate("FEED").orElseThrow();

        assertFalse(feed.requiresVariant());
        assertTrue(catalog.getVariantsForTemplate("FEED").isEmpty());
    }
}
