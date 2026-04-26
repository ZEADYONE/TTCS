package com.example.flc.controller.admin;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.flc.domain.StudyGroup;
import com.example.flc.domain.User;
import com.example.flc.domain.DTO.AdminGroupDTO;
import com.example.flc.repository.UserRepository;
import com.example.flc.service.GroupService;

@Controller
@RequestMapping("/admin/groups")
public class AdminGroupController {

    @Autowired
    private GroupService groupService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public String listGroups(Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(required = false) String keyword) {

        Pageable pageable = PageRequest.of(page - 1, 6); // 6 items per page
        Page<AdminGroupDTO> groupPage = groupService.getAdminGroups(keyword, pageable);

        model.addAttribute("groups", groupPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", groupPage.getTotalPages());
        model.addAttribute("keyword", keyword);

        return "admin/group/list";
    }

    @PostMapping("/create")
    public String createGroup(@RequestParam String groupName, @RequestParam(required = false) String description,
            Principal principal) {
        User admin = userRepository.findByEmail(principal.getName());
        groupService.createGroup(groupName, description, admin);
        return "redirect:/admin/groups";
    }

    @PostMapping("/update")
    public String updateGroup(@RequestParam Long groupId, @RequestParam String groupName,
            @RequestParam(required = false) String description) {
        groupService.updateGroup(groupId, groupName, description);
        return "redirect:/admin/groups";
    }

    @PostMapping("/delete")
    public String deleteGroup(@RequestParam Long groupId, Principal principal) {
        try {
            groupService.disbandGroup(groupId, userRepository.findByEmail(principal.getName()));
        } catch (Exception e) {
            // Log or handle error
        }
        return "redirect:/admin/groups";
    }

    @GetMapping("/{groupId}")
    public String viewGroupAsAdmin(@PathVariable Long groupId, Model model, Principal principal) {
        User currentUser = userRepository.findByEmail(principal.getName());
        StudyGroup group = groupService.getGroupById(groupId);

        model.addAttribute("group", group);
        model.addAttribute("members", groupService.getMembers(groupId));
        model.addAttribute("approvedDecks", groupService.getStatusDecks(groupId, "APPROVED"));
        model.addAttribute("isLeader", true); // Bỏ qua check, ép luôn là true để view có full action
        model.addAttribute("currentUserId", currentUser.getId());
        model.addAttribute("pendingDecks", groupService.getStatusDecks(groupId, "PENDING"));
        model.addAttribute("rejectedDecks", groupService.getStatusDecks(groupId, "REJECTED"));

        return "client/group/detail"; // Tận dụng lại giao diện detail của client
    }
}
