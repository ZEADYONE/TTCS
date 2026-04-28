package com.example.flc.service;

import java.security.Principal;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.flc.domain.Deck;
import com.example.flc.domain.Report;
import com.example.flc.domain.User;
import com.example.flc.repository.ReportRepository;

@Service
public class ReportService {

    private DeckService deckService;
    private UserService userService;
    private ReportRepository reportRepository;

    public ReportService(DeckService deckService, UserService userService, ReportRepository reportRepository) {
        this.deckService = deckService;
        this.userService = userService;
        this.reportRepository = reportRepository;
    }

    public void saveReport(Long deckId, Report reportForm, Principal principal) {
        Deck deck = deckService.getDeckById(deckId);
        User user = userService.getUserByEmail(principal.getName());

        reportForm.setDeck(deck);
        reportForm.setUser(user);

        reportRepository.save(reportForm);
    }

    public Page<Report> getAllReports(String keyword, Pageable pageable) {
        String searchKeyword = (keyword != null && !keyword.isEmpty()) ? keyword : null;
        return reportRepository.findByAllReportStatusEqualFalse(searchKeyword, pageable);
    }

    public void cancelReport(Long reportId) {
        Report report = reportRepository.findById(reportId).orElseThrow();
        report.setStatus(true);
        reportRepository.save(report);
    }

    public void setFalseAllDeck(Long deckId) {
        List<Report> reports = reportRepository.findByAllDeckStatusEqualFalse(deckId);
        for (Report report : reports) {
            report.setStatus(true);
            reportRepository.save(report);
        }
    }
}
