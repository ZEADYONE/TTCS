package com.example.flc.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.flc.domain.Deck;

@Repository
public interface CourseRepository extends JpaRepository<Deck, Long> {

        @Query("SELECT d FROM Deck d WHERE " +
                        "(:keyword IS NULL OR d.title LIKE %:keyword%) " +
                        "AND (:scopes IS NULL OR d.scope IN :scopes) " + // Đổi status thành scope
                        "AND d.user.role.name = 'ADMIN'")
        Page<Deck> findAllDecksByAdmin(@Param("keyword") String keyword,
                        @Param("scopes") List<String> scopes,
                        Pageable pageable);

}
