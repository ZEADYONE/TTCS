package com.example.flc.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.flc.domain.InteractiveTask;

public interface InteractiveTaskRepository extends JpaRepository<InteractiveTask, Long> {
    List<InteractiveTask> findByConfigIdOrderByOrderIndexAsc(Long configId);

    Optional<InteractiveTask> findByIdAndConfigId(Long id, Long configId);
}
