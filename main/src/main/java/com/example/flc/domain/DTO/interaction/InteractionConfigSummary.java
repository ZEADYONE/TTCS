package com.example.flc.domain.DTO.interaction;

public class InteractionConfigSummary {
    private final boolean enabled;
    private final String templateKey;

    public InteractionConfigSummary(boolean enabled, String templateKey) {
        this.enabled = enabled;
        this.templateKey = templateKey;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public String getTemplateKey() {
        return templateKey;
    }
}
