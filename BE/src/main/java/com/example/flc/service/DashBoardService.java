package com.example.flc.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.flc.repository.CourseRepository;
import com.example.flc.repository.DeckRepository;
import com.example.flc.repository.UserRepository;

@Service
public class DashBoardService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DeckRepository deckRepository;

    @Autowired
    private CourseRepository courseRepository;

    public Map<String, Long> getDashboardStats() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("totalUsers", userRepository.count());
        stats.put("totalDecks", deckRepository.count());
        stats.put("totalCourses", courseRepository.count());
        return stats;
    }
}
