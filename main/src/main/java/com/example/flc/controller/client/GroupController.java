package com.example.flc.controller.client;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.flc.domain.StudyGroup;
import com.example.flc.domain.User;
import com.example.flc.repository.UserRepository;
import com.example.flc.service.GroupService;
import com.example.flc.service.UserService;

@Controller
@RequestMapping("/groups")
public class GroupController {

    @Autowired
    private GroupService groupService;
    @Autowired
    private UserRepository userRepository;

    // Hàm giả định lấy User đang đăng nhập
    // private User getCurrentUser() { ... }

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

        boolean isLead = group.getLead().getId() == currentUser.getId();

        model.addAttribute("group", group);
        model.addAttribute("members", groupService.getMembers(groupId));
        model.addAttribute("approvedDecks", groupService.getApprovedDecks(groupId));
        model.addAttribute("isLead", isLead);

        if (isLead) {
            model.addAttribute("pendingDecks", groupService.getPendingDecks(groupId));
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
    public String kickOrLeave(@PathVariable Long groupId, @RequestParam Long targetUserId, Principal principal) {
        groupService.removeMember(groupId, targetUserId, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups/" + groupId;
    }

    @PostMapping("/{groupId}/submit-deck")
    public String submitDeck(@PathVariable Long groupId, @RequestParam Long deckId, Principal principal) {
        groupService.submitDeckToGroup(groupId, deckId, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups/" + groupId;
    }

    @PostMapping("/{groupId}/approve-deck")
    public String approveDeck(@PathVariable Long groupId, @RequestParam Long groupDeckId, Principal principal) {
        groupService.approveDeck(groupId, groupDeckId, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups/" + groupId;
    }
}
