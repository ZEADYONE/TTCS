package com.example.flc.game;

public record TemplateVariantDefinition(
        String key,
        String displayName,
        String templateKey) {

    public String getKey() {
        return key;
    }

    public String getDisplayName() {
        return displayName;
    }
}
