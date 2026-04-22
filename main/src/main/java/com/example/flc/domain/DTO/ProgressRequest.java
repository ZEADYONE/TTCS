package com.example.flc.domain.DTO;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ProgressRequest {
    private Long cardId;

    @JsonProperty("isCorrect")
    private boolean isCorrect;

    public Long getCardId() {
        return cardId;
    }

    public void setCardId(Long cardId) {
        this.cardId = cardId;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

}