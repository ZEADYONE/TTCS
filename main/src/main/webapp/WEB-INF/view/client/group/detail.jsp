<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${group.groupName} - English Learning Platform</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <style>
                /* CSS Reset & Variables */
                :root {
                    --primary: #4361ee;
                    --success: #28a745;
                    --danger: #dc3545;
                    --warning: #ffc107;
                    --warning-dark: #f39c12;
                    --bg-color: #f4f7f6;
                    --card-bg: #ffffff;
                    --text-main: #333333;
                    --text-muted: #6c757d;
                    --border-color: #e0e0e0;
                }

                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background-color: var(--bg-color);
                    color: var(--text-main);
                    line-height: 1.6;
                }

                /* Container & Layout */
                .app-container {
                    max-width: 1200px;
                    margin: 30px auto;
                    padding: 0 20px;
                }

                .dashboard-header {
                    background: var(--card-bg);
                    padding: 20px 25px;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 25px;
                }

                .title-area h2 {
                    font-size: 1.8rem;
                    color: var(--primary);
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .error-msg {
                    color: var(--danger);
                    font-weight: 600;
                    margin-top: 5px;
                    font-size: 0.9rem;
                }

                .action-buttons {
                    display: flex;
                    gap: 12px;
                }

                /* Buttons */
                .btn {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 10px 18px;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    border: none;
                    color: white;
                    transition: all 0.2s ease;
                    text-decoration: none;
                    font-size: 0.95rem;
                }

                .btn-success {
                    background: var(--success);
                }

                .btn-success:hover {
                    background: #218838;
                }

                .btn-primary {
                    background: var(--primary);
                }

                .btn-primary:hover {
                    background: #3a53d0;
                }

                .btn-danger {
                    background: var(--danger);
                }

                .btn-danger:hover {
                    background: #c82333;
                }

                /* Main Content Grid */
                .main-grid {
                    display: grid;
                    grid-template-columns: 2fr 1fr;
                    gap: 25px;
                }

                /* Section Styling */
                .section-card {
                    background: var(--card-bg);
                    border-radius: 12px;
                    padding: 25px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                    margin-bottom: 25px;
                }

                .section-title {
                    font-size: 1.3rem;
                    margin-bottom: 20px;
                    padding-bottom: 10px;
                    border-bottom: 2px solid var(--border-color);
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .section-title.approved i {
                    color: var(--success);
                }

                .section-title.pending {
                    color: var(--warning-dark);
                    border-bottom-color: #ffe8b3;
                }

                .section-title.pending i {
                    color: var(--warning-dark);
                }

                /* Deck Grid & Cards */
                .deck-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                    gap: 20px;
                }

                .deck-item {
                    background: #fff;
                    border: 1px solid var(--border-color);
                    border-radius: 10px;
                    overflow: hidden;
                    transition: transform 0.2s, box-shadow 0.2s;
                    display: flex;
                    flex-direction: column;
                }

                .deck-item:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
                }

                .deck-item.approved {
                    border-top: 4px solid var(--success);
                }

                .deck-item.pending {
                    border: 2px dashed var(--warning-dark);
                    background: #fffcf5;
                }

                .deck-content {
                    padding: 20px;
                    flex-grow: 1;
                    text-decoration: none;
                    color: inherit;
                }

                .deck-content h4 {
                    font-size: 1.1rem;
                    margin-bottom: 8px;
                    color: var(--text-main);
                }

                .deck-content p {
                    color: var(--text-muted);
                    font-size: 0.9rem;
                    display: -webkit-box;
                    -webkit-line-clamp: 3;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                .deck-footer {
                    background: #f8f9fa;
                    padding: 12px 20px;
                    border-top: 1px solid var(--border-color);
                    text-align: right;
                }

                .deck-item.pending .deck-footer {
                    background: #fff3cd;
                    border-top: 1px solid #ffeeba;
                }

                .btn-approve {
                    background: none;
                    border: none;
                    color: var(--success);
                    font-weight: 700;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    gap: 5px;
                    margin-left: auto;
                }

                .btn-approve:hover {
                    color: #218838;
                    text-decoration: underline;
                }

                /* Members List */
                .member-list {
                    list-style: none;
                }

                .member-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 12px 15px;
                    border-bottom: 1px solid var(--border-color);
                    transition: background 0.2s;
                }

                .member-item:hover {
                    background: #f8f9fa;
                }

                .member-item:last-child {
                    border-bottom: none;
                }

                .member-info {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .member-name {
                    font-weight: 600;
                    color: var(--text-main);
                }

                .badge-leader {
                    background: var(--warning);
                    color: #000;
                    font-size: 0.75rem;
                    padding: 3px 8px;
                    border-radius: 12px;
                    font-weight: bold;
                }

                .btn-icon {
                    background: none;
                    border: none;
                    cursor: pointer;
                    font-size: 1.1rem;
                    padding: 5px;
                    transition: transform 0.2s;
                }

                .btn-icon.kick {
                    color: var(--danger);
                }

                .btn-icon.leave {
                    color: var(--warning-dark);
                }

                .btn-icon:hover {
                    transform: scale(1.2);
                }

                /* Modals / Popups */
                .modal-overlay {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    align-items: center;
                    justify-content: center;
                    z-index: 1000;
                    backdrop-filter: blur(3px);
                }

                .modal-content {
                    background: var(--card-bg);
                    padding: 30px;
                    border-radius: 12px;
                    width: 100%;
                    max-width: 400px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                    animation: slideDown 0.3s ease-out;
                }

                @keyframes slideDown {
                    from {
                        transform: translateY(-20px);
                        opacity: 0;
                    }

                    to {
                        transform: translateY(0);
                        opacity: 1;
                    }
                }

                .modal-content h3 {
                    margin-bottom: 20px;
                    color: var(--text-main);
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 500;
                }

                .form-control {
                    width: 100%;
                    padding: 10px 15px;
                    border: 1px solid var(--border-color);
                    border-radius: 6px;
                    font-size: 1rem;
                }

                .form-control:focus {
                    outline: none;
                    border-color: var(--primary);
                    box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
                }

                .modal-footer {
                    display: flex;
                    gap: 10px;
                    justify-content: flex-end;
                }

                .btn-outline {
                    background: transparent;
                    border: 1px solid var(--border-color);
                    color: var(--text-main);
                }

                .btn-outline:hover {
                    background: #f8f9fa;
                }

                .helper-text {
                    font-size: 0.85rem;
                    color: var(--text-muted);
                    margin-top: 5px;
                }

                /* Responsive */
                @media (max-width: 900px) {
                    .main-grid {
                        grid-template-columns: 1fr;
                    }

                    .dashboard-header {
                        flex-direction: column;
                        align-items: flex-start;
                        gap: 15px;
                    }

                    .action-buttons {
                        flex-wrap: wrap;
                    }
                }
            </style>
        </head>

        <body>
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
                                    <i class="fas fa-trash"></i> Giải tán nhóm
                                </button>
                            </form>
                        </c:if>
                    </div>
                </header>

                <main class="main-grid">

                    <div class="left-column">

                        <section class="section-card">
                            <h3 class="section-title approved"><i class="fas fa-book-open"></i> Thư viện của nhóm</h3>
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
                                        style="color: var(--text-muted); grid-column: 1 / -1; text-align: center; padding: 20px;">
                                        Nhóm chưa có bộ flashcard nào được chia sẻ.
                                    </p>
                                </c:if>
                            </div>
                        </section>

                        <c:if test="${not empty pendingDecks}">
                            <section class="section-card" style="background-color: #fffcf5; border: 1px solid #ffe8b3;">
                                <h3 class="section-title pending"><i class="fas fa-clock"></i> Đang chờ duyệt</h3>
                                <div class="deck-grid">
                                    <c:forEach var="pending" items="${pendingDecks}">
                                        <div class="deck-item pending">
                                            <a href="/client/deck/${pending.deck.id}"
                                                style="color: inherit; text-decoration: none;">
                                                <div class="deck-content">
                                                    <h4>${pending.deck.title}</h4>
                                                    <p>Đang chờ Admin nhóm xác nhận.</p>
                                                </div>
                                            </a>

                                            <c:if test="${isLeader}">
                                                <div class="deck-footer">
                                                    <form action="/groups/${group.id}/approve-deck" method="post"
                                                        style="margin: 0;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <input type="hidden" name="groupDeckId" value="${pending.id}">
                                                        <button type="submit" class="btn-approve">
                                                            <i class="fas fa-check-circle"></i> Duyệt bài này
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </section>
                        </c:if>

                    </div>

                    <div class="right-column">
                        <section class="section-card">
                            <h3 class="section-title"><i class="fas fa-list-ul"></i> Thành viên (${members.size()})</h3>
                            <ul class="member-list">
                                <c:forEach var="member" items="${members}">
                                    <li class="member-item">
                                        <div class="member-info">
                                            <span class="member-name">${member.user.userName}</span>
                                            <c:if test="${member.groupRole == 'LEADER'}">
                                                <span class="badge-leader">Leader</span>
                                            </c:if>
                                        </div>

                                        <div class="member-actions">
                                            <c:if test="${isLeader && member.groupRole != 'LEADER'}">
                                                <form action="/groups/${group.id}/kick" method="post" style="margin: 0;"
                                                    onsubmit="return confirm('Mời thành viên này ra khỏi nhóm?');">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <input type="hidden" name="targetUserId" value="${member.user.id}">
                                                    <button type="submit" class="btn-icon kick" title="Kick khỏi nhóm">
                                                        <i class="fas fa-user-minus"></i>
                                                    </button>
                                                </form>
                                            </c:if>

                                            <c:if test="${!isLeader && member.user.id == currentUserId}">
                                                <form action="/groups/${group.id}/kick" method="post" style="margin: 0;"
                                                    onsubmit="return confirm('Bạn có chắc chắn muốn rời khỏi nhóm này?');">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <input type="hidden" name="targetUserId" value="${member.user.id}">
                                                    <button type="submit" class="btn-icon leave" title="Tự rời nhóm">
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
                            <button type="submit" class="btn btn-primary">Thêm</button>
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
        </body>

        </html>