package com.example.flc.controller.client;

import com.example.flc.repository.DeckRepository;
import com.example.flc.repository.UserRepository;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.security.Principal;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.flc.domain.Card;
import com.example.flc.domain.Deck;
import com.example.flc.domain.User;
import com.example.flc.service.CardService;
import com.example.flc.service.DeckService;
import com.example.flc.service.UploadService;

@Controller
public class DeckController {

    private final DeckRepository deckRepository;
    private final DeckService deckService;
    private final UploadService uploadService;
    private final UserRepository userRepository;
    private final CardService cardService;

    public DeckController(UploadService uploadService, DeckService deckService, UserRepository userRepository,
            CardService cardService, DeckRepository deckRepository) {
        this.uploadService = uploadService;
        this.deckService = deckService;
        this.userRepository = userRepository;
        this.cardService = cardService;
        this.deckRepository = deckRepository;
    }

    // CREATE
    @PostMapping("/client/deck/create")
    public String createDeck(
            @ModelAttribute("deck") Deck deck,
            @RequestParam("images") MultipartFile file,
            Principal principal) {

        String pathImg = this.uploadService.handleSaveUploadImg(file, "client");
        deck.setImage(pathImg);

        String username = principal.getName();
        User user = userRepository.findByEmail(username);

        deck.setUser(user);
        deck.setStatus(true);
        this.deckService.handelSaveDeck(deck);

        return "redirect:/client/library";
    }

    // VIEW
    @GetMapping("/client/deck/{id}")
    public String getHomeDeck(@PathVariable("id") long id, Model model, Principal principal,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword) {

        Deck deck = this.deckService.getDeckById(id);

        String username = principal.getName();
        User user = userRepository.findByEmail(username);
        Long currentUserId = user.getId();

        Pageable pageable = PageRequest.of(page - 1, 4);
        Page<Card> pageCard = this.cardService.getAllCardByDeckFilter(keyword, deck, pageable);

        model.addAttribute("currentUser", currentUserId);
        model.addAttribute("deck", deck);
        model.addAttribute("listCard", pageCard.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageCard.getTotalPages());

        model.addAttribute("keyword", keyword);
        return "client/deck/homepage";
    }

    // UPDATE
    @PostMapping("/client/deck/update")
    public String updateDeck(@ModelAttribute("deck") Deck deck, @RequestParam("images") MultipartFile file,
            Principal principal) {

        String pathImg = this.uploadService.handleSaveUploadImg(file, "client");

        if (pathImg.isEmpty()) {
            deck.setImage(this.deckService.getDeckById(deck.getId()).getImage());
        } else {

            deck.setImage(pathImg);
        }

        String username = principal.getName();
        User user = userRepository.findByEmail(username);

        deck.setUser(user);
        deck.setStatus(true);

        this.deckService.handelSaveDeck(deck);

        return "redirect:/client/library";
    }

    // DELETE
    @PostMapping("/client/deck/delete/{id}")
    public String deleteDeck(@PathVariable("id") long id) {
        Deck deck = this.deckService.getDeckById(id);
        deck.setStatus(false);
        return "redirect:/client/library";
    }

    // =======================ADMIN====================

    // VIEW
    @GetMapping("/admin/course/{id}")
    public String getHomeCourse(@PathVariable("id") long id, Model model, Principal principal,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword) {
        Deck deck = this.deckService.getDeckById(id);

        String username = principal.getName();
        User user = userRepository.findByEmail(username);
        Long currentUserId = user.getId();

        Pageable pageable = PageRequest.of(page - 1, 4);

        Page<Card> pageCard = this.cardService.getAllCardByDeckFilter(keyword, deck, pageable);

        model.addAttribute("currentUser", currentUserId);
        model.addAttribute("deck", deck);
        model.addAttribute("listCard", pageCard.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageCard.getTotalPages());

        model.addAttribute("keyword", keyword);
        return "admin/course/course";
    }

}
