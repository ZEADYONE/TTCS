package com.example.flc.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.flc.domain.Card;
import com.example.flc.domain.Deck;
import com.example.flc.domain.DeckInteractionConfig;
import com.example.flc.domain.InteractiveTask;
import com.example.flc.domain.User;
import com.example.flc.domain.DTO.interaction.InteractionConfigRequest;
import com.example.flc.domain.DTO.interaction.InteractionConfigSummary;
import com.example.flc.domain.DTO.interaction.InteractiveGameResponse;
import com.example.flc.domain.DTO.interaction.InteractiveTaskRequest;
import com.example.flc.game.GameTemplateDefinition;
import com.example.flc.game.InteractiveGameCatalog;
import com.example.flc.game.TemplateVariantDefinition;
import com.example.flc.game.ThemePackDefinition;
import com.example.flc.repository.CardRepository;
import com.example.flc.repository.DeckInteractionConfigRepository;
import com.example.flc.repository.DeckRepository;
import com.example.flc.repository.InteractiveTaskRepository;
import com.example.flc.repository.UserRepository;

@Service
public class InteractiveGameService {

    public static final String DEFAULT_CHARACTER_NAME = "Bunny";
    public static final String DEFAULT_CHARACTER_EMOJI = "🐰";

    private final DeckRepository deckRepository;
    private final CardRepository cardRepository;
    private final UserRepository userRepository;
    private final DeckInteractionConfigRepository configRepository;
    private final InteractiveTaskRepository taskRepository;
    private final InteractiveGameCatalog gameCatalog;

    public InteractiveGameService(
            DeckRepository deckRepository,
            CardRepository cardRepository,
            UserRepository userRepository,
            DeckInteractionConfigRepository configRepository,
            InteractiveTaskRepository taskRepository,
            InteractiveGameCatalog gameCatalog) {
        this.deckRepository = deckRepository;
        this.cardRepository = cardRepository;
        this.userRepository = userRepository;
        this.configRepository = configRepository;
        this.taskRepository = taskRepository;
        this.gameCatalog = gameCatalog;
    }

    @Transactional(readOnly = true)
    public Deck requireAdminDeck(long deckId) {
        Deck deck = deckRepository.findById(deckId)
                .orElseThrow(() -> new InteractiveGameException("Không tìm thấy deck."));

        if (deck.getUser() == null
                || deck.getUser().getRole() == null
                || !"ADMIN".equals(deck.getUser().getRole().getName())) {
            throw new InteractiveGameException("Chỉ deck do ADMIN tạo mới được cấu hình tương tác.");
        }
        return deck;
    }

    @Transactional
    public DeckInteractionConfig getOrCreateAdminConfig(long deckId) {
        Deck deck = requireAdminDeck(deckId);
        return configRepository.findByDeckId(deckId).orElseGet(() -> {
            DeckInteractionConfig config = new DeckInteractionConfig();
            config.setDeck(deck);
            config.setEnabled(false);
            config.setTemplateKey(InteractiveGameCatalog.FEED);
            config.setThemeKey("GARDEN_FEAST");
            config.setCharacterName(DEFAULT_CHARACTER_NAME);
            config.setCharacterEmoji(DEFAULT_CHARACTER_EMOJI);
            config.setIntroText("Cùng Bunny bắt đầu bài chơi nhé!");
            config.setCompletionText("Tuyệt vời! Con đã hoàn thành bài chơi!");
            return configRepository.save(config);
        });
    }

    @Transactional
    public DeckInteractionConfig saveConfig(long deckId, InteractionConfigRequest request) {
        DeckInteractionConfig config = getOrCreateAdminConfig(deckId);
        GameTemplateDefinition template = requireTemplate(request.getTemplateKey());
        ThemePackDefinition theme = requireCompatibleTheme(template.key(), request.getThemeKey());

        List<InteractiveTask> tasks = taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId());
        config.setTemplateKey(template.key());
        config.setThemeKey(theme.key());
        config.setCharacterName(defaultIfBlank(request.getCharacterName(), DEFAULT_CHARACTER_NAME));
        config.setCharacterEmoji(defaultIfBlank(request.getCharacterEmoji(), DEFAULT_CHARACTER_EMOJI));
        config.setIntroText(trimToNull(request.getIntroText()));
        config.setCompletionText(defaultIfBlank(
                request.getCompletionText(), "Tuyệt vời! Con đã hoàn thành bài chơi!"));
        config.setEnabled(request.isEnabled());

