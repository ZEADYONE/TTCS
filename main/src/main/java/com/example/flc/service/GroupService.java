package com.example.flc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;

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

    // --- HÀM KIỂM TRA QUYỀN LEADER ---
    // --- HÀM KIỂM TRA QUYỀN LEADER ---
    public boolean checkIsLeader(Long groupId, User user) {
        List<GroupMember> members = memberRepo.findByGroupId(groupId);
        for (GroupMember m : members) {
            // Vì id là kiểu nguyên thủy (long), dùng toán tử == là chuẩn nhất!
            if (m.getUser().getId() == user.getId() && "LEADER".equals(m.getGroupRole())) {
                return true;
            }
        }
        return false;
    }

    @Transactional
    public StudyGroup createGroup(String name, User creator) {
        StudyGroup group = new StudyGroup();
        group.setGroupName(name);
        group = groupRepo.save(group); // Đã bỏ group.setLead()

        // Người tạo tự động là LEADER
        GroupMember member = new GroupMember();
        member.setGroup(group);
        member.setGroupRole("LEADER");
        member.setUser(creator);
        memberRepo.save(member);

        return group;
    }

    @Transactional
    public void addMemberByEmail(Long groupId, String email, User currentUser) throws Exception {
        StudyGroup group = groupRepo.findById(groupId).orElseThrow();

        if (!checkIsLeader(groupId, currentUser)) {
            throw new Exception("Chỉ Trưởng nhóm mới có quyền thêm thành viên.");
        }

        User newMember = userRepo.findByEmail(email);
        if (newMember == null) {
            throw new Exception("Không tìm thấy người dùng với email này.");
        }

        if (memberRepo.existsByGroupAndUser(group, newMember)) {
            throw new Exception("Người dùng đã tham gia nhóm.");
        }

        GroupMember member = new GroupMember();
        member.setGroup(group);
        member.setGroupRole("MEMBER");
        member.setUser(newMember);
        memberRepo.save(member);
    }

    @Transactional
    public void removeMember(Long groupId, Long targetUserId, User currentUser) throws Exception {
        StudyGroup group = groupRepo.findById(groupId).orElseThrow();

        boolean isLead = checkIsLeader(groupId, currentUser);

        // Convert currentUser.getId() sang Long nếu nó đang là Integer để dùng
        // .equals()
        Long currentId = currentUser.getId();
        boolean isSelfLeaving = targetUserId.equals(currentId);

        // Chặn Leader tự rời nhóm
        if (isSelfLeaving && isLead) {
            throw new Exception("Trưởng nhóm không thể tự rời nhóm. Xin hãy sử dụng chức năng Giải tán nhóm.");
        }

        if (isLead || isSelfLeaving) {
            // Lấy User ra để xóa (Giả định UserRepository có findById kiểu Long/Integer
            // tương ứng)
            User targetUser = userRepo.findById(targetUserId).orElseThrow();
            memberRepo.deleteByGroupAndUser(group, targetUser);
        } else {
            throw new Exception("Bạn không có quyền kick thành viên này.");
        }
    }

    // --- TÍNH NĂNG MỚI: GIẢI TÁN NHÓM ---
    @Transactional
    public void disbandGroup(Long groupId, User currentUser) throws Exception {
        if (!checkIsLeader(groupId, currentUser)) {
            throw new Exception("Chỉ Trưởng nhóm mới có quyền giải tán nhóm.");
        }

        StudyGroup group = groupRepo.findById(groupId).orElseThrow();

        // 1. Xóa toàn bộ Deck trong nhóm (Tránh lỗi khóa ngoại)
        List<GroupDeck> approvedDecks = groupDeckRepo.findByGroupIdAndIsApprovedTrue(groupId);
        List<GroupDeck> pendingDecks = groupDeckRepo.findByGroupIdAndIsApprovedFalse(groupId);
        groupDeckRepo.deleteAll(approvedDecks);
        groupDeckRepo.deleteAll(pendingDecks);

        // 2. Xóa toàn bộ Member trong nhóm
        List<GroupMember> members = memberRepo.findByGroupId(groupId);
        memberRepo.deleteAll(members);

        // 3. Xóa Nhóm
        groupRepo.delete(group);
    }

    @Transactional
    public void submitDeckToGroup(Long groupId, Long deckId, User currentUser) {
        StudyGroup group = groupRepo.findById(groupId).orElseThrow();
        Deck deck = deckRepo.findById(deckId).orElseThrow(() -> new RuntimeException("Không tìm thấy deck"));

        if (!memberRepo.existsByGroupAndUser(group, currentUser)) {
            throw new RuntimeException("Bạn phải tham gia nhóm mới được chia sẻ bài.");
        }

        GroupDeck gd = new GroupDeck();
        gd.setGroup(group);
        gd.setDeck(deck);

        boolean isLead = checkIsLeader(groupId, currentUser);
        gd.setIsApproved(isLead);

        groupDeckRepo.save(gd);
    }

    @Transactional
    public void approveDeck(Long groupId, Long groupDeckId, User currentUser) {
        if (!checkIsLeader(groupId, currentUser)) {
            throw new RuntimeException("Chỉ Trưởng nhóm mới có quyền duyệt.");
        }
        GroupDeck gd = groupDeckRepo.findById(groupDeckId).orElseThrow();
        gd.setIsApproved(true);
        groupDeckRepo.save(gd);
    }

    // --- Các hàm lấy dữ liệu View ---
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