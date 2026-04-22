package com.example.flc.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.flc.domain.GroupDeck;

public interface GroupDeckRepository extends JpaRepository<GroupDeck, Long> {
    // Lấy deck đã duyệt để show cho member
    List<GroupDeck> findByGroupIdAndIsApprovedTrue(Long groupId);

    // Lấy deck chờ duyệt để show cho Lead
    List<GroupDeck> findByGroupIdAndIsApprovedFalse(Long groupId);
}
