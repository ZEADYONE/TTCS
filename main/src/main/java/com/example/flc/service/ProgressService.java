package com.example.flc.service;

import java.time.LocalDateTime;
import java.util.List;
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

    // SM2
    public Progress SM2(Progress progress) {

        int qualityScore = progress.getIsCorrect() ? 4 : 1;
        int repetitions = progress.getRepetitions();
        int interval = progress.getIntervalDays();
        float easeFactor = progress.getEaseFactor();

        if (qualityScore >= 3) {
            // Trả lời đúng hoặc tạm ổn
            if (repetitions == 0) {
                interval = 1;
            } else if (repetitions == 1) {
                interval = 6;
            } else {
                interval = Math.round(interval * easeFactor);
            }
            repetitions++;
        } else {
            // Trả lời sai (quên bài)
            repetitions = 0;
            interval = 1;
        }

        // 3. Cập nhật Hệ số dễ (Ease Factor)
        easeFactor = (float) (easeFactor + (0.1 - (5 - qualityScore) * (0.08 + (5 - qualityScore) * 0.02)));
        if (easeFactor < 1.3f) {
            easeFactor = 1.3f; // Đảm bảo EF không bao giờ rớt xuống dưới 1.3
        }

        progress.setRepetitions(repetitions);
        progress.setIntervalDays(interval);
        progress.setEaseFactor(easeFactor);

        // Cộng thêm số ngày vào thời điểm hiện tại để ra ngày ôn tập tiếp theo
        progress.setNextReviewDate(LocalDateTime.now().plusDays(interval));

        return progress;
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

        progressRepository.save(SM2(progress));
    }

    // Review card
    public List<Card> getReviewCard(String email) {
        User user = userRepository.findByEmail(email);
        return progressRepository.findReviewCard(user.getId(), LocalDateTime.now());
    }

    public void deleteCardById(long id) {
        this.progressRepository.deleteByCardId(id);
        return;
    }

}
