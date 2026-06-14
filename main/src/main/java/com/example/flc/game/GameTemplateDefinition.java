package com.example.flc.game;

public record GameTemplateDefinition(
        String key,
        String displayName,
        String handlerKey,
        boolean requiresVariant) {

    public String getKey() {
        return key;
    }

    public String getDisplayName() {
        return displayName;
    }
}
