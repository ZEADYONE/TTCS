package com.example.flc.controller.client;

import java.security.Principal;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.flc.domain.Deck;
import com.example.flc.domain.User;
import com.example.flc.domain.DTO.DeckProgress;
import com.example.flc.repository.UserRepository;
import com.example.flc.service.DeckService;

@Controller
@RequestMapping("/client")
public class LCCController {

    private final DeckService deckService;
    private final UserRepository userRepository;

    // LIBRARY
    public LCCController(DeckService deckService, UserRepository userRepository) {
        this.userRepository = userRepository;
        this.deckService = deckService;
    }

    @GetMapping("/library")
    public String viewLibrary(Model model, Principal principal,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) List<String> filters) {

        // 1. Lấy thông tin user hiện tại
        User user = userRepository.findByEmail(principal.getName());

        model.addAttribute("currentUser", user.getId());
        // 2. Cấu hình phân trang (6 item mỗi trang)
        Pageable pageable = PageRequest.of(page - 1, 6);

        // 3. Gọi Service
        Page<DeckProgress> deckPage = deckService.getLibraryDecks(keyword, filters, user.getId(), pageable);

        // 4. Đẩy dữ liệu ra giao diện
        model.addAttribute("listDeck", deckPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", deckPage.getTotalPages());
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedFilters", filters); // Quan trọng để giữ trạng thái Checkbox

        return "client/library/library";
    }

    // COMMUNITY
    @GetMapping("/community")
    public String getCommunityPage(Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword) {

        Pageable pageable = PageRequest.of(page - 1, 6);

        Page<Deck> pageDeck = this.deckService.getDeckCommunity(keyword, pageable);

        model.addAttribute("listDeck", pageDeck.getContent()); // Dữ liệu của trang hiện tại
        model.addAttribute("currentPage", page); // Trang hiện tại
        model.addAttribute("totalPages", pageDeck.getTotalPages()); // Tổng số trang

        model.addAttribute("keyword", keyword);

        return "client/community/community";
    }

    // COURSE
    @GetMapping("/course")
    public String getCoursePage(Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword) {

        Pageable pageable = PageRequest.of(page - 1, 6);
        Page<Deck> pageDeck = this.deckService.getDeckCourse(keyword, pageable);

        model.addAttribute("decks", pageDeck.getContent()); // Dữ liệu của trang hiện tại
        model.addAttribute("currentPage", page); // Trang hiện tại
        model.addAttribute("totalPages", pageDeck.getTotalPages()); // Tổng số

        model.addAttribute("keyword", keyword);

        return "client/course/course";
    }
}
