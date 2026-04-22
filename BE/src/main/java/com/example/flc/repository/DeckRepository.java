package com.example.flc.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.example.flc.domain.Deck;
import java.util.List;

@Repository
public interface DeckRepository extends JpaRepository<Deck, Long> {
        @Query("SELECT d FROM Deck d WHERE d.user.id = :userId AND d.status = true")
        List<Deck> findByUserId(@Param("userId") Long userId);

        @Query("SELECT d FROM Deck d WHERE " +
                        "(:keyword IS NULL OR d.title LIKE %:keyword%) AND " +
                        "(:status IS NULL OR d.status IN :status)")
        Page<Deck> findAllWithFilter(@Param("keyword") String keyword,
                        @Param("status") List<Boolean> status,
                        Pageable pageable);

        List<Deck> findByScope(String scope);

        // COMMUNITY
        @Query("SELECT DISTINCT d FROM Deck d " +
                        "WHERE d.status = true AND d.scope = 'Public' " +
                        "AND (:keyword IS NULL OR LOWER(d.title) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
                        "AND (d.user.role.name IS NULL OR d.user.role.name <> 'ADMIN')")
        Page<Deck> findPublicActiveDeck(@Param("keyword") String keyword, Pageable pageable);

        // COURSE
        @Query("SELECT d FROM Deck d " +
                        "JOIN d.user u " +
                        "JOIN u.role r " +
                        "WHERE d.status = true " +
                        "AND d.scope = 'Public' " +
                        "AND r.name = 'ADMIN'" +
                        "AND (:keyword IS NULL OR d.title LIKE %:keyword%)")
        Page<Deck> findDeckCourse(@Param("keyword") String keyword, Pageable pageable);

        // LIBRARY
        @Query(value = "SELECT d.id, d.title, d.image, d.des, d.scope, u.user_name, " +
                        "COUNT(DISTINCT c.id) AS totalCards, " +
                        "COUNT(DISTINCT CASE WHEN p.is_correct = 1 THEN c.id END) AS correctCards, " +
                        "d.user_id, d.is_featured " +
                        "FROM Deck d " +
                        "JOIN User u ON d.user_id = u.id " +
                        "JOIN Role r ON u.role_id = r.id " +
                        "LEFT JOIN Card c ON c.deck_id = d.id " +
                        "LEFT JOIN Progress p ON p.card_id = c.id AND p.user_id = :userId " +
                        "WHERE (:keyword IS NULL OR d.title LIKE CONCAT('%', :keyword, '%')) " +
                        "AND d.status = true " +
                        "AND (" +
                        "    'ALL' IN :filters OR ( " +
                        "        ('Public' IN :filters AND d.scope = 'Public') OR " +
                        "        ('Private' IN :filters AND d.scope = 'Private') OR " +
                        "        ('Mine' IN :filters AND d.user_id = :userId) OR " +
                        "        ('Admin' IN :filters AND r.name = 'ADMIN') OR " +
                        "        ('Other' IN :filters AND d.user_id != :userId AND r.name != 'ADMIN') " +
                        "    )" +
                        ") " +
                        "AND (" +
                        "    d.user_id = :userId " + // Lấy bộ của chính mình
                        "    OR (d.scope = 'Public' AND EXISTS (" + // Hoặc bộ Public mà mình đã học
                        "        SELECT 1 FROM Progress p2 " +
                        "        JOIN Card c2 ON p2.card_id = c2.id " +
                        "        WHERE c2.deck_id = d.id AND p2.user_id = :userId" +
                        "    ))" +
                        ") " +
                        "GROUP BY d.id, d.title, d.image, d.des, d.scope, u.user_name, d.user_id, d.is_featured", countQuery = "SELECT COUNT(DISTINCT d.id) FROM Deck d "
                                        +
                                        "JOIN User u ON d.user_id = u.id JOIN Role r ON u.role_id = r.id " +
                                        "WHERE (:keyword IS NULL OR d.title LIKE CONCAT('%', :keyword, '%')) " +
                                        "AND d.status = true " +
                                        "AND ('ALL' IN :filters OR ( " +
                                        "    ('Public' IN :filters AND d.scope = 'Public') OR " +
                                        "    ('Private' IN :filters AND d.scope = 'Private') OR " +
                                        "    ('Mine' IN :filters AND d.user_id = :userId) OR " +
                                        "    ('Admin' IN :filters AND r.name = 'ADMIN') OR " +
                                        "    ('Other' IN :filters AND d.user_id != :userId AND r.name != 'ADMIN') " +
                                        ")) " +
                                        "AND (d.user_id = :userId OR (d.scope = 'Public' AND EXISTS (" +
                                        "    SELECT 1 FROM Progress p2 JOIN Card c2 ON p2.card_id = c2.id " +
                                        "    WHERE c2.deck_id = d.id AND p2.user_id = :userId)))", nativeQuery = true)
        Page<Object[]> findAdvancedDecks(@Param("keyword") String keyword,
                        @Param("filters") List<String> filters,
                        @Param("userId") Long userId,
                        Pageable pageable);

        @Query("""
                            SELECT COUNT(d)
                            FROM Deck d
                            JOIN d.user u
                            JOIN u.role r
                            WHERE r.name = :roleName
                        """)
        long countByUserRoleName(@Param("roleName") String roleName);

        @Query("SELECT COUNT(d) FROM Deck d WHERE d.isFeatured = true")
        long countFeatured();
}
