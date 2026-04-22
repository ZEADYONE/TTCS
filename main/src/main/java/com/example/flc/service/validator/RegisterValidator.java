package com.example.flc.service.validator;

import org.springframework.stereotype.Service;

import com.example.flc.domain.DTO.SignUp;
import com.example.flc.service.UserService;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

@Service
public class RegisterValidator implements ConstraintValidator<RegisterCheck, SignUp> {

    private final UserService userService;

    public RegisterValidator(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean isValid(SignUp user, ConstraintValidatorContext context) {
        boolean valid = true;

        if (!user.getPassWord().equals(user.getRewritePassWord())) {
            context.buildConstraintViolationWithTemplate("Password không khớp")
                    .addPropertyNode("rewritePassWord")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();

            valid = false;
        }

        if (this.userService.checkEmailExits(user.getEmail())) {
            context.buildConstraintViolationWithTemplate("Email đã tồn tại")
                    .addPropertyNode("email")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();

            valid = false;
        }

        if (this.userService.checkUserNameExits(user.getUserName())) {
            context.buildConstraintViolationWithTemplate("UserName đã tồn tại")
                    .addPropertyNode("userName")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();

            valid = false;
        }
        return valid;
    }

}
