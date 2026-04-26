package com.example.flc.controller.client;

import java.security.Principal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.flc.domain.StudyGroup;
import com.example.flc.domain.User;
import com.example.flc.repository.UserRepository;
import com.example.flc.service.GroupService;

@Controller
@RequestMapping("/groups")
public class GroupController {

    @Autowired
    private GroupService groupService;
    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public String listGroups(Model model, Principal principal) {
        model.addAttribute("myGroups", groupService.getMyGroups(userRepository.findByEmail(principal.getName())));
        return "client/group/list";
    }

    @PostMapping("/create")
    public String createGroup(@RequestParam String groupName, Principal principal) {
        groupService.createGroup(groupName, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups";
    }

    @GetMapping("/{groupId}")
    public String viewGroup(@PathVariable Long groupId, Model model, Principal principal) {
        User currentUser = userRepository.findByEmail(principal.getName());
        StudyGroup group = groupService.getGroupById(groupId);

        boolean isLead = groupService.checkIsLeader(groupId, currentUser);

        model.addAttribute("group", group);
        model.addAttribute("members", groupService.getMembers(groupId));
        model.addAttribute("approvedDecks", groupService.getStatusDecks(groupId, "APPROVED"));

        // SỬA DÒNG NÀY: Đổi "isLead" thành "isLeader"
        model.addAttribute("isLeader", isLead);

        model.addAttribute("currentUserId", currentUser.getId());

        if (isLead) {
            model.addAttribute("pendingDecks", groupService.getStatusDecks(groupId, "PENDING"));
            model.addAttribute("rejectedDecks", groupService.getStatusDecks(groupId, "REJECTED"));
        } else {
            model.addAttribute("rejectedMemberDecks",
                    groupService.getStatusMemberDecks(groupId, "REJECTED", currentUser.getId()));
            model.addAttribute("pendingMemberDecks",
                    groupService.getStatusMemberDecks(groupId, "PENDING", currentUser.getId()));
        }

        return "client/group/detail";
    }

    @PostMapping("/{groupId}/add-member")
    public String addMember(@PathVariable Long groupId, @RequestParam String email, Model model, Principal principal) {
        try {
            groupService.addMemberByEmail(groupId, email, userRepository.findByEmail(principal.getName()));
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return viewGroup(groupId, model, principal);
        }
        return "redirect:/groups/" + groupId;
    }

    @PostMapping("/{groupId}/kick")
    public String kickOrLeave(@PathVariable Long groupId, @RequestParam Long targetUserId, Principal principal,
            Model model) {
        try {
            groupService.removeMember(groupId, targetUserId, userRepository.findByEmail(principal.getName()));
            return "redirect:/groups/" + groupId;
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return viewGroup(groupId, model, principal);
        }
    }

    // --- API GIẢI TÁN NHÓM ---
    @PostMapping("/{groupId}/disband")
    public String disbandGroup(@PathVariable Long groupId, Principal principal, Model model) {
        try {
            groupService.disbandGroup(groupId, userRepository.findByEmail(principal.getName()));
            return "redirect:/groups"; // Xóa xong thì chuyển về danh sách nhóm
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return viewGroup(groupId, model, principal);
        }
    }

    @PostMapping("/{groupId}/submit-deck")
    public String submitDeck(@PathVariable Long groupId, @RequestParam Long deckId, Principal principal) {
        groupService.submitDeckToGroup(groupId, deckId, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups/" + groupId;
    }

    @PostMapping("/share-from-library")
    public String shareFromLibrary(@RequestParam Long groupId, @RequestParam Long deckId, Principal principal) {
        groupService.submitDeckToGroup(groupId, deckId, userRepository.findByEmail(principal.getName()));
        return "redirect:/client/library";
    }

    @PostMapping("/{groupId}/approve-deck")
    public String approveDeck(@PathVariable Long groupId, @RequestParam Long groupDeckId, Principal principal) {
        groupService.approveDeck(groupId, groupDeckId, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups/" + groupId;
    }

    @PostMapping("/{groupId}/reject-deck")
    public String rejectDeck(@PathVariable Long groupId, @RequestParam Long groupDeckId, Principal principal) {
        groupService.rejectDeck(groupId, groupDeckId, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups/" + groupId;
    }
}