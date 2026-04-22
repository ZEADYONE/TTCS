package com.example.flc.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.flc.domain.User;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User save(User user);

    User findByEmail(String email);

    boolean existsByEmail(String email);

    boolean existsByUserName(String userName);

    Page<User> findAll(Pageable pageable);

    @Query("SELECT u FROM User u WHERE " +
            "(:keyword IS NULL OR u.email LIKE %:keyword% OR u.email LIKE %:keyword%) AND " +
            "(:status IS NULL OR u.status IN :status) AND " +
            "(:roleIds IS NULL OR u.role.id IN :roleIds)")
    Page<User> findWithFilter(@Param("keyword") String keyword,
            @Param("status") List<Boolean> status,
            @Param("roleIds") List<Long> roleIds,
            Pageable pageable);

}
