package com.example.flc.controller.admin;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.flc.repository.DeckRepository;
import com.example.flc.service.DashBoardService;

@Controller
@RequestMapping("/admin")
public class DashBoardController {

    @Autowired
    private DashBoardService dashboardService;

    @Autowired
    private DeckRepository deckRepository;

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        Map<String, Long> stats = dashboardService.getDashboardStats();

        // Đẩy dữ liệu sang JSP
        model.addAttribute("totalUsers", stats.get("totalUsers"));
        model.addAttribute("totalDecks", stats.get("totalDecks"));
        model.addAttribute("totalCourses", deckRepository.countByUserRoleName("ADMIN"));
        model.addAttribute("totalFeatured", deckRepository.countFeatured());

        return "admin/dashboard/dashboard"; // Trả về file dashboard.jsp
    }
}