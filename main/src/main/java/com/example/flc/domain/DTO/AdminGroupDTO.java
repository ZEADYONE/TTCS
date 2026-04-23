package com.example.flc.domain.DTO;

import java.util.Date;

public class AdminGroupDTO {
    private Long id;
    private String groupName;
    private String description;
    private String leaderName;
    private int memberCount;
    private Date createdAt;

    public AdminGroupDTO() {
    }

    public AdminGroupDTO(Long id, String groupName, String description, String leaderName, int memberCount, Date createdAt) {
        this.id = id;
        this.groupName = groupName;
        this.description = description;
        this.leaderName = leaderName;
        this.memberCount = memberCount;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLeaderName() {
        return leaderName;
    }

    public void setLeaderName(String leaderName) {
        this.leaderName = leaderName;
    }

    public int getMemberCount() {
        return memberCount;
    }

    public void setMemberCount(int memberCount) {
        this.memberCount = memberCount;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