        if (config.isEnabled()) {
            validateConfig(config, tasks);
        }
        return configRepository.save(config);
    }

    @Transactional
    public InteractiveTask saveTask(long deckId, InteractiveTaskRequest request) {
        Deck deck = requireAdminDeck(deckId);
        DeckInteractionConfig config = configRepository.findByDeckId(deckId)
                .orElseThrow(() -> new InteractiveGameException("Hãy lưu cấu hình chung trước."));
        GameTemplateDefinition template = requireTemplate(config.getTemplateKey());
        ThemePackDefinition theme = requireCompatibleTheme(template.key(), config.getThemeKey());

        InteractiveTask task;
        if (request.getTaskId() == null) {
            task = new InteractiveTask();
            task.setConfig(config);
            int nextOrder = taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId()).stream()
                    .mapToInt(InteractiveTask::getOrderIndex)
                    .max()
                    .orElse(0) + 1;
            task.setOrderIndex(nextOrder);
        } else {
            task = taskRepository.findByIdAndConfigId(request.getTaskId(), config.getId())
                    .orElseThrow(() -> new InteractiveGameException("Round không thuộc deck này."));
        }

        task.setPromptText(requireText(request.getPromptText(), "Nội dung nhiệm vụ không được để trống."));
        task.setTargetCard(requireCardInDeck(deck, request.getTargetCardId()));
        task.setTemplateVariant(resolveVariant(template, theme, request.getTemplateVariant()));
        task.setSuccessText(trimToNull(request.getSuccessText()));
        task.setWrongText(trimToNull(request.getWrongText()));

        InteractiveTask savedTask = taskRepository.save(task);
        if (config.isEnabled()) {
            validateConfig(config, taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId()));
        }
        return savedTask;
    }

    @Transactional
    public void deleteTask(long deckId, long taskId) {
        DeckInteractionConfig config = getExistingConfigForAdminDeck(deckId);
        InteractiveTask task = taskRepository.findByIdAndConfigId(taskId, config.getId())
                .orElseThrow(() -> new InteractiveGameException("Round không thuộc deck này."));
        List<InteractiveTask> tasks = taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId());
        if (config.isEnabled() && tasks.size() == 1) {
            throw new InteractiveGameException("Không thể xóa round cuối khi interaction đang bật.");
        }

        taskRepository.delete(task);
        taskRepository.flush();

        List<InteractiveTask> remainingTasks = tasks.stream()
                .filter(item -> !item.getId().equals(taskId))
                .toList();
        resequenceTasks(remainingTasks);
        if (config.isEnabled()) {
            validateConfig(config, remainingTasks);
        }
    }

    @Transactional
    public void moveTask(long deckId, long taskId, String direction) {
        DeckInteractionConfig config = getExistingConfigForAdminDeck(deckId);
        List<InteractiveTask> tasks = taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId());
        int currentIndex = -1;
        for (int i = 0; i < tasks.size(); i++) {
            if (tasks.get(i).getId().equals(taskId)) {
                currentIndex = i;
                break;
            }
        }
        if (currentIndex < 0) {
            throw new InteractiveGameException("Round không thuộc deck này.");
        }

        int targetIndex = "up".equalsIgnoreCase(direction) ? currentIndex - 1 : currentIndex + 1;
        if (targetIndex < 0 || targetIndex >= tasks.size()) {
            return;
        }

        InteractiveTask current = tasks.get(currentIndex);
        InteractiveTask target = tasks.get(targetIndex);
        int currentOrder = current.getOrderIndex();
        int targetOrder = target.getOrderIndex();

        current.setOrderIndex(-1);
        taskRepository.saveAndFlush(current);
        target.setOrderIndex(currentOrder);
        taskRepository.saveAndFlush(target);
        current.setOrderIndex(targetOrder);
        taskRepository.save(current);
    }

    @Transactional(readOnly = true)
    public boolean isInteractionAvailable(long deckId) {
        try {
            DeckInteractionConfig config = configRepository.findByDeckIdAndEnabledTrue(deckId).orElse(null);
            if (config == null) {
                return false;
            }
            requireAdminDeck(deckId);
            validateConfig(config, taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId()));
            return true;
        } catch (InteractiveGameException exception) {
            return false;
        }
    }

    @Transactional(readOnly = true)
    public InteractiveGameResponse getGameResponse(long deckId, boolean preview, String currentUserEmail) {
        Deck deck = requireAdminDeck(deckId);
        DeckInteractionConfig config = configRepository.findByDeckId(deckId)
                .orElseThrow(() -> new InteractiveGameException("Deck chưa có cấu hình tương tác."));

        if (preview) {
            if (!isAdminUser(currentUserEmail)) {
                throw new InteractiveGameException("Chỉ ADMIN được xem preview.");
            }
        } else if (!config.isEnabled()) {
            throw new InteractiveGameException("Chế độ chơi tương tác chưa được bật.");
        }

        List<InteractiveTask> tasks = taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId());
        validateConfig(config, tasks);
        List<Card> cards = cardRepository.findByDeck(deck);
        GameTemplateDefinition template = requireTemplate(config.getTemplateKey());
        ThemePackDefinition theme = requireCompatibleTheme(template.key(), config.getThemeKey());

        return new InteractiveGameResponse(
                deck.getId(),
                deck.getTitle(),
                template.key(),
                template.handlerKey(),
                theme.key(),
                theme.sceneClass(),
                config.isEnabled(),
                defaultIfBlank(config.getCharacterName(), DEFAULT_CHARACTER_NAME),
                defaultIfBlank(config.getCharacterEmoji(), DEFAULT_CHARACTER_EMOJI),
                config.getIntroText(),
                defaultIfBlank(config.getCompletionText(), "Tuyệt vời! Con đã hoàn thành bài chơi!"),
                cards.stream().map(card -> new InteractiveGameResponse.CardItem(
                        card.getId(),
                        card.getWord(),
                        card.getMean(),
                        card.getImage())).toList(),
                tasks.stream().map(task -> new InteractiveGameResponse.TaskItem(
                        task.getId(),
                        task.getOrderIndex(),
                        task.getPromptText(),
                        task.getTargetCard().getId(),
                        buildOptionCardIds(cards, task.getTargetCard()),
                        task.getTemplateVariant(),
                        task.getSuccessText(),
                        task.getWrongText())).toList());
    }

    @Transactional(readOnly = true)
    public Map<Long, InteractionConfigSummary> getConfigSummaries(Collection<Deck> decks) {
        List<Long> deckIds = decks.stream().map(Deck::getId).toList();
        if (deckIds.isEmpty()) {
            return Map.of();
        }

        return configRepository.findByDeckIdIn(deckIds).stream()
                .collect(Collectors.toMap(
                        config -> config.getDeck().getId(),
                        config -> new InteractionConfigSummary(
                                config.isEnabled(),
                                config.getTemplateKey()),
                        (first, second) -> first,
                        LinkedHashMap::new));
    }

    @Transactional(readOnly = true)
    public List<Card> getCardsForAdmin(long deckId) {
        return cardRepository.findByDeck(requireAdminDeck(deckId));
    }

    @Transactional(readOnly = true)
    public List<InteractiveTask> getTasksForAdmin(long deckId) {
        DeckInteractionConfig config = getExistingConfigForAdminDeck(deckId);
        return taskRepository.findByConfigIdOrderByOrderIndexAsc(config.getId());
    }

    public List<GameTemplateDefinition> getTemplates() {
        return gameCatalog.getTemplates();
    }

    public List<ThemePackDefinition> getThemes() {
        return gameCatalog.getThemes();
    }

    public List<TemplateVariantDefinition> getVariantsForTemplate(String templateKey) {
        return gameCatalog.getVariantsForTemplate(templateKey);
    }

    private DeckInteractionConfig getExistingConfigForAdminDeck(long deckId) {
        requireAdminDeck(deckId);
        return configRepository.findByDeckId(deckId)
                .orElseThrow(() -> new InteractiveGameException("Deck chưa có cấu hình tương tác."));
    }

    private Card requireCardInDeck(Deck deck, Long cardId) {
        if (cardId == null) {
            throw new InteractiveGameException("Mỗi round cần một target card.");
        }
        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new InteractiveGameException("Không tìm thấy card."));
        if (card.getDeck() == null || card.getDeck().getId() != deck.getId()) {
            throw new InteractiveGameException("Card không thuộc deck đang cấu hình.");
        }
        return card;
    }

    private String resolveVariant(
            GameTemplateDefinition template,
            ThemePackDefinition theme,
            String requestedVariant) {
        if (!template.requiresVariant()) {
            return null;
        }

        String variantKey = normalizeKey(requestedVariant);
        TemplateVariantDefinition variant = gameCatalog.findVariant(variantKey)
                .filter(item -> item.templateKey().equals(template.key()))
                .orElseThrow(() -> new InteractiveGameException(
                        "Hãy chọn hành động hợp lệ cho round ACTION."));
        if (!theme.supportsVariant(variant.key())) {
            throw new InteractiveGameException(
                    "Theme " + theme.displayName() + " không hỗ trợ hành động " + variant.displayName() + ".");
        }
        return variant.key();
    }

    private void validateConfig(DeckInteractionConfig config, List<InteractiveTask> tasks) {
        GameTemplateDefinition template = requireTemplate(config.getTemplateKey());
        ThemePackDefinition theme = requireCompatibleTheme(template.key(), config.getThemeKey());
        if (tasks.isEmpty()) {
            throw new InteractiveGameException(
                    "Hãy thêm ít nhất 1 round trước khi Preview hoặc bật game.");
        }

        Deck deck = config.getDeck();
        if (cardRepository.findByDeck(deck).size() < 3) {
            throw new InteractiveGameException("Deck cần ít nhất 3 card để tạo 3 lựa chọn cho mỗi round.");
        }
        for (InteractiveTask task : tasks) {
            if (task.getPromptText() == null || task.getPromptText().isBlank()) {
                throw new InteractiveGameException("Mỗi round phải có nội dung nhiệm vụ.");
            }
            if (task.getTargetCard() == null
                    || task.getTargetCard().getDeck() == null
                    || task.getTargetCard().getDeck().getId() != deck.getId()) {
                throw new InteractiveGameException("Target card phải thuộc deck hiện tại.");
            }
            if (template.requiresVariant()) {
                resolveVariant(template, theme, task.getTemplateVariant());
            }
        }
    }

    private List<Long> buildOptionCardIds(List<Card> deckCards, Card targetCard) {
        List<Card> distractors = new ArrayList<>(deckCards.stream()
                .filter(card -> card.getId() != targetCard.getId())
                .toList());
        Collections.shuffle(distractors);

        List<Long> optionIds = new ArrayList<>(3);
        optionIds.add(targetCard.getId());
        optionIds.add(distractors.get(0).getId());
        optionIds.add(distractors.get(1).getId());
        Collections.shuffle(optionIds);
        return List.copyOf(optionIds);
    }

    private void resequenceTasks(List<InteractiveTask> tasks) {
        for (int i = 0; i < tasks.size(); i++) {
            tasks.get(i).setOrderIndex(-(i + 1));
        }
        taskRepository.saveAllAndFlush(tasks);

        for (int i = 0; i < tasks.size(); i++) {
            tasks.get(i).setOrderIndex(i + 1);
        }
        taskRepository.saveAll(tasks);
    }

    private GameTemplateDefinition requireTemplate(String key) {
        String normalizedKey = normalizeKey(key);
        return gameCatalog.findTemplate(normalizedKey)
                .orElseThrow(() -> new InteractiveGameException("Template không hợp lệ."));
    }

    private ThemePackDefinition requireCompatibleTheme(String templateKey, String themeKey) {
        String normalizedKey = normalizeKey(themeKey);
        ThemePackDefinition theme = gameCatalog.findTheme(normalizedKey)
                .orElseThrow(() -> new InteractiveGameException("Theme không hợp lệ."));
        if (!theme.templateKey().equals(templateKey)) {
            throw new InteractiveGameException("Theme không tương thích với template đã chọn.");
        }
        return theme;
    }

    private String normalizeKey(String value) {
        String result = trimToNull(value);
        return result == null ? null : result.toUpperCase(Locale.ROOT);
    }

    private boolean isAdminUser(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        User user = userRepository.findByEmail(email);
        return user != null && user.getRole() != null && "ADMIN".equals(user.getRole().getName());
    }

    private String requireText(String value, String message) {
        String result = trimToNull(value);
        if (result == null) {
            throw new InteractiveGameException(message);
        }
        return result;
    }

    private String defaultIfBlank(String value, String fallback) {
        String result = trimToNull(value);
        return result == null ? fallback : result;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
