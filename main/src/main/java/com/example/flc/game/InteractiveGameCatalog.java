package com.example.flc.game;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.stereotype.Component;

@Component
public class InteractiveGameCatalog {

    public static final String FEED = "FEED";
    public static final String ACTION = "ACTION";
    public static final String SELECT = "SELECT";

    private final Map<String, GameTemplateDefinition> templates = new LinkedHashMap<>();
    private final Map<String, ThemePackDefinition> themes = new LinkedHashMap<>();
    private final Map<String, TemplateVariantDefinition> variants = new LinkedHashMap<>();

    public InteractiveGameCatalog() {
        registerTemplate(new GameTemplateDefinition(FEED, "Feed", "feed", false));
        registerTemplate(new GameTemplateDefinition(ACTION, "Action", "action", true));
        registerTemplate(new GameTemplateDefinition(SELECT, "Select", "select", false));

        registerVariant(new TemplateVariantDefinition("JUMP", "Jump", ACTION));
        registerVariant(new TemplateVariantDefinition("SWIM", "Swim", ACTION));
        registerVariant(new TemplateVariantDefinition("RUN", "Run", ACTION));

        registerTheme(new ThemePackDefinition(
                "GARDEN_FEAST",
                "Garden Feast",
                FEED,
                "theme--garden-feast",
                "Khu vườn dành cho các chủ đề đồ ăn, thức uống và hoa quả.",
                Set.of()));
        registerTheme(new ThemePackDefinition(
                "PLAYGROUND_ADVENTURE",
                "Playground Adventure",
                ACTION,
                "theme--playground-adventure",
                "Sân vận động hỗ trợ các hành động nhảy, bơi và chạy.",
                Set.of("JUMP", "SWIM", "RUN")));
        registerTheme(new ThemePackDefinition(
                "COLOR_WORLD",
                "Color World",
                SELECT,
                "theme--color-world",
                "Không gian nhiều màu cho trò chơi chọn đáp án.",
                Set.of()));
    }

    public List<GameTemplateDefinition> getTemplates() {
        return List.copyOf(templates.values());
    }

    public List<ThemePackDefinition> getThemes() {
        return List.copyOf(themes.values());
    }

    public List<ThemePackDefinition> getThemesForTemplate(String templateKey) {
        return themes.values().stream()
                .filter(theme -> theme.templateKey().equals(templateKey))
                .toList();
    }

    public List<TemplateVariantDefinition> getVariantsForTemplate(String templateKey) {
        return variants.values().stream()
                .filter(variant -> variant.templateKey().equals(templateKey))
                .toList();
    }

    public Optional<GameTemplateDefinition> findTemplate(String key) {
        return Optional.ofNullable(templates.get(key));
    }

    public Optional<ThemePackDefinition> findTheme(String key) {
        return Optional.ofNullable(themes.get(key));
    }

    public Optional<TemplateVariantDefinition> findVariant(String key) {
        return Optional.ofNullable(variants.get(key));
    }

    private void registerTemplate(GameTemplateDefinition definition) {
        templates.put(definition.key(), definition);
    }

    private void registerTheme(ThemePackDefinition definition) {
        themes.put(definition.key(), definition);
    }

    private void registerVariant(TemplateVariantDefinition definition) {
        variants.put(definition.key(), definition);
    }
}
