package com.example.flc.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.flc.domain.Card;
import com.example.flc.domain.Deck;
import com.example.flc.repository.CardRepository;
import com.example.flc.repository.DeckRepository;

@Service
public class CardService {

    private final CardRepository cardRepository;
    private final DeckRepository deckreRepository;

    public CardService(CardRepository cardRepository, DeckRepository deckRepository) {
        this.cardRepository = cardRepository;
        this.deckreRepository = deckRepository;
    }

    public void handelSaveCard(Card card) {
        this.cardRepository.save(card);
        return;
    }

    public Page<Card> getAllCardByDeck(Deck deck, Pageable pageable) {
        return this.cardRepository.findByDeck(deck, pageable);
    }

    public Page<Card> getAllCardByDeckFilter(String keyword, Deck deck, Pageable pageable) {
        String searchKeyword = (keyword != null && !keyword.isEmpty()) ? keyword : null;
        return this.cardRepository.findByDeck(searchKeyword, deck, pageable);
    }

    public List<Card> getListCardByDeck(Deck deck) {
        return this.cardRepository.findByDeck(deck);
    }

    public Card getCard(long id) {
        return this.cardRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay the"));
    }

    public void deleteCard(long id) {
        this.cardRepository.deleteById(id);
        return;
    }
}
