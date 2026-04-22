package com.example.flc.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.flc.domain.Card;
import com.example.flc.domain.Progress;
import com.example.flc.domain.User;

import jakarta.transaction.Transactional;

public interface ProgressRepository extends JpaRepository<Progress, Long> {
    Optional<Progress> findByUserAndCard(User user, Card card);

    @Modifying
    @Transactional
    @Query("DELETE FROM Progress p WHERE p.card.id = :cardId")
    void deleteByCardId(@Param("cardId") long cardId);
}
