package com.example.flc.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.flc.domain.GroupDeck;

public interface GroupDeckRepository extends JpaRepository<GroupDeck, Long> {
    // Lấy deck đã duyệt để show cho member
    @Query("SELECT gd FROM GroupDeck gd WHERE gd.group.id = :groupId AND gd.status = :status")
    List<GroupDeck> findByGroupDeckStatus(@Param("groupId") Long groupId, @Param("status") String status);

    @Query("SELECT gd FROM GroupDeck gd JOIN GroupMember gm ON gd.group.id = gm.group.id " +
            "WHERE gd.group.id = :groupId AND gd.status = :status AND gm.user.id = :userId")
    List<GroupDeck> findByGroupMemberDeckStatus(@Param("groupId") Long groupId, @Param("status") String status,
            @Param("userId") Long userId);
}
