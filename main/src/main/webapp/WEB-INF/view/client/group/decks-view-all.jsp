<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tất cả bộ flashcard ${status} - ${group.groupName}</title>
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
                    <a href="/client/library">FLASHCARD</a>
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
                        <h2>
                            <a href="/groups/${group.id}" style="color: inherit; text-decoration: none;">
                                <i class="fas fa-arrow-left" style="margin-right: 10px;"></i>
                            </a>
                            <i class="fas fa-users"></i> ${group.groupName} - Danh sách bộ flashcard (${status})
                        </h2>
                    </div>
                </header>

                <main class="main-grid" style="grid-template-columns: 1fr;">
                    <div class="left-column">
                        <section
                            class="section-card ${status == 'PENDING' ? 'pending-section' : (status == 'REJECTED' ? 'rejected-section' : '')}">
                            <div class="deck-grid"
                                style="grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px;">
                                <c:forEach var="groupDeck" items="${listGroupDeck}">
                                    <div class="deck-item ${status == 'PENDING' ? 'pending' : (status == 'REJECTED' ? 'rejected' : 'approved')}"
                                        style="display: flex; flex-direction: column;">
                                        <a href="/client/deck/${groupDeck.deck.id}"
                                            style="color: inherit; text-decoration: none; display: flex; flex-direction: column; flex-grow: 1;">
                                            <div class="deck-content">
                                                <h4>${groupDeck.deck.title}</h4>
                                                <p>
                                                    <c:choose>
                                                        <c:when test="${status == 'PENDING'}">
                                                            <i class="fas fa-info-circle"></i> Đang chờ Admin nhóm xác
                                                            nhận.
                                                        </c:when>
                                                        <c:when test="${status == 'REJECTED'}">
                                                            <span style="color: var(--danger);"><i
                                                                    class="fas fa-exclamation-triangle"></i> Leader đã
                                                                từ chối bài viết này.</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${groupDeck.deck.des}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </a>

                                        <c:if test="${isLeader}">
                                            <div class="deck-footer">
                                                <c:choose>
                                                    <c:when test="${status == 'PENDING'}">
                                                        <form action="/groups/${group.id}/approve-deck" method="post"
                                                            style="margin: 0; flex: 1; display: flex;">
                                                            <input type="hidden" name="${_csrf.parameterName}"
                                                                value="${_csrf.token}" />
                                                            <input type="hidden" name="groupDeckId"
                                                                value="${groupDeck.id}">
                                                            <button type="submit" class="btn-approve">
                                                                <i class="fas fa-check"></i> Duyệt
                                                            </button>
                                                        </form>

                                                        <form action="/groups/${group.id}/reject-deck" method="post"
                                                            style="margin: 0; flex: 1; display: flex;">
                                                            <input type="hidden" name="${_csrf.parameterName}"
                                                                value="${_csrf.token}" />
                                                            <input type="hidden" name="groupDeckId"
                                                                value="${groupDeck.id}">
                                                            <button type="submit" class="btn-reject">
                                                                <i class="fas fa-times"></i> Từ chối
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${status == 'APPROVED'}">
                                                        <form action="/groups/${group.id}/hide-deck" method="post"
                                                            style="margin: 0; flex: 1; display: flex;">
                                                            <input type="hidden" name="${_csrf.parameterName}"
                                                                value="${_csrf.token}" />
                                                            <input type="hidden" name="groupDeckId"
                                                                value="${groupDeck.id}">
                                                            <button type="submit" class="btn-reject"
                                                                style="width: 100%; justify-content: center;"
                                                                onclick="return confirm('Bạn có chắc chắn muốn ẩn deck này khỏi nhóm?');">
                                                                <i class="fas fa-eye-slash"></i> Ẩn
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty listGroupDeck}">
                                    <p
                                        style="color: var(--text-muted); grid-column: 1 / -1; text-align: center; padding: 20px; font-style: italic;">
                                        Không có dữ liệu.
                                    </p>
                                </c:if>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="pagination"
                                    style="display: flex; justify-content: center; margin-top: 30px; gap: 10px;">
                                    <c:if test="${currentPage > 1}">
                                        <a href="/groups/${group.id}/decks?status=${status}&page=${currentPage - 1}"
                                            class="btn btn-outline" style="padding: 5px 15px;">&laquo; Trang trước</a>
                                    </c:if>

                                    <span style="padding: 5px 15px; font-weight: bold;">
                                        Trang ${currentPage} / ${totalPages}
                                    </span>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="/groups/${group.id}/decks?status=${status}&page=${currentPage + 1}"
                                            class="btn btn-outline" style="padding: 5px 15px;">Trang sau &raquo;</a>
                                    </c:if>
                                </div>
                            </c:if>

                        </section>
                    </div>
                </main>
            </div>

            <script src="/js/client/head-foot.js"></script>
        </body>

        </html>