package com.example.flc.domain.DTO.interaction;

public class InteractiveTaskRequest {
    private Long taskId;
    private String promptText;
    private Long targetCardId;
    private String templateVariant;
    private String successText;
    private String wrongText;

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getPromptText() {
        return promptText;
    }

    public void setPromptText(String promptText) {
        this.promptText = promptText;
    }

    public Long getTargetCardId() {
        return targetCardId;
    }

    public void setTargetCardId(Long targetCardId) {
        this.targetCardId = targetCardId;
    }

    public String getTemplateVariant() {
        return templateVariant;
    }

    public void setTemplateVariant(String templateVariant) {
        this.templateVariant = templateVariant;
    }

    public String getSuccessText() {
        return successText;
    }

    public void setSuccessText(String successText) {
        this.successText = successText;
    }

    public String getWrongText() {
        return wrongText;
    }

    public void setWrongText(String wrongText) {
        this.wrongText = wrongText;
    }
}
