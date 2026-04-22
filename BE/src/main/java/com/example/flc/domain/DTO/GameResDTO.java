package com.example.flc.domain.DTO;

public class GameResDTO {
    private long correct;
    private long wrong;
    private long userId;
    private long deckId;

    public GameResDTO(long correct, long wrong, long userId, long deckId) {
        this.correct = correct;
        this.wrong = wrong;
        this.userId = userId;
        this.deckId = deckId;
    }

    public long getCorrect() {
        return correct;
    }

    public void setCorrect(long correct) {
        this.correct = correct;
    }

    public long getWrong() {
        return wrong;
    }

    public void setWrong(long wrong) {
        this.wrong = wrong;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getDeckId() {
        return deckId;
    }

    public void setDeckId(long deckId) {
        this.deckId = deckId;
    }

}
