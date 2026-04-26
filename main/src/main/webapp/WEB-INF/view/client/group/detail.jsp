<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${group.groupName} - English Learning Platform</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="/css/client/group.css">
            <link rel="stylesheet" href="/css/client/head-foot.css">
        </head>

        <body>
            <header class="top-nav">
                <div class="brand">
                    <h1>English Learning Platform</h1>
                    <p>Master English with Interactive Exercises</p>
                </div>
                <div class="nav-links">
                    <a href="/">HOME</a>
                    <a href=" /client/library">FLASHCARD</a>
                </div>

                <c:if test="${empty pageContext.request.userPrincipal}">
                    <div class="login">
                        <a href="/login">Login</a>
                        <span style="color: aliceblue;">-</span>
                        <a href="/client/sign_up">Sign up</a>
                    </div>
                </c:if>



                <c:if test="${not empty pageContext.request.userPrincipal}">
                    <div class="container-info" id="userDropdownTrigger">
                        <i class="fa-regular fa-user"></i>
                        <span class="user-name">
                            <c:out value="${sessionScope.fullName}" />
                        </span>
                        <i class="fa-solid fa-chevron-down mini-arrow"></i>

                        <div class="info-dropdown" id="infoDropdown">

                            <a href="/profile" class="dropdown-item">
                                <i class="fa-solid fa-circle-info"></i>
                                <span>Information</span>
                            </a>
                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                <a href="/admin/user" class="dropdown-item">
                                    <i class="fa-regular fa-user"></i>
                                    <span>Admin</span>
                                </a>
                            </c:if>

                            <form method="post" action="/logout">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <button type="submit" class="dropdown-item"
                                    style="width: 100%; border: 0px none; background-color: white;">
                                    <i class="fa-solid fa-right-from-bracket"></i>
                                    <span>Logout</span>
                                </button>
                            </form>

                        </div>
                    </div>
                </c:if>

            </header>

            <div class="app-container">
                <header class="dashboard-header">
                    <div class="title-area">
                        <h2><i class="fas fa-users"></i> ${group.groupName}</h2>
                        <c:if test="${not empty error}">
                            <p class="error-msg"><i class="fas fa-exclamation-circle"></i> ${error}</p>
                        </c:if>
                    </div>

                    <div class="action-buttons">
                        <c:if test="${isLeader}">
                            <button class="btn btn-primary" onclick="openModal('add-member-popup')">
                                <i class="fas fa-user-plus"></i> Thêm thành viên
                            </button>

                            <form action="/groups/${group.id}/disband" method="post" style="margin: 0;"
                                onsubmit="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn giải tán nhóm này? Toàn bộ dữ liệu thành viên và bài chia sẻ sẽ bị xóa VĨNH VIỄN!');">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-trash-alt"></i> Giải tán nhóm
                                </button>
                            </form>
                        </c:if>
                    </div>
                </header>

                <main class="main-grid">
                    <div class="left-column">

                        <section class="section-card">
                            <h3 class="section-title approved"><i class="fas fa-book-open"
                                    style="color: var(--success)"></i> Thư viện của nhóm</h3>
                            <div class="deck-grid">
                                <c:forEach var="groupDeck" items="${approvedDecks}">
                                    <div class="deck-item approved">
                                        <a href="/client/deck/${groupDeck.deck.id}" class="deck-content">
                                            <h4>${groupDeck.deck.title}</h4>
                                            <p>${groupDeck.deck.des}</p>
                                        </a>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty approvedDecks}">
                                    <p
                                        style="color: var(--text-muted); grid-column: 1 / -1; text-align: center; padding: 20px; font-style: italic;">
                                        Nhóm chưa có bộ flashcard nào được chia sẻ.
                                    </p>
                                </c:if>
                            </div>
                        </section>

                        <c:if test="${not empty pendingDecks}">
                            <section class="section-card pending-section">
                                <h3 class="section-title"><i class="fas fa-hourglass-half"></i> Đang chờ duyệt</h3>
                                <div class="deck-grid">
                                    <c:forEach var="pending" items="${pendingDecks}">
                                        <div class="deck-item pending">
                                            <a href="/client/deck/${pending.deck.id}"
                                                style="color: inherit; text-decoration: none; display: flex; flex-direction: column; flex-grow: 1;">
                                                <div class="deck-content">
                                                    <h4>${pending.deck.title}</h4>
                                                    <p><i class="fas fa-info-circle"></i> Đang chờ Admin nhóm xác nhận.
                                                    </p>
                                                </div>
                                            </a>
                                            <c:if test="${isLeader}">
                                                <div class="deck-footer">
                                                    <form action="/groups/${group.id}/approve-deck" method="post"
                                                        style="margin: 0; flex: 1; display: flex;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <input type="hidden" name="groupDeckId" value="${pending.id}">
                                                        <button type="submit" class="btn-approve">
                                                            <i class="fas fa-check"></i> Duyệt
                                                        </button>
                                                    </form>

                                                    <form action="/groups/${group.id}/reject-deck" method="post"
                                                        style="margin: 0; flex: 1; display: flex;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <input type="hidden" name="groupDeckId" value="${pending.id}">
                                                        <button type="submit" class="btn-reject">
                                                            <i class="fas fa-times"></i> Từ chối
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </section>
                        </c:if>

                        <c:if test="${not empty pendingMemberDecks}">
                            <section class="section-card pending-section">
                                <h3 class="section-title"><i class="fas fa-hourglass-half"></i> Đang chờ duyệt</h3>
                                <div class="deck-grid">
                                    <c:forEach var="pending" items="${pendingMemberDecks}">
                                        <div class="deck-item pending">
                                            <a href="/client/deck/${pending.deck.id}"
                                                style="color: inherit; text-decoration: none; display: flex; flex-direction: column; flex-grow: 1;">
                                                <div class="deck-content">
                                                    <h4>${pending.deck.title}</h4>
                                                    <p><i class="fas fa-info-circle"></i> Đang chờ Admin nhóm xác nhận.
                                                    </p>
                                                </div>
                                            </a>
                                            <c:if test="${isLeader}">
                                                <div class="deck-footer">
                                                    <form action="/groups/${group.id}/approve-deck" method="post"
                                                        style="margin: 0; flex: 1; display: flex;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <input type="hidden" name="groupDeckId" value="${pending.id}">
                                                        <button type="submit" class="btn-approve">
                                                            <i class="fas fa-check"></i> Duyệt
                                                        </button>
                                                    </form>

                                                    <form action="/groups/${group.id}/reject-deck" method="post"
                                                        style="margin: 0; flex: 1; display: flex;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <input type="hidden" name="groupDeckId" value="${pending.id}">
                                                        <button type="submit" class="btn-reject">
                                                            <i class="fas fa-times"></i> Từ chối
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </section>
                        </c:if>

                        <c:choose>
                            <c:when test="${member.groupRole != 'LEADER'}">
                                <c:if test="${not empty rejectedMemberDecks}">
                                    <section class="section-card rejected-section">
                                        <h3 class="section-title"><i class="fas fa-ban"></i> Bài đã bị từ chối</h3>
                                        <div class="deck-grid">
                                            <c:forEach var="rejected" items="${rejectedMemberDecks}">
                                                <div class="deck-item rejected">
                                                    <a href="/client/deck/${rejected.deck.id}"
                                                        style="color: inherit; text-decoration: none;">
                                                        <div class="deck-content">
                                                            <h4>${rejected.deck.title}</h4>
                                                            <p style="color: var(--danger);"><i
                                                                    class="fas fa-exclamation-triangle"></i> Leader đã
                                                                từ chối
                                                                bài viết này.</p>
                                                        </div>
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:if>
                            </c:when>

                            <c:when test="${member.groupRole == 'LEADER'}">
                                <c:if test="${not empty rejectedDecks}">
                                    <section class="section-card rejected-section">
                                        <h3 class="section-title"><i class="fas fa-ban"></i> Bài đã bị từ chối</h3>
                                        <div class="deck-grid">
                                            <c:forEach var="rejected" items="${rejectedDecks}">
                                                <div class="deck-item rejected">
                                                    <a href="/client/deck/${rejected.deck.id}"
                                                        style="color: inherit; text-decoration: none;">
                                                        <div class="deck-content">
                                                            <h4>${rejected.deck.title}</h4>
                                                            <p style="color: var(--danger);"><i
                                                                    class="fas fa-exclamation-triangle"></i> Leader đã
                                                                từ chối
                                                                bài viết này.</p>
                                                        </div>
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:if>
                            </c:when>
                        </c:choose>
                    </div>

                    <div class="right-column">
                        <section class="section-card">
                            <h3 class="section-title"><i class="fas fa-user-friends" style="color: var(--primary)"></i>
                                Thành viên (${members.size()})</h3>
                            <ul class="member-list">
                                <c:forEach var="member" items="${members}">
                                    <li class="member-item">
                                        <div class="member-info">
                                            <div
                                                style="width: 35px; height: 35px; background: #e0e7ff; color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold;">
                                                ${member.user.userName.substring(0, 1).toUpperCase()}
                                            </div>
                                            <span class="member-name">${member.user.userName}</span>
                                            <c:if test="${member.groupRole == 'LEADER'}">
                                                <span class="badge-leader"><i class="fas fa-crown"
                                                        style="margin-right: 3px;"></i> Leader</span>
                                            </c:if>
                                        </div>

                                        <div class="member-actions">
                                            <c:if test="${isLeader && member.groupRole != 'LEADER'}">
                                                <form action="/groups/${group.id}/kick" method="post" style="margin: 0;"
                                                    onsubmit="return confirm('Mời thành viên này ra khỏi nhóm?');">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <input type="hidden" name="targetUserId" value="${member.user.id}">
                                                    <button type="submit" class="btn-icon kick" title="Mời khỏi nhóm">
                                                        <i class="fas fa-user-times"></i>
                                                    </button>
                                                </form>
                                            </c:if>

                                            <c:if test="${!isLeader && member.user.id == currentUserId}">
                                                <form action="/groups/${group.id}/kick" method="post" style="margin: 0;"
                                                    onsubmit="return confirm('Bạn có chắc chắn muốn rời khỏi nhóm này?');">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <input type="hidden" name="targetUserId" value="${member.user.id}">
                                                    <button type="submit" class="btn-icon leave" title="Rời nhóm">
                                                        <i class="fas fa-sign-out-alt"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </section>
                    </div>
                </main>
            </div>

            <div id="add-member-popup" class="modal-overlay">
                <div class="modal-content">
                    <form action="/groups/${group.id}/add-member" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <h3><i class="fas fa-user-plus"></i> Thêm Thành Viên</h3>
                        <div class="form-group">
                            <label>Nhập Email người dùng:</label>
                            <input type="email" name="email" class="form-control" required placeholder="vidu@email.com">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline"
                                onclick="closeModal('add-member-popup')">Hủy</button>
                            <button type="submit" class="btn btn-primary">Thêm vào nhóm</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function openModal(modalId) {
                    document.getElementById(modalId).style.display = 'flex';
                }

                function closeModal(modalId) {
                    document.getElementById(modalId).style.display = 'none';
                }

                // Đóng modal khi click ra ngoài vùng nội dung
                window.onclick = function (event) {
                    if (event.target.classList.contains('modal-overlay')) {
                        event.target.style.display = "none";
                    }
                }
            </script>
            <script src="/js/client/head-foot.js"></script>
        </body>

        </html>