package com.example.flc.controller.client;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.flc.domain.Deck;
import com.example.flc.domain.Role;
import com.example.flc.service.RoleService;

@Controller
public class RoleController {

    private final RoleService roleService;

    public RoleController(RoleService roleService) {
        this.roleService = roleService;
    }

    @GetMapping("/admin/role")
    public String viewRole(Model model,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "1") int page) {
        model.addAttribute("role", new Role()); // phải có dòng này

        Pageable pageable = PageRequest.of(page - 1, 3);
        // Truyền tham số scope vào service
        Page<Role> pageRole = this.roleService.getAllFilter(pageable, keyword);

        model.addAttribute("roles", pageRole.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageRole.getTotalPages());

        model.addAttribute("keyword", keyword);

        return "admin/role/role";
    }

    @PostMapping("/admin/role/create")
    public String createRole(@ModelAttribute("role") Role role) {
        this.roleService.handleSave(role);
        return "redirect:/admin/role";
    }
}
