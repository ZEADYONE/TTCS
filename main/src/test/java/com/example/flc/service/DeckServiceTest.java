package com.example.flc.service;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import com.example.flc.repository.DeckRepository;

@ExtendWith(MockitoExtension.class)
class DeckServiceTest {

    @Mock
    private DeckRepository deckRepository;

    @Test
    void usesAllFilterWhenNoLibraryFilterIsSelected() {
        var pageable = PageRequest.of(0, 6);
        when(deckRepository.findAdvancedDecks(null, true, false, false, false, false, false, 7L, pageable))
                .thenReturn(Page.empty(pageable));

        new DeckService(deckRepository).getLibraryDecks("  ", null, 7L, pageable);

        verify(deckRepository).findAdvancedDecks(null, true, false, false, false, false, false, 7L, pageable);
    }

    @Test
    void convertsLibraryFiltersToScalarQueryParameters() {
        var pageable = PageRequest.of(1, 6);
        when(deckRepository.findAdvancedDecks("fruit", false, true, false, true, true, false, 9L, pageable))
                .thenReturn(Page.empty(pageable));

        new DeckService(deckRepository).getLibraryDecks(
                " fruit ",
                List.of("Public", "Mine", "Admin"),
                9L,
                pageable);

        verify(deckRepository).findAdvancedDecks(
                "fruit", false, true, false, true, true, false, 9L, pageable);
    }
}
