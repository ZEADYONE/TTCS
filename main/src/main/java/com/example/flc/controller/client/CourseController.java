package com.example.flc.controller.client;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.flc.domain.Deck;
import com.example.flc.domain.User;
import com.example.flc.service.CourseService;
import com.example.flc.service.DeckService;
import com.example.flc.service.UploadService;
import com.example.flc.service.UserService;

@Controller
public class CourseController {

    private final CourseService courseService;
    private final DeckService deckService;
    private final UploadService uploadService;
    private final UserService userService;

    public CourseController(CourseService courseService, DeckService deckService, UploadService uploadService,
            UserService userService) {
        this.courseService = courseService;
        this.deckService = deckService;
        this.uploadService = uploadService;
        this.userService = userService;
    }

    // VIEW
    @GetMapping("/admin/course")
    public String getCoursePage(Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "scope", required = false) List<String> scope) { // Nhận List String

        Pageable pageable = PageRequest.of(page - 1, 3);
        // Truyền tham số scope vào service
        Page<Deck> pageDeck = this.courseService.getAllDeckWithFilter(keyword, scope, pageable);

        model.addAttribute("listCourse", pageDeck.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageDeck.getTotalPages());

        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedScope", scope);
        return "admin/course/homepage";
    }

    // STATUS
    @PostMapping("/admin/course/status/{id}")
    public String setStatusDeck(@PathVariable("id") long id) {
        this.deckService.setDeckStatus(id);
        return "redirect:/admin/hompage";
    }

    // UPDATE
    @PostMapping("/admin/course/update")
    public String updateDeck(@ModelAttribute("deck") Deck deck, @RequestParam("images") MultipartFile file,
            Principal principal) {

        String pathImg = this.uploadService.handleSaveUploadImg(file, "client");

        if (pathImg.isEmpty()) {
            deck.setImage(this.deckService.getDeckById(deck.getId()).getImage());
        } else {

            deck.setImage(pathImg);
        }

        String username = principal.getName();
        User user = this.userService.getUserByEmail(username);
        deck.setUser(user);
        deck.setStatus(true);

        this.deckService.handelSaveDeck(deck);

        return "redirect:/admin/course";
    }

    @PostMapping("/admin/course/create")
    public String createDeck(@ModelAttribute("deck") Deck deck, @RequestParam("images") MultipartFile file,
            Principal principal) {

        String pathImg = this.uploadService.handleSaveUploadImg(file, "client");
        deck.setImage(pathImg);
        String username = principal.getName();
        User user = this.userService.getUserByEmail(username);
        deck.setUser(user);
        deck.setStatus(true);

        this.deckService.handelSaveDeck(deck);

        return "redirect:/admin/course";
    }

}
