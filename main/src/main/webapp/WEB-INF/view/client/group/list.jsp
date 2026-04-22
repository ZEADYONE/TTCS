<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>English Learning Platform - Study Groups</title>
                <link rel="stylesheet" href="/css/client/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                    <div class="container-info" id="userDropdownTrigger">
                        <i class="fa-regular fa-user"></i>
                        <span class="user-name">
                            <c:out value="${sessionScope.fullName}" />
                        </span>
                        <i class="fa-solid fa-chevron-down mini-arrow"></i>
                        <div class="info-dropdown" id="infoDropdown">
                            <a href="/profile" class="dropdown-item">
                                <i class="fa-solid fa-circle-info"></i><span>Information</span>
                            </a>
                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                <a href="/admin/user" class="dropdown-item">
                                    <i class="fa-regular fa-user"></i><span>Admin</span>
                                </a>
                            </c:if>
                            <form method="post" action="/logout">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="dropdown-item"
                                    style="width: 100%; border: 0; background-color: white;">
                                    <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </header>

                <div class="app-container">
                    <aside class="sidebar">
                        <div class="logo-section">
                            <i class="fas fa-layer-group main-logo"></i>
                        </div>
                        <nav class="side-nav">
                            <a href="/client/community" class="nav-item">
                                <i class="fas fa-users"></i><span>Community<small>Chia sẻ flashcard</small></span>
                            </a>
                            <a href="/client/library" class="nav-item">
                                <i class="fas fa-book-open"></i><span>My Library<small>FlashCard của bạn</small></span>
                            </a>
                            <a href="/client/course" class="nav-item">
                                <i class="fas fa-graduation-cap"></i><span>Course <small>Từ Admin</small></span>
                            </a>
                            <a href="/groups" class="nav-item active"
                                style="background: rgba(0,0,0,0.05); border-left: 4px solid var(--primary-color);">
                                <i class="fas fa-user-group"></i><span>Study Groups <small>Nhóm học tập</small></span>
                            </a>
                        </nav>
                    </aside>

                    <main class="main-content">
                        <section class="library-section">
                            <div class="library-header">
                                <div class="title-area">
                                    <h2>My Study Groups</h2>
                                    <p>Join communities and share your flashcards</p>
                                </div>
                                <div class="btn-create"
                                    onclick="document.getElementById('container-popup').style.display='flex'">
                                    <span><i class="fas fa-plus"></i> Create Group</span>
                                </div>
                            </div>

                            <div class="deck-grid">
                                <c:forEach var="studyGroup" items="${myGroups}">
                                    <div class="deck-card">
                                        <a href="/groups/${studyGroup.id}"
                                            style="text-decoration: none; color: inherit;">
                                            <div class="card-body" style="padding-top: 20px;">
                                                <h3><i class="fas fa-users"
                                                        style="color: #4a90e2; margin-right: 10px;"></i>
                                                    ${studyGroup.groupName}</h3>
                                                <p>Tham gia từ: ${studyGroup.createdAt}</p>
                                            </div>
                                            <div class="card-footer">
                                                <span>Vào nhóm <i class="fas fa-arrow-right"></i></span>
                                            </div>
                                        </a>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty myGroups}">
                                    <p style="color: gray;">Bạn chưa tham gia nhóm nào. Hãy tạo nhóm mới!</p>
                                </c:if>
                            </div>
                        </section>
                    </main>
                </div>

                <div id="container-popup" class="container-popup" style="display: none;">
                    <form class="popup" action="/groups/create" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <h3>Tạo Nhóm Học Tập Mới</h3>

                        <label for="groupName">Tên Nhóm:</label>
                        <input id="groupName" name="groupName" placeholder="Nhập tên nhóm..." required
                            style="width: 100%; padding: 10px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #ccc;">

                        <div class="popup-buttons">
                            <button type="submit" id="save">Tạo Nhóm</button>
                            <button type="button" id="cancel"
                                onclick="document.getElementById('container-popup').style.display='none'">Hủy</button>
                        </div>
                    </form>
                </div>

                <script src="/js/client/script.js"></script>
                <script src="/js/client/head-foot.js"></script>
            </body>

            </html>