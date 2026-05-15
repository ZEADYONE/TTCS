package com.example.flc.controller.client;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.flc.domain.StudyGroup;
import com.example.flc.domain.User;
import com.example.flc.domain.GroupDeck;
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
    public String listGroups(Model model, Principal principal,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword) {

        Pageable pageable = PageRequest.of(page - 1, 6);
        Page<StudyGroup> listGroups = groupService.getMyGroups(userRepository.findByEmail(principal.getName()), keyword,
                pageable);

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", listGroups.getTotalPages());

        model.addAttribute("keyword", keyword);

        model.addAttribute("myGroups", listGroups.getContent());
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
        Pageable limit6 = PageRequest.of(0, 6);

        Page<GroupDeck> approvedPage = groupService.getStatusDecksPaginated(groupId, "APPROVED", limit6);
        model.addAttribute("approvedDecks", approvedPage.getContent());
        model.addAttribute("hasMoreApprovedDecks", approvedPage.hasNext());

        // SỬA DÒNG NÀY: Đổi "isLead" thành "isLeader"
        model.addAttribute("isLeader", isLead);

        model.addAttribute("currentUserId", currentUser.getId());

        if (isLead) {
            Page<GroupDeck> pendingPage = groupService.getStatusDecksPaginated(groupId, "PENDING", limit6);
            model.addAttribute("pendingDecks", pendingPage.getContent());
            model.addAttribute("hasMorePendingDecks", pendingPage.hasNext());

            Page<GroupDeck> rejectedPage = groupService.getStatusDecksPaginated(groupId, "REJECTED", limit6);
            model.addAttribute("rejectedDecks", rejectedPage.getContent());
            model.addAttribute("hasMoreRejectedDecks", rejectedPage.hasNext());
        } else {
            Page<GroupDeck> rejectedMemberPage = groupService.getStatusMemberDecksPaginated(groupId, "REJECTED",
                    currentUser.getId(), limit6);
            model.addAttribute("rejectedMemberDecks", rejectedMemberPage.getContent());
            model.addAttribute("hasMoreRejectedMemberDecks", rejectedMemberPage.hasNext());

            Page<GroupDeck> pendingMemberPage = groupService.getStatusMemberDecksPaginated(groupId, "PENDING",
                    currentUser.getId(), limit6);
            model.addAttribute("pendingMemberDecks", pendingMemberPage.getContent());
            model.addAttribute("hasMorePendingMemberDecks", pendingMemberPage.hasNext());
        }

        return "client/group/detail";
    }

    @GetMapping("/{groupId}/decks")
    public String viewDecksByType(@PathVariable Long groupId, @RequestParam String status,
            @RequestParam(value = "page", defaultValue = "1") int page, Model model, Principal principal) {
        User currentUser = userRepository.findByEmail(principal.getName());
        StudyGroup group = groupService.getGroupById(groupId);
        boolean isLead = groupService.checkIsLeader(groupId, currentUser);

        Pageable pageable = PageRequest.of(page - 1, 12); // 12 items per page for "View All"
        Page<GroupDeck> deckPage;

        if (isLead) {
            deckPage = groupService.getStatusDecksPaginated(groupId, status, pageable);
        } else {
            if ("APPROVED".equals(status)) {
                deckPage = groupService.getStatusDecksPaginated(groupId, status, pageable);
            } else {
                deckPage = groupService.getStatusMemberDecksPaginated(groupId, status, currentUser.getId(), pageable);
            }
        }

        model.addAttribute("group", group);
        model.addAttribute("listGroupDeck", deckPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", deckPage.getTotalPages());
        model.addAttribute("status", status);
        model.addAttribute("isLeader", isLead);
        model.addAttribute("currentUserId", currentUser.getId());

        return "client/group/decks-view-all";
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
    public String kickMember(@PathVariable Long groupId, @RequestParam Long targetUserId, Principal principal,
            Model model) {
        try {
            groupService.removeMember(groupId, targetUserId, userRepository.findByEmail(principal.getName()));
            return "redirect:/groups/" + groupId;
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return viewGroup(groupId, model, principal);
        }
    }

    @PostMapping("/{groupId}/leave")
    public String leaveGroup(@PathVariable Long groupId, @RequestParam Long targetUserId, Principal principal,
            Model model) {
        try {
            groupService.removeMember(groupId, targetUserId, userRepository.findByEmail(principal.getName()));
            return "redirect:/groups";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return viewGroup(groupId, model, principal);
        }
    }

    // --- GIẢI TÁN NHÓM ---
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

    @PostMapping("/{groupId}/hide-deck")
    public String hideDeck(@PathVariable Long groupId, @RequestParam Long groupDeckId, Principal principal) {
        groupService.hideDeck(groupId, groupDeckId, userRepository.findByEmail(principal.getName()));
        return "redirect:/groups/" + groupId;
    }
}