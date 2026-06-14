package com.example.flc.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.example.flc.domain.Card;
import com.example.flc.domain.Deck;
import com.example.flc.domain.DeckInteractionConfig;
import com.example.flc.domain.InteractiveTask;
import com.example.flc.domain.Role;
import com.example.flc.domain.User;
import com.example.flc.domain.DTO.interaction.InteractionConfigRequest;
import com.example.flc.domain.DTO.interaction.InteractiveGameResponse;
import com.example.flc.domain.DTO.interaction.InteractiveTaskRequest;
import com.example.flc.game.InteractiveGameCatalog;
import com.example.flc.repository.CardRepository;
import com.example.flc.repository.DeckInteractionConfigRepository;
import com.example.flc.repository.DeckRepository;
import com.example.flc.repository.InteractiveTaskRepository;
import com.example.flc.repository.UserRepository;

class InteractiveGameServiceTest {

    private DeckRepository deckRepository;
    private CardRepository cardRepository;
    private DeckInteractionConfigRepository configRepository;
    private InteractiveTaskRepository taskRepository;
    private InteractiveGameService service;

    @BeforeEach
    void setUp() {
        deckRepository = mock(DeckRepository.class);
        cardRepository = mock(CardRepository.class);
        configRepository = mock(DeckInteractionConfigRepository.class);
        taskRepository = mock(InteractiveTaskRepository.class);
        UserRepository userRepository = mock(UserRepository.class);
        service = new InteractiveGameService(
                deckRepository,
                cardRepository,
                userRepository,
                configRepository,
                taskRepository,
                new InteractiveGameCatalog());
    }

    @Test
    void rejectsDeckCreatedByNormalUser() {
        Deck deck = deckWithRole(10L, "USER");
        when(deckRepository.findById(10L)).thenReturn(Optional.of(deck));

        InteractiveGameException exception = assertThrows(
                InteractiveGameException.class,
                () -> service.requireAdminDeck(10L));

        assertEquals("Chỉ deck do ADMIN tạo mới được cấu hình tương tác.", exception.getMessage());
    }

    @Test
    void cannotEnableConfigWithoutTasks() {
        Deck deck = deckWithRole(5L, "ADMIN");
        DeckInteractionConfig config = config(7L, deck, "FEED", "GARDEN_FEAST", false);

        when(deckRepository.findById(5L)).thenReturn(Optional.of(deck));
        when(configRepository.findByDeckId(5L)).thenReturn(Optional.of(config));
        when(taskRepository.findByConfigIdOrderByOrderIndexAsc(7L)).thenReturn(List.of());

        InteractionConfigRequest request = new InteractionConfigRequest();
        request.setEnabled(true);
        request.setTemplateKey("FEED");
        request.setThemeKey("GARDEN_FEAST");

        InteractiveGameException exception = assertThrows(
                InteractiveGameException.class,
                () -> service.saveConfig(5L, request));

        assertEquals(
                "Hãy thêm ít nhất 1 round trước khi Preview hoặc bật game.",
                exception.getMessage());
    }

    @Test
    void rejectsThemeFromAnotherTemplate() {
        Deck deck = deckWithRole(5L, "ADMIN");
        DeckInteractionConfig config = config(7L, deck, "FEED", "GARDEN_FEAST", false);

        when(deckRepository.findById(5L)).thenReturn(Optional.of(deck));
        when(configRepository.findByDeckId(5L)).thenReturn(Optional.of(config));

        InteractionConfigRequest request = new InteractionConfigRequest();
        request.setTemplateKey("FEED");
        request.setThemeKey("PLAYGROUND_ADVENTURE");

        InteractiveGameException exception = assertThrows(
                InteractiveGameException.class,
                () -> service.saveConfig(5L, request));

        assertEquals("Theme không tương thích với template đã chọn.", exception.getMessage());
    }

    @Test
    void rejectsTargetCardFromAnotherDeck() {
        Deck adminDeck = deckWithRole(5L, "ADMIN");
        Deck otherDeck = deckWithRole(6L, "ADMIN");
        Card card = card(20L, otherDeck, "Apple");
        DeckInteractionConfig config = config(7L, adminDeck, "FEED", "GARDEN_FEAST", false);

        when(deckRepository.findById(5L)).thenReturn(Optional.of(adminDeck));
        when(configRepository.findByDeckId(5L)).thenReturn(Optional.of(config));
        when(taskRepository.findByConfigIdOrderByOrderIndexAsc(7L)).thenReturn(List.of());
        when(cardRepository.findById(20L)).thenReturn(Optional.of(card));

        InteractiveTaskRequest request = taskRequest(20L);

        InteractiveGameException exception = assertThrows(
                InteractiveGameException.class,
                () -> service.saveTask(5L, request));

        assertEquals("Card không thuộc deck đang cấu hình.", exception.getMessage());
    }

