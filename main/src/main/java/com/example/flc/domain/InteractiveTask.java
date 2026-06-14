package com.example.flc.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "interactive_task", uniqueConstraints = {
        @UniqueConstraint(name = "uk_interactive_task_order", columnNames = { "config_id", "order_index" })
})
public class InteractiveTask {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "config_id", nullable = false)
    private DeckInteractionConfig config;

    @Column(name = "order_index", nullable = false)
    private int orderIndex;

    @Column(name = "prompt_text", nullable = false, columnDefinition = "TEXT")
    private String promptText;

    @ManyToOne(optional = false)
    @JoinColumn(name = "target_card_id", nullable = false)
    private Card targetCard;

    @Column(name = "template_variant", length = 40)
    private String templateVariant;

    @Column(name = "success_text", columnDefinition = "TEXT")
    private String successText;

    @Column(name = "wrong_text", columnDefinition = "TEXT")
    private String wrongText;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public DeckInteractionConfig getConfig() {
        return config;
    }

    public void setConfig(DeckInteractionConfig config) {
        this.config = config;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public String getPromptText() {
        return promptText;
    }

    public void setPromptText(String promptText) {
        this.promptText = promptText;
    }

    public Card getTargetCard() {
        return targetCard;
    }

    public void setTargetCard(Card targetCard) {
        this.targetCard = targetCard;
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
