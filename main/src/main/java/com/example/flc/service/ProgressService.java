package com.example.flc.service;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.flc.domain.Card;
import com.example.flc.domain.Progress;
import com.example.flc.domain.User;
import com.example.flc.repository.CardRepository;
import com.example.flc.repository.ProgressRepository;
import com.example.flc.repository.UserRepository;

@Service
public class ProgressService {

    final private UserRepository userRepository;
    final private CardRepository cardRepository;
    final private ProgressRepository progressRepository;

    public ProgressService(UserRepository userRepository, CardRepository cardRepository,
            ProgressRepository progressRepository) {
        this.userRepository = userRepository;
        this.cardRepository = cardRepository;
        this.progressRepository = progressRepository;
    }

    public void save(String email, Long cardId, boolean isCorrect) {

        User user = userRepository.findByEmail(email);
        Card card = cardRepository.findById(cardId).orElseThrow();

        Optional<Progress> existing = progressRepository.findByUserAndCard(user, card);

        Progress progress;

        if (existing.isPresent()) {
            progress = existing.get();
        } else {
            progress = new Progress();
            progress.setUser(user);
            progress.setCard(card);
        }

        progress.setIsCorrect(isCorrect);
        progress.setUpdateAt(LocalDateTime.now());

        progressRepository.save(progress);
    }

    public void deleteCardById(long id) {
        this.progressRepository.deleteByCardId(id);
        return;
    }
}
