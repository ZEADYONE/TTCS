package com.example.flc.domain.DTO;

import com.example.flc.domain.User;

public class DeckProgress {
    private Long id;
    private String title;
    private String image;
    private String des; // Thêm mới
    private String scope; // Thêm mới
    private String userName; // Thêm mới
    private Long totalCards;
    private Long correctCards;
    private Long userId;
    private boolean isFeatured;

    // Cập nhật Constructor để nhận thêm 3 trường mới
    public DeckProgress(Long id, String title, String image, String des, String scope, String userName, Long totalCards,
            Long correctCards, Long userId, boolean isFeatured) {
        this.id = id;
        this.title = title;
        this.image = image;
        this.des = des;
        this.scope = scope;
        this.userName = userName;
        this.totalCards = totalCards;
        this.correctCards = correctCards;
        this.userId = userId;
        this.isFeatured = isFeatured;
    }

    public double getProgressPercent() {
        if (totalCards == null || totalCards == 0)
            return 0;
        return (double) correctCards / totalCards * 100;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    // Getters - Bắt buộc phải có đủ để JSP không báo lỗi PropertyNotFound
    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getImage() {
        return image;
    }

    public String getDes() {
        return des;
    }

    public String getScope() {
        return scope;
    }

    public String getUserName() {
        return userName;
    }

    public Long getTotalCards() {
        return totalCards;
    }

    public Long getCorrectCards() {
        return correctCards;
    }

    public boolean getIsFeatured() {
        return isFeatured;
    }

    public void setIsFeatured(boolean isFeatured) {
        this.isFeatured = isFeatured;
    }
}