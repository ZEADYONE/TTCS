package com.example.flc.domain.DTO.interaction;

import java.util.List;

public record InteractiveGameResponse(
        long deckId,
        String deckTitle,
        String templateKey,
        String templateHandler,
        String themeKey,
        String themeClass,
        boolean enabled,
        String characterName,
        String characterEmoji,
        String introText,
        String completionText,
        List<CardItem> cards,
        List<TaskItem> tasks) {

    public record CardItem(
            long id,
            String word,
            String mean,
            String image) {
    }

    public record TaskItem(
            long id,
            int orderIndex,
            String promptText,
            Long targetCardId,
            List<Long> optionCardIds,
            String templateVariant,
            String successText,
            String wrongText) {
    }
}
