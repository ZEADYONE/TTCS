package com.example.flc.controller.admin;

import java.security.Principal;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.flc.domain.Deck;
import com.example.flc.domain.Role;
import com.example.flc.domain.User;
import com.example.flc.service.RoleService;
import com.example.flc.service.UserService;

import jakarta.validation.Valid;

@Controller
public class UserController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;

    public UserController(UserService userService, PasswordEncoder passwordEncoder, RoleService roleService) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.roleService = roleService;

    }

    @GetMapping("/admin/user")
    public String getHomePage(Model model,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "status", required = false) List<Boolean> status,
            @RequestParam(value = "roleIds", required = false) List<Long> roleIds) {

        Pageable pageable = PageRequest.of(page - 1, 3);
        Page<User> pageUser = this.userService.getUsersWithFilter(keyword, status, roleIds, pageable);

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pageUser.getTotalPages());
        model.addAttribute("listUser", pageUser.getContent());
        model.addAttribute("roles", this.roleService.getAll());

        // model.addAttribute("keyword", keyword);
        // model.addAttribute("selectedStatus", status);
        // model.addAttribute("selectedRoles", roleIds);

        return "admin/user/homepage";
    }

    // DETAIL USER
    @GetMapping("/admin/user/view/{id}")
    public String viewUser(@PathVariable("id") long id, Model model) {
        User user = userService.getUserDetail(id);
        model.addAttribute("user", user);
        return "admin/user/view";
    }

    // CREATE USER
    @RequestMapping("admin/user/create")
    public String getUserPage(Model model) {
        model.addAttribute("newUser", new User());
        // model.addAttribute("roles", this.roleService.getAll());
        model.addAttribute("roles", this.roleService.getAll());
        // List<Role> roles = roleService.getAllRoles();
        // model.addAttribute("roles", roles);
        // Ben homepage
        return "admin/user/create";
    }

    @RequestMapping(value = "admin/user/create", method = RequestMethod.POST)
    public String createUserPage(Model model, @ModelAttribute("newUser") @Valid User newUser,
            BindingResult bindingResult) {

        // ERROR VALID
        List<FieldError> errors = bindingResult.getFieldErrors();
        for (FieldError error : errors) {
            System.out.println(error.getField() + "=>>>>>>>>>>>>>>>>>>>>>>>>> " + error.getDefaultMessage());
        }

        if (bindingResult.hasErrors()) {
            return "admin/user/create";
        }

        // HASH CODE
        String hassPassWord = this.passwordEncoder.encode(newUser.getPassWord());
        newUser.setPassWord(hassPassWord);

        Role role = roleService.getById(newUser.getRole().getId());
        newUser.setRole(role);
        newUser.setStatus(true);
        this.userService.handelSaveUser(newUser);
        return "redirect:/admin/user";
    }

    // UPATE USER

    @GetMapping("/admin/user/update/{id}")
    public String getUserUpdate(@PathVariable("id") long id, Model model) {
        User user = userService.getUserDetail(id);
        model.addAttribute("roles", this.roleService.getAll());
        model.addAttribute("newUser", user);
        return "admin/user/update";
    }

    @PostMapping("/admin/user/update")
    public String postUpdateUser(@ModelAttribute("newUser") User user) {

        user.setRole(roleService.getById(user.getRole().getId()));
        this.userService.handelSaveUser(user);
        return "redirect:/admin/user";
    }

    // STATUS
    @PostMapping("/admin/user/status/{id}")
    public String setUserStatus(@PathVariable("id") long id, Model model) {
        this.userService.setUserStatus(id);
        return "redirect:/admin/user";
    }

    // INFOR
    @GetMapping("/profile")
    public String getInfo(Model model, Principal principal) {

        User user = this.userService.getUserByEmail(principal.getName());
        model.addAttribute("user", user);
        return "admin/user/infor";
    }

    @GetMapping("/profile/edit")
    public String getupdateInfo(Model model, Principal principal) {

        User user = this.userService.getUserByEmail(principal.getName());
        model.addAttribute("user", user);
        return "admin/user/update_infor";
    }

    @PostMapping("/profile/edit")
    public String updateInfo(@ModelAttribute("user") User user, Principal principal) {

        User oldUser = this.userService.getUserByEmail(principal.getName());

        oldUser.setFullName(user.getFullName());
        oldUser.setPhoneNumber(user.getPhoneNumber());
        oldUser.setDateOfBirth(user.getDateOfBirth());
        oldUser.setLocation(user.getLocation());
        oldUser.setBio(user.getBio());
        oldUser.setUserName(user.getUserName());

        this.userService.handelSaveUser(oldUser);

        return "redirect:/profile";
    }
}
