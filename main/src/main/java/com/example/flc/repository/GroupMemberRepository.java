package com.example.flc.repository;

import java.util.List;

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

    @Query("SELECT gm.group FROM GroupMember gm WHERE gm.user = :user")
    List<StudyGroup> findGroupsByUser(@Param("user") User user);

    java.util.Optional<GroupMember> findByGroupAndUser(StudyGroup group, User user);

    void deleteByGroupId(Integer groupId);
}
