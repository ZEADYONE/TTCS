package com.example.flc.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.flc.domain.GameRes;

public interface GameResRepository extends JpaRepository<GameRes, Long> {
}
