package com.example.flc.controller.admin;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.flc.domain.Card;
import com.example.flc.domain.Deck;
import com.example.flc.domain.User;
import com.example.flc.service.CardService;
import com.example.flc.service.DeckService;
import com.example.flc.service.UploadService;
import com.example.flc.service.UserService;

@Controller
@RequestMapping("/admin")
public class AdminDeckController {

    private final DeckService deckService;
    private final CardService cardService;
    private final UploadService uploadService;
    private final UserService userService;

    public AdminDeckController(DeckService deckService, CardService cardService, UploadService uploadService,
            UserService userService) {
        this.deckService = deckService;
        this.cardService = cardService;
        this.uploadService = uploadService;
        this.userService = userService;
    }

    // HOME
    @GetMapping("/deck")
    public String getHomePage(Model model, @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "status", required = false) List<Boolean> status) {

        Pageable pageable = PageRequest.of(page - 1, 3);
        Page<Deck> pageDeck = this.deckService.getAllDeckWithFilter(keyword, status, pageable);

        model.addAttribute("listDeck", pageDeck.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageDeck.getTotalPages());

        // model.addAttribute("keyword", keyword);
        // model.addAttribute("selectedStatus", status);

        return "admin/deck/homepage";
    }

    // DELETE
    @PostMapping("/deck/status/{id}")
    public String deleteDeck(@PathVariable("id") long id) {
        this.deckService.setDeckStatus(id);
        return "redirect:/admin/deck";
    }

    // VIEW

    @GetMapping("/deck/view/{id}")
    public String getViewDeck(@PathVariable("id") long id, Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword) {

        Deck deck = this.deckService.getDeckById(id);
        model.addAttribute("deck", deck);

        Pageable pageable = PageRequest.of(page - 1, 4);

        Page<Card> pageCard = this.cardService.getAllCardByDeckFilter(keyword, deck, pageable);
        model.addAttribute("listCard", pageCard.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageCard.getTotalPages());
        model.addAttribute("keyword", keyword);

        return "admin/deck/view";
    }

    // UPDATE

    @GetMapping("/deck/update/{id}")
    public String getUpdateDeck(@PathVariable("id") long id, Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword) {

        Deck deck = this.deckService.getDeckById(id);
        System.out.println(deck);

        Pageable pageable = PageRequest.of(page - 1, 4);

        Page<Card> pageCard = this.cardService.getAllCardByDeckFilter(keyword, deck, pageable);
        model.addAttribute("deck", deck);
        model.addAttribute("listCard", pageCard.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageCard.getTotalPages());
        model.addAttribute("keyword", keyword);
        return "admin/deck/update";
    }

    @PostMapping("/deck/update/{id}")
    public String updateDeck(@PathVariable("id") long id, // Lấy ID từ URL cho chắc chắn
            @ModelAttribute("deck") Deck deck,
            @RequestParam("images") MultipartFile file,
            Principal principal) {

        Deck currentDeck = this.deckService.getDeckById(id);

        if (currentDeck != null) {
            currentDeck.setTitle(deck.getTitle());
            currentDeck.setDes(deck.getDes());
            currentDeck.setScope(deck.getScope());

            String pathImg = this.uploadService.handleSaveUploadImg(file, "client");
            if (!pathImg.isEmpty()) {
                currentDeck.setImage(pathImg);
            }

            this.deckService.handelSaveDeck(currentDeck);
        }

        return "redirect:/admin/deck/update/" + id;
    }

    @PostMapping("/deck/featured/{id}")
    public String toggleFeatured(@PathVariable Long id) {
        deckService.toggleFeatured(id);
        return "redirect:/admin/deck";
    }
}
