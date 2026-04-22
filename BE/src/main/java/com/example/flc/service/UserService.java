package com.example.flc.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.flc.domain.Role;
import com.example.flc.domain.User;
import com.example.flc.domain.DTO.SignUp;
import com.example.flc.repository.RoleRepository;
import com.example.flc.repository.UserRepository;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public UserService(UserRepository userRepository, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    public List<User> getAllUsers() {
        return this.userRepository.findAll();
    }

    public Page<User> getAllUsers(Pageable pageable) {
        return this.userRepository.findAll(pageable);
    }

    public User handelSaveUser(User user) {
        return this.userRepository.save(user);
    }

    public User getUserDetail(long id) {
        return this.userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    public void setUserStatus(long id) {
        User user = this.userRepository.findById(id).orElseThrow(() -> new RuntimeException());
        if (user.getStatus()) {
            user.setStatus(false);
        } else {
            user.setStatus(true);
        }
        handelSaveUser(user);
        return;
    }

    public Role getRoleByName(String name) {
        return this.roleRepository.findByName(name).orElseThrow(() -> new RuntimeException());
    }

    // TRANSFER
    public User signUpDtoToUser(SignUp signup) {
        User user = new User();
        user.setFullName(signup.getFullName());
        user.setPassWord(signup.getPassWord());
        user.setEmail(signup.getEmail());
        user.setUserName(signup.getUserName());
        return user;
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public boolean checkEmailExits(String email) {
        return this.userRepository.existsByEmail(email);
    }

    public boolean checkUserNameExits(String userName) {
        return this.userRepository.existsByUserName(userName);
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id).orElseThrow(() -> new RuntimeException());
    }

    public Page<User> getUsersWithFilter(String keyword, List<Boolean> status, List<Long> roleIds, Pageable pageable) {
        String searchKeyword = (keyword != null && !keyword.isEmpty()) ? keyword : null;
        List<Boolean> statusFilter = (status != null && !status.isEmpty()) ? status : null;
        List<Long> roleFilter = (roleIds != null && !roleIds.isEmpty()) ? roleIds : null;

        return userRepository.findWithFilter(searchKeyword, statusFilter, roleFilter, pageable);
    }
}
