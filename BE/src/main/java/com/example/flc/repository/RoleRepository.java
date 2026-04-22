package com.example.flc.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.flc.domain.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

    Optional<Role> findByName(String name);

    @Query(value = "SELECT r FROM Role r WHERE" +
            "(:keyword IS NULL OR r.name LIKE %:keyword%)")
    Page<Role> findAll(@Param("keyword") String keyword, Pageable pageable);
}
