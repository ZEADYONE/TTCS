package com.example.flc.controller.client;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.example.flc.domain.User;
import com.example.flc.domain.DTO.Login;
import com.example.flc.domain.DTO.SignUp;
import com.example.flc.service.UserService;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class LandingPageController {
    private UserService userService;
    private final PasswordEncoder passwordEncoder;

    public LandingPageController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/")
    public String getHome() {
        return "client/homepage";
    }

    // LOGIN
    @GetMapping("/login")
    public String getLoginPage(Model model) {
        model.addAttribute("loginUser", new Login());
        return "client/auth/login";
    }

    @GetMapping("/client/homepage")
    public String getHomePage() {
        return "client/homepage";
    }

    // SIGNUP
    @GetMapping("/client/sign_up")
    public String getSignUpPage(Model model) {
        model.addAttribute("newUser", new SignUp());
        return "client/auth/sign_up";
    }

    @PostMapping("/client/sign_up")
    public String setSignPage(@ModelAttribute("newUser") @Valid SignUp newUser, BindingResult bindingResult) {
        // List<FieldError> errors = bindingResult.getFieldErrors();
        // for (FieldError error : errors) {
        // System.out.println(error.getField() + "=>>>>>>>>>>>>>>>>>>>>>>>>> " +
        // error.getDefaultMessage());
        // }
        if (bindingResult.hasErrors()) {
            return "client/auth/sign_up";
        }

        User user = this.userService.signUpDtoToUser(newUser);

        String hassPassWord = this.passwordEncoder.encode(user.getPassWord());
        user.setPassWord(hassPassWord);
        user.setStatus(true);
        this.userService.handelSaveUser(user);
        return "redirect:/client/login";
    }

    @GetMapping("/access-deny")
    public String getDenyPage() {
        return "client/auth/access-deny";
    }

}
