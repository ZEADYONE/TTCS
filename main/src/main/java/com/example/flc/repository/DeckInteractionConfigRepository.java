package com.example.flc.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.flc.domain.DeckInteractionConfig;

public interface DeckInteractionConfigRepository extends JpaRepository<DeckInteractionConfig, Long> {
    Optional<DeckInteractionConfig> findByDeckId(Long deckId);

    Optional<DeckInteractionConfig> findByDeckIdAndEnabledTrue(Long deckId);

    List<DeckInteractionConfig> findByDeckIdIn(Collection<Long> deckIds);
}
