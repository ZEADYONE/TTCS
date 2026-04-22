package com.example.flc.controller.client;

import com.example.flc.domain.Card;
import com.example.flc.service.CardService; // Giả sử bạn có CardService
import com.example.flc.service.DeckService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class StudyController {

    private final CardService cardService;
    private final DeckService deckService;

    public StudyController(CardService cardService, DeckService deckService) {
        this.cardService = cardService;
        this.deckService = deckService;
    }

    @GetMapping("/client/study/{id}")
    public String getStudyPage(@PathVariable("id") long deckId, Model model) {
        // 1. Lấy danh sách Card dựa trên deckId
        List<Card> listCard = this.cardService.getListCardByDeck(this.deckService.getDeckById(deckId));
        model.addAttribute("deck", this.deckService.getDeckById(deckId));
        // 2. Đẩy dữ liệu vào Model để JSP có thể nhận được ${listCard}
        model.addAttribute("listCard", listCard);

        // 3. Trả về đường dẫn file JSP (đường dẫn tương đối trong thư mục view)
        return "client/deck/flashcard";
    }

    @GetMapping("/client/game/{id}")
    public String getGamePage(@PathVariable("id") long deckId, Model model) {
        // 1. Lấy danh sách Card dựa trên deckId
        List<Card> listCard = this.cardService.getListCardByDeck(this.deckService.getDeckById(deckId));
        model.addAttribute("deck", this.deckService.getDeckById(deckId));
        // 2. Đẩy dữ liệu vào Model để JSP có thể nhận được ${listCard}
        model.addAttribute("listCard", listCard);

        // 3. Trả về đường dẫn file JSP (đường dẫn tương đối trong thư mục view)
        return "client/deck/game";
    }

}
