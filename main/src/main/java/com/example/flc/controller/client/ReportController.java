package com.example.flc.controller.client;

import java.lang.annotation.Repeatable;
import java.security.Principal;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.flc.domain.Deck;
import com.example.flc.domain.Report;
import com.example.flc.domain.User;
import com.example.flc.service.DeckService;
import com.example.flc.service.ReportService;
import com.example.flc.service.UserService;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ReportController {

    private ReportService reportService;
    private DeckService deckService;

    public ReportController(ReportService reportService, DeckService deckService) {
        this.reportService = reportService;
        this.deckService = deckService;
    }

    @PostMapping("/client/report/{deckId}")
    public String reportForm(@PathVariable("deckId") Long deckId, @ModelAttribute("reportForm") Report reportForm,
            Model model, Principal principal) {
        reportService.saveReport(deckId, reportForm, principal);
        return "redirect:/client/community";
    }

    @GetMapping("/admin/reports")
    public String viewReports(Model model,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "1") int page) {

        Pageable pageable = PageRequest.of(page - 1, 3);
        Page<Report> reportPage = reportService.getAllReports(keyword, pageable);

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", reportPage.getTotalPages());

        model.addAttribute("keyword", keyword);
        model.addAttribute("reports", reportPage.getContent());

        return "admin/report/report";
    }

    @PostMapping("/admin/reports/ban/{deckId}")
    public String banDeck(@PathVariable("deckId") Long deckId) {
        this.deckService.setDeckStatus(deckId);
        this.reportService.setFalseAllDeck(deckId);
        return "redirect:/admin/reports";
    }

    @PostMapping("/admin/reports/cancel/{reportId}")
    public String getCancelReport(@PathVariable("reportId") Long reportId) {
        reportService.cancelReport(reportId);
        return "redirect:/admin/reports";
    }

}
