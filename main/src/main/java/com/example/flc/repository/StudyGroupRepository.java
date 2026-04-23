package com.example.flc.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.example.flc.domain.StudyGroup;

public interface StudyGroupRepository extends JpaRepository<StudyGroup, Long> {
    Page<StudyGroup> findByGroupNameContainingIgnoreCase(String keyword, Pageable pageable);
}
