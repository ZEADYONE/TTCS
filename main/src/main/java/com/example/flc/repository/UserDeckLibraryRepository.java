package com.example.flc.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.flc.domain.UserDeckLibrary;

@Repository
public interface UserDeckLibraryRepository extends JpaRepository<UserDeckLibrary, Long> {
    boolean existsByUserIdAndDeckId(Long userId, Long deckId);
    void deleteByUserIdAndDeckId(Long userId, Long deckId);
}
