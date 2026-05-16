package com.example.flc.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.flc.domain.Deck;
import com.example.flc.domain.User;
import com.example.flc.domain.UserDeckLibrary;
import com.example.flc.repository.UserDeckLibraryRepository;

@Service
public class UserDeckLibraryService {

    private final UserDeckLibraryRepository userDeckLibraryRepository;

    public UserDeckLibraryService(UserDeckLibraryRepository userDeckLibraryRepository) {
        this.userDeckLibraryRepository = userDeckLibraryRepository;
    }

    @Transactional
    public void addDeckToLibraryIfNotExists(User user, Deck deck) {
        // Only add to library if it's a public deck not owned by the user
        if (user.getId() != deck.getUser().getId() && deck.getStatus()) {
            if (!userDeckLibraryRepository.existsByUserIdAndDeckId(user.getId(), deck.getId())) {
                UserDeckLibrary udl = new UserDeckLibrary();
                udl.setUser(user);
                udl.setDeck(deck);
                udl.setAddedAt(LocalDateTime.now());
                userDeckLibraryRepository.save(udl);
            }
        }
    }

    // @Transactional
    // public void addDeckToLibraryIfNotExists(User user, Deck deck) {
    // // Only add to library if it's a public deck not owned by the user
    // if (user.getId() != deck.getUser().getId() &&
    // "Public".equals(deck.getScope()) && deck.getStatus()) {
    // if (!userDeckLibraryRepository.existsByUserIdAndDeckId(user.getId(),
    // deck.getId())) {
    // UserDeckLibrary udl = new UserDeckLibrary();
    // udl.setUser(user);
    // udl.setDeck(deck);
    // udl.setAddedAt(LocalDateTime.now());
    // userDeckLibraryRepository.save(udl);
    // }
    // }
    // }

    @Transactional
    public void removeDeckFromLibrary(Long userId, Long deckId) {
        userDeckLibraryRepository.deleteByUserIdAndDeckId(userId, deckId);
    }
}
