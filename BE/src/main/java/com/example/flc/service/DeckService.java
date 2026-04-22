package com.example.flc.service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.flc.domain.Deck;
import com.example.flc.domain.User;
import com.example.flc.domain.DTO.DeckProgress;
import com.example.flc.repository.DeckRepository;

import jakarta.transaction.Transactional;

@Service
public class DeckService {

    private final DeckRepository deckRepository;

    public DeckService(DeckRepository deckRepository) {
        this.deckRepository = deckRepository;
    }

    public List<Deck> getDeckLibrary(long id) {
        return this.deckRepository.findByUserId(id);
    }

    public Page<Deck> getDeckCommunity(String keyword, Pageable pageable) {
        String searchWord = (keyword != null && !keyword.isEmpty()) ? keyword : null;
        return this.deckRepository.findPublicActiveDeck(searchWord, pageable);
    }

    public Page<Deck> getDeckCourse(String keyword, Pageable pageable) {
        String searchWord = (keyword != null && !keyword.isEmpty()) ? keyword : null;
        return this.deckRepository.findDeckCourse(searchWord, pageable);
    }

    public void handelSaveDeck(Deck deck) {
        this.deckRepository.save(deck);
        return;
    }

    public Deck getDeckById(long id) {
        return this.deckRepository.findById(id).orElseThrow(() -> new RuntimeException(" Khong tim thay deck"));
    }

    public Page<DeckProgress> getLibraryDecks(String keyword, List<String> filters, Long userId, Pageable pageable) {
        // Tránh lỗi SQL khi List rỗng
        List<String> activeFilters = (filters == null || filters.isEmpty()) ? Arrays.asList("ALL") : filters;

        // Tương tự với keyword
        String searchKeyword = (keyword != null && !keyword.isEmpty()) ? keyword : null;

        Page<Object[]> rawResults = deckRepository.findAdvancedDecks(searchKeyword, activeFilters, userId, pageable);

        return rawResults.map(row -> new DeckProgress(
                ((Number) row[0]).longValue(),
                (String) row[1],
                (String) row[2],
                (String) row[3],
                (String) row[4],
                (String) row[5],
                ((Number) row[6]).longValue(),
                ((Number) row[7]).longValue(),
                ((Number) row[8]).longValue(),
                row[9] != null && (Boolean) row[9] // Cách ép kiểu an toàn cho Boolean
        ));
    }

    public Page<Deck> getAllDeckWithFilter(String keyword, List<Boolean> status, Pageable pageable) {
        String searchKeyword = (keyword != null && !keyword.isEmpty()) ? keyword : null;
        List<Boolean> statusFilter = (status != null && !status.isEmpty()) ? status : null;
        return this.deckRepository.findAllWithFilter(searchKeyword, statusFilter, pageable);
    }

    public void setDeckStatus(long id) {
        Deck deck = this.deckRepository.findById(id).orElseThrow(() -> new RuntimeException());
        if (deck.getStatus()) {
            deck.setStatus(false);
        } else {
            deck.setStatus(true);
        }
        handelSaveDeck(deck);
        return;
    }

    public void toggleFeatured(Long id) {
        Deck deck = deckRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Deck"));

        // Đảo ngược giá trị boolean
        deck.setIsFeatured(!deck.getIsFeatured());

        deckRepository.save(deck);
    }
}
