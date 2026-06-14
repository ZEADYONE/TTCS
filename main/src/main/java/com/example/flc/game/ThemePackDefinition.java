package com.example.flc.game;

import java.util.Set;

public record ThemePackDefinition(
        String key,
        String displayName,
        String templateKey,
        String sceneClass,
        String description,
        Set<String> supportedVariants) {

    public boolean supportsVariant(String variantKey) {
        return variantKey != null && supportedVariants.contains(variantKey);
    }

    public String getKey() {
        return key;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getTemplateKey() {
        return templateKey;
    }

    public String getDescription() {
        return description;
    }
}
