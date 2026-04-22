package com.example.flc.domain.DTO;

import com.example.flc.service.validator.RegisterCheck;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@RegisterCheck
public class SignUp {
    @NotNull
    @Email(message = "Email không hợp lệ", regexp = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")
    private String email;

    @NotNull
    @Size(min = 2, message = "Username phải có tối thiểu 2 kí tự")
    private String userName;
    private String fullName;

    @NotNull
    @Size(min = 2, message = "Password phải có tối thiểu 2 kí tự")
    private String passWord;
    private String rewritePassWord;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public String getRewritePassWord() {
        return rewritePassWord;
    }

    public void setRewritePassWord(String rewritePassWord) {
        this.rewritePassWord = rewritePassWord;
    }

}
