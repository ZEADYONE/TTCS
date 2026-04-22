<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>${group.groupName} - English Learning Platform</title>
            <link rel="stylesheet" href="/css/client/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body>
            <div class="app-container">
                <main class="main-content">
                    <section class="library-section">

                        <div class="library-header"
                            style="border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px;">
                            <div class="title-area">
                                <h2><i class="fas fa-users"></i> ${group.groupName}</h2>
                                <c:if test="${not empty error}">
                                    <p style="color: red; font-weight: bold;"><i class="fas fa-exclamation-circle"></i>
                                        ${error}</p>
                                </c:if>
                            </div>

                            <div style="display: flex; gap: 10px;">
                                <div class="btn-create"
                                    onclick="document.getElementById('submit-deck-popup').style.display='flex'"
                                    style="background: #28a745;">
                                    <span><i class="fas fa-share"></i> Chia sẻ Deck</span>
                                </div>

                                <c:if test="${isLeader}">
                                    <div class="btn-create"
                                        onclick="document.getElementById('add-member-popup').style.display='flex'">
                                        <span><i class="fas fa-user-plus"></i> Thêm thành viên</span>
                                    </div>

                                    <form action="/groups/${group.id}/disband" method="post" style="margin: 0;"
                                        onsubmit="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn giải tán nhóm này? Toàn bộ dữ liệu thành viên và bài chia sẻ sẽ bị xóa VĨNH VIỄN!');">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn-create"
                                            style="background: #dc3545; border: none; cursor: pointer; padding: 10px 15px;">
                                            <span style="color: white;"><i class="fas fa-trash"></i> Giải tán
                                                nhóm</span>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>

                        <div style="display: flex; gap: 30px;">
                            <div style="flex: 2;">
                                <h3 style="margin-bottom: 15px;"><i class="fas fa-book-open"></i> Thư viện của nhóm</h3>
                                <div class="deck-grid">
                                    <c:forEach var="groupDeck" items="${approvedDecks}">
                                        <div class="deck-card">
                                            <a href="/client/deck/${groupDeck.deck.id}">
                                                <div class="card-body" style="padding-top: 15px;">
                                                    <h4>${groupDeck.deck.title}</h4>
                                                    <p>${groupDeck.deck.des}</p>
                                                </div>
                                            </a>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty approvedDecks}">
                                        <p style="color: gray;">Nhóm chưa có bộ flashcard nào được chia sẻ.</p>
                                    </c:if>
                                </div>

                                <c:if test="${isLeader && not empty pendingDecks}">
                                    <h3 style="margin-top: 40px; color: orange;"><i class="fas fa-clock"></i> Chờ duyệt
                                    </h3>
                                    <div class="deck-grid" style="margin-top: 15px;">
                                        <c:forEach var="pending" items="${pendingDecks}">
                                            <div class="deck-card" style="border: 2px dashed orange;">
                                                <div class="card-body" style="padding-top: 15px;">
                                                    <h4>${pending.deck.title}</h4>
                                                </div>
                                                <div class="card-footer" style="background: #fff8e1;">
                                                    <form action="/groups/${group.id}/approve-deck" method="post"
                                                        style="margin: 0; width: 100%;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <input type="hidden" name="groupDeckId" value="${pending.id}">
                                                        <button type="submit"
                                                            style="background: none; border: none; color: #28a745; cursor: pointer; font-weight: bold;">
                                                            <i class="fas fa-check"></i> Duyệt bài này
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>

                            <div style="flex: 1; background: #f9f9f9; padding: 20px; border-radius: 10px;">
                                <h3 style="margin-bottom: 15px;"><i class="fas fa-list-ul"></i> Thành viên
                                    (${members.size()})</h3>
                                <ul style="list-style: none; padding: 0;">
                                    <c:forEach var="member" items="${members}">
                                        <li
                                            style="display: flex; justify-content: space-between; align-items: center; padding: 10px; border-bottom: 1px solid #ddd;">
                                            <div>
                                                <strong>${member.user.userName}</strong>
                                                <c:if test="${member.groupRole == 'LEADER'}">
                                                    <span
                                                        style="font-size: 0.8rem; background: #ffc107; padding: 2px 5px; border-radius: 3px; margin-left: 5px;">Leader</span>
                                                </c:if>
                                            </div>

                                            <c:if test="${isLeader && member.groupRole != 'LEADER'}">
                                                <form action="/groups/${group.id}/kick" method="post" style="margin: 0;"
                                                    onsubmit="return confirm('Mời thành viên này ra khỏi nhóm?');">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <input type="hidden" name="targetUserId" value="${member.user.id}">
                                                    <button type="submit"
                                                        style="background: none; border: none; color: red; cursor: pointer;"
                                                        title="Kick khỏi nhóm">
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
                                                    <button type="submit"
                                                        style="background: none; border: none; color: orange; cursor: pointer;"
                                                        title="Tự rời nhóm">
                                                        <i class="fas fa-sign-out-alt"></i> Rời nhóm
                                                    </button>
                                                </form>
                                            </c:if>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </section>
                </main>
            </div>

            <div id="add-member-popup" class="container-popup" style="display: none;">
                <form class="popup" action="/groups/${group.id}/add-member" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <h3>Thêm Thành Viên</h3>
                    <label>Nhập Email người dùng:</label>
                    <input type="email" name="email" required style="width: 100%; padding: 10px; margin-bottom: 20px;">
                    <div class="popup-buttons">
                        <button type="submit" id="save">Thêm</button>
                        <button type="button"
                            onclick="document.getElementById('add-member-popup').style.display='none'">Hủy</button>
                    </div>
                </form>
            </div>

            <div id="submit-deck-popup" class="container-popup" style="display: none;">
                <form class="popup" action="/groups/${group.id}/submit-deck" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <h3>Chia sẻ Deck vào nhóm</h3>
                    <label>Nhập ID bộ Deck của bạn:</label>
                    <input type="number" name="deckId" required style="width: 100%; padding: 10px; margin-bottom: 20px;"
                        placeholder="Ví dụ: 15">
                    <p style="font-size: 0.9rem; color: gray; margin-bottom: 15px;">* Nếu bạn không phải Leader, bài sẽ
                        cần chờ duyệt.</p>
                    <div class="popup-buttons">
                        <button type="submit" id="save">Chia sẻ</button>
                        <button type="button"
                            onclick="document.getElementById('submit-deck-popup').style.display='none'">Hủy</button>
                    </div>
                </form>
            </div>
        </body>

        </html>