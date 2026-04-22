package com.example.flc.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class GameRes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private long correct;
    private long wrong;
    private String playAt;

    @ManyToOne()
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne()
    @JoinColumn(name = "deck_id")
    private Deck deck;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
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

    public String getPlayAt() {
        return playAt;
    }

    public void setPlayAt(String playAt) {
        this.playAt = playAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Deck getDeck() {
        return deck;
    }

    public void setDeck(Deck deck) {
        this.deck = deck;
    }

    @Override
    public String toString() {
        return "GameRes [id=" + id + ", correct=" + correct + ", wrong=" + wrong + ", playAt=" + playAt + ", user="
                + user + ", deck=" + deck + "]";
    }

}
