package com.example.flc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.flc.domain.Deck;
import com.example.flc.domain.GroupDeck;
import com.example.flc.domain.GroupMember;
import com.example.flc.domain.StudyGroup;
import com.example.flc.domain.User;
import com.example.flc.repository.DeckRepository;
import com.example.flc.repository.GroupDeckRepository;
import com.example.flc.repository.GroupMemberRepository;
import com.example.flc.repository.StudyGroupRepository;
import com.example.flc.repository.UserRepository;

import jakarta.transaction.Transactional;

@Service
public class GroupService {

    @Autowired
    private StudyGroupRepository groupRepo;
    @Autowired
    private GroupMemberRepository memberRepo;
    @Autowired
    private GroupDeckRepository groupDeckRepo;
    @Autowired
    private UserRepository userRepo;
    @Autowired
    private DeckRepository deckRepo;

    @Transactional
    public StudyGroup createGroup(String name, User lead) {
        StudyGroup group = new StudyGroup();
        group.setGroupName(name);
        group.setLead(lead);
        group = groupRepo.save(group);

        // Lead tự động là thành viên đầu tiên
        GroupMember member = new GroupMember();
        member.setGroup(group);
        member.setUser(lead);
        memberRepo.save(member);

        return group;
    }

    @Transactional
    public void addMemberByEmail(Long groupId, String email, User currentUser) throws Exception {
        StudyGroup group = groupRepo.findById(groupId).orElseThrow();

        // Kiểm tra quyền Lead
        if (!(group.getLead().getId() == currentUser.getId())) {
            throw new Exception("Chỉ Lead mới có quyền thêm thành viên.");
        }

        User newMember = userRepo.findByEmail(email);

        if (memberRepo.existsByGroupAndUser(group, newMember)) {
            throw new Exception("Người dùng đã tham gia nhóm.");
        }

        GroupMember member = new GroupMember();
        member.setGroup(group);
        member.setUser(newMember);
        memberRepo.save(member);
    }

    @Transactional
    public void removeMember(Long groupId, Long targetUserId, User currentUser) {
        StudyGroup group = groupRepo.findById(groupId).orElseThrow();

        boolean isLead = group.getLead().getId() == currentUser.getId();
        boolean isSelfLeaving = targetUserId == currentUser.getId();

        if (isLead || isSelfLeaving) {
            User targetUser = userRepo.findById(targetUserId).orElseThrow();
            memberRepo.deleteByGroupAndUser(group, targetUser);
        } else {
            throw new RuntimeException("Bạn không có quyền kick thành viên này.");
        }
    }

    @Transactional
    public void submitDeckToGroup(Long groupId, Long deckId, User currentUser) {
        StudyGroup group = groupRepo.findById(groupId).orElseThrow();
        Deck deck = deckRepo.findById(deckId).orElseThrow(() -> new RuntimeException(" Khong tim thay deck"));

        if (!memberRepo.existsByGroupAndUser(group, currentUser)) {
            throw new RuntimeException("Bạn phải tham gia nhóm mới được chia sẻ bài.");
        }

        GroupDeck gd = new GroupDeck();
        gd.setGroup(group);
        gd.setDeck(deck);

        // Nếu Lead share thì duyệt luôn, Member share thì cờ duyệt là false
        boolean isLead = group.getLead().getId() == currentUser.getId();
        gd.setIsApproved(isLead);

        groupDeckRepo.save(gd);
    }

    @Transactional
    public void approveDeck(Long groupId, Long groupDeckId, User currentUser) {
        StudyGroup group = groupRepo.findById(groupId).orElseThrow();

        if (!(group.getLead().getId() == currentUser.getId())) {
            throw new RuntimeException("Chỉ Lead mới có quyền duyệt.");
        }

        GroupDeck gd = groupDeckRepo.findById(groupDeckId).orElseThrow();
        gd.setIsApproved(true);
        groupDeckRepo.save(gd);
    }

    // --- Các hàm lấy dữ liệu ---
    public List<StudyGroup> getMyGroups(User user) {
        return memberRepo.findGroupsByUser(user);
    }

    public StudyGroup getGroupById(Long id) {
        return groupRepo.findById(id).orElseThrow();
    }

    public List<GroupMember> getMembers(Long groupId) {
        return memberRepo.findByGroupId(groupId);
    }

    public List<GroupDeck> getApprovedDecks(Long groupId) {
        return groupDeckRepo.findByGroupIdAndIsApprovedTrue(groupId);
    }

    public List<GroupDeck> getPendingDecks(Long groupId) {
        return groupDeckRepo.findByGroupIdAndIsApprovedFalse(groupId);
    }
}