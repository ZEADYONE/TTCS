package com.example.flc.controller.client;

import com.example.flc.domain.Card;
import com.example.flc.domain.Deck;
import com.example.flc.domain.User;
import com.example.flc.service.CardService; // Giả sử bạn có CardService
import com.example.flc.service.DeckService;
import com.example.flc.service.ProgressService;
import com.example.flc.service.UserDeckLibraryService;
import com.example.flc.service.UserService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.security.Principal;
import java.util.List;

@Controller
public class StudyController {

    private final CardService cardService;
    private final DeckService deckService;
    private final ProgressService progressService;
    private final UserDeckLibraryService userDeckLibraryService;
    private final UserService userService;

    public StudyController(CardService cardService, DeckService deckService, ProgressService progressService,
            UserDeckLibraryService userDeckLibraryService, UserService userService) {
        this.cardService = cardService;
        this.deckService = deckService;
        this.progressService = progressService;
        this.userDeckLibraryService = userDeckLibraryService;
        this.userService = userService;
    }

    @GetMapping("/client/study/{id}")
    public String getStudyPage(@PathVariable("id") long deckId, Model model, Principal principal) {
        User user = this.userService.getUserByEmail(principal.getName());
        Deck deck = this.deckService.getDeckById(deckId);
        this.userDeckLibraryService.addDeckToLibraryIfNotExists(user, deck);
        // 1. Lấy danh sách Card dựa trên deckId
        List<Card> listCard = this.cardService.getListCardByDeck(this.deckService.getDeckById(deckId));
        model.addAttribute("deck", this.deckService.getDeckById(deckId));
        // 2. Đẩy dữ liệu vào Model để JSP có thể nhận được ${listCard}
        model.addAttribute("listCard", listCard);

        // 3. Trả về đường dẫn file JSP (đường dẫn tương đối trong thư mục view)
        return "client/deck/flashcard";
    }

    @GetMapping("/client/game/{id}")
    public String getGamePage(@PathVariable("id") long deckId, Model model, Principal principal) {
        User user = this.userService.getUserByEmail(principal.getName());
        Deck deck = this.deckService.getDeckById(deckId);
        this.userDeckLibraryService.addDeckToLibraryIfNotExists(user, deck);
        // 1. Lấy danh sách Card dựa trên deckId
        List<Card> listCard = this.cardService.getListCardByDeck(this.deckService.getDeckById(deckId));
        model.addAttribute("deck", this.deckService.getDeckById(deckId));
        // 2. Đẩy dữ liệu vào Model để JSP có thể nhận được ${listCard}
        model.addAttribute("listCard", listCard);

        // 3. Trả về đường dẫn file JSP (đường dẫn tương đối trong thư mục view)
        return "client/deck/game";
    }

    @GetMapping("/client/review")
    public String getStudyPage(Model model, Principal principal) {
        String email = principal.getName();

        // 2. Lấy danh sách Card dựa trên deckId và email
        List<Card> listCard = this.progressService.getReviewCard(email);

        model.addAttribute("listCard", listCard);

        // 3. Trả về đường dẫn file JSP (đường dẫn tương đối trong thư mục view)
        return "client/review/review";
    }

}
