package com.example.flc.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.flc.domain.Card;
import com.example.flc.domain.Deck;

import java.util.List;

@Repository
public interface CardRepository extends JpaRepository<Card, Long> {

    @Query("""
                SELECT c FROM Card c
                WHERE c.deck = :deck
                AND (
                    :keyword IS NULL OR
                    LOWER(c.word) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
                    LOWER(c.mean) LIKE LOWER(CONCAT('%', :keyword, '%'))
                )
            """)
    Page<Card> findByDeck(@Param("keyword") String keyword,
            @Param("deck") Deck deck,
            Pageable pageable);

    public List<Card> findByDeck(Deck deck);

    public Page<Card> findByDeck(Deck deck, Pageable pageable);
}
