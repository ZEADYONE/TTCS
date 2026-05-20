package com.example.flc.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.flc.domain.GroupMember;
import com.example.flc.domain.StudyGroup;
import com.example.flc.domain.User;

public interface GroupMemberRepository extends JpaRepository<GroupMember, Integer> {
    boolean existsByGroupAndUser(StudyGroup group, User user);

    void deleteByGroupAndUser(StudyGroup group, User user);

    List<GroupMember> findByGroupId(Long groupId);

    @Query("SELECT gm.group FROM GroupMember gm " +
            "JOIN gm.group g " +
            "WHERE gm.user = :user " +
            "AND (:keyword IS NULL OR LOWER(g.groupName) LIKE LOWER(CONCAT('%', :keyword, '%')))")

    Page<StudyGroup> findGroupsByUser(@Param("user") User user, @Param("keyword") String keyword, Pageable pageable);

    Optional<GroupMember> findByGroupAndUser(StudyGroup group, User user);

    @Query("SELECT gm.group FROM GroupMember gm WHERE gm.user = :user")
    List<StudyGroup> findGroupsByUserShare(User user);

    @Query("SELECT gm FROM GroupMember gm WHERE gm.group.id = :groupId AND gm.groupRole = 'LEADER'")
    GroupMember findUserByLeaderGroupId(@Param("groupId") Integer groupId);

    void deleteByGroupId(Integer groupId);
}
