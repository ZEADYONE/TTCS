package com.example.flc.domain.DTO.interaction;

public class InteractionConfigRequest {
    private boolean enabled;
    private String templateKey;
    private String themeKey;
    private String characterName;
    private String characterEmoji;
    private String introText;
    private String completionText;

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public String getTemplateKey() {
        return templateKey;
    }

    public void setTemplateKey(String templateKey) {
        this.templateKey = templateKey;
    }

    public String getThemeKey() {
        return themeKey;
    }

    public void setThemeKey(String themeKey) {
        this.themeKey = themeKey;
    }

    public String getCharacterName() {
        return characterName;
    }

    public void setCharacterName(String characterName) {
        this.characterName = characterName;
    }

    public String getCharacterEmoji() {
        return characterEmoji;
    }

    public void setCharacterEmoji(String characterEmoji) {
        this.characterEmoji = characterEmoji;
    }

    public String getIntroText() {
        return introText;
    }

    public void setIntroText(String introText) {
        this.introText = introText;
    }

    public String getCompletionText() {
        return completionText;
    }

    public void setCompletionText(String completionText) {
        this.completionText = completionText;
    }

}
