package com.example.flc.domain.DTO;

public class AiFlashcardResponseDTO {
    private String word;
    private String transliteration;
    private String vietnamese;
    private String example;
    private String definition;

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    public String getTransliteration() {
        return transliteration;
    }

    public void setTransliteration(String transliteration) {
        this.transliteration = transliteration;
    }

    public String getVietnamese() {
        return vietnamese;
    }

    public void setVietnamese(String vietnamese) {
        this.vietnamese = vietnamese;
    }

    public String getExample() {
        return example;
    }

    public void setExample(String example) {
        this.example = example;
    }

    public String getDefinition() {
        return definition;
    }

    public void setDefinition(String definition) {
        this.definition = definition;
    }
}