    @Test
    void actionRoundRequiresRegisteredVariant() {
        Deck deck = deckWithRole(5L, "ADMIN");
        Card target = card(20L, deck, "Jump");
        DeckInteractionConfig config = config(
                7L, deck, "ACTION", "PLAYGROUND_ADVENTURE", false);

        when(deckRepository.findById(5L)).thenReturn(Optional.of(deck));
        when(configRepository.findByDeckId(5L)).thenReturn(Optional.of(config));
        when(taskRepository.findByConfigIdOrderByOrderIndexAsc(7L)).thenReturn(List.of());
        when(cardRepository.findById(20L)).thenReturn(Optional.of(target));

        InteractiveTaskRequest request = taskRequest(20L);

        InteractiveGameException exception = assertThrows(
                InteractiveGameException.class,
                () -> service.saveTask(5L, request));

        assertEquals("Hãy chọn hành động hợp lệ cho round ACTION.", exception.getMessage());
    }

    @Test
    void actionRoundSavesRegisteredVariant() {
        Deck deck = deckWithRole(5L, "ADMIN");
        Card target = card(20L, deck, "Jump");
        DeckInteractionConfig config = config(
                7L, deck, "ACTION", "PLAYGROUND_ADVENTURE", false);

        when(deckRepository.findById(5L)).thenReturn(Optional.of(deck));
        when(configRepository.findByDeckId(5L)).thenReturn(Optional.of(config));
        when(taskRepository.findByConfigIdOrderByOrderIndexAsc(7L)).thenReturn(List.of());
        when(cardRepository.findById(20L)).thenReturn(Optional.of(target));
        when(taskRepository.save(any(InteractiveTask.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        InteractiveTaskRequest request = taskRequest(20L);
        request.setTemplateVariant("jump");

        InteractiveTask saved = service.saveTask(5L, request);

        assertEquals("JUMP", saved.getTemplateVariant());
        assertEquals(20L, saved.getTargetCard().getId());
    }

    @Test
    void feedRoundDiscardsVariant() {
        Deck deck = deckWithRole(5L, "ADMIN");
        Card target = card(20L, deck, "Apple");
        DeckInteractionConfig config = config(7L, deck, "FEED", "GARDEN_FEAST", false);

        when(deckRepository.findById(5L)).thenReturn(Optional.of(deck));
        when(configRepository.findByDeckId(5L)).thenReturn(Optional.of(config));
        when(taskRepository.findByConfigIdOrderByOrderIndexAsc(7L)).thenReturn(List.of());
        when(cardRepository.findById(20L)).thenReturn(Optional.of(target));
        when(taskRepository.save(any(InteractiveTask.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        InteractiveTaskRequest request = taskRequest(20L);
        request.setTemplateVariant("JUMP");

        InteractiveTask saved = service.saveTask(5L, request);

        assertNull(saved.getTemplateVariant());
    }

    @Test
    void responseContainsTemplateThemeAndThreeOptions() {
        Deck deck = deckWithRole(5L, "ADMIN");
        Card target = card(20L, deck, "Apple");
        List<Card> cards = List.of(
                target,
                card(21L, deck, "Banana"),
                card(22L, deck, "Orange"),
                card(23L, deck, "Mango"));
        DeckInteractionConfig config = config(7L, deck, "FEED", "GARDEN_FEAST", true);
        InteractiveTask task = new InteractiveTask();
        task.setId(30L);
        task.setConfig(config);
        task.setOrderIndex(1);
        task.setPromptText("Chọn Apple");
        task.setTargetCard(target);

        when(deckRepository.findById(5L)).thenReturn(Optional.of(deck));
        when(configRepository.findByDeckId(5L)).thenReturn(Optional.of(config));
        when(taskRepository.findByConfigIdOrderByOrderIndexAsc(7L)).thenReturn(List.of(task));
        when(cardRepository.findByDeck(deck)).thenReturn(cards);

        InteractiveGameResponse response = service.getGameResponse(5L, false, null);
        List<Long> optionIds = response.tasks().get(0).optionCardIds();

        assertEquals("FEED", response.templateKey());
        assertEquals("feed", response.templateHandler());
        assertEquals("GARDEN_FEAST", response.themeKey());
        assertEquals(3, optionIds.size());
        assertEquals(3, optionIds.stream().distinct().count());
        assertTrue(optionIds.contains(20L));
        assertTrue(optionIds.stream().allMatch(id -> List.of(20L, 21L, 22L, 23L).contains(id)));
    }

    private InteractiveTaskRequest taskRequest(long targetCardId) {
        InteractiveTaskRequest request = new InteractiveTaskRequest();
        request.setPromptText("Chọn card đúng");
        request.setTargetCardId(targetCardId);
        return request;
    }

    private DeckInteractionConfig config(
            long configId,
            Deck deck,
            String templateKey,
            String themeKey,
            boolean enabled) {
        DeckInteractionConfig config = new DeckInteractionConfig();
        config.setId(configId);
        config.setDeck(deck);
        config.setTemplateKey(templateKey);
        config.setThemeKey(themeKey);
        config.setEnabled(enabled);
        return config;
    }

    private Card card(long cardId, Deck deck, String word) {
        Card card = new Card();
        card.setId(cardId);
        card.setDeck(deck);
        card.setWord(word);
        return card;
    }

    private Deck deckWithRole(long deckId, String roleName) {
        Role role = new Role();
        role.setName(roleName);
        User user = new User();
        user.setRole(role);
        Deck deck = new Deck();
        deck.setId(deckId);
        deck.setUser(user);
        return deck;
    }
}
