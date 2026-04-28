package com.example.flc.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.flc.domain.Report;

@Repository
public interface ReportRepository extends JpaRepository<Report, Long> {

        @Query("SELECT r FROM Report r " +
                        "JOIN r.deck d " +
                        "where r.status = false AND d.status = true " +
                        "AND (:keyword IS NULL OR LOWER(d.title) LIKE LOWER(CONCAT('%', :keyword, '%')))")
        public Page<Report> findByAllReportStatusEqualFalse(@Param("keyword") String keyword,
                        @Param("pageable") Pageable pageable);

        @Query("SELECT r FROM Report r " +
                        "JOIN r.deck d " +
                        "where r.status = false AND d.id = :deckId")
        public List<Report> findByAllDeckStatusEqualFalse(@Param("deckId") long deckId);
}
