<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>English Learning Platform - My Library</title>
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
                </header>


                <div class="app-container">
                    <aside class="sidebar">
                        <div class="logo-section">
                            <i class="fas fa-layer-group main-logo"></i>
                        </div>
                        <nav class="side-nav">
                            <a href="/client/community" class="nav-item">
                                <i class="fas fa-users"></i>
                                <span>Community<small>Chia sẻ bộ flashcard</small></span>
                            </a>
                            <a href="/client/library" class="nav-item">
                                <i class="fas fa-book-open"></i>
                                <span>My Library<small>FlashCard của bạn</small></span>
                            </a>
                            <a href="/client/course" class="nav-item">
                                <i class="fas fa-graduation-cap"></i>
                                <span>Course <small>FlashCard từ Admin</small></span>
                            </a>
                        </nav>
                    </aside>

                    <main class="main-content">
                        <section class="library-section">
                            <div class="library-header">
                                <div class="title-area">
                                    <h2>Explore Community Decks</h2>
                                    <p>Discover flashcards created by learners worldwide.</p>
                                </div>
                            </div>

                            <div class="toolbar">
                                <form class="search-box" id="searchForm">
                                    <i class="fas fa-search"></i>
                                    <input type="text" name="keyword" value="${param.keyword}"
                                        placeholder="Search library ...">
                                </form>

                                <div class="filter-dropdown-container">
                                    <form class="filter-dropdown" id="filterMenu" style="right: 0px; left: auto;">
                                        <input type="hidden" name="keyword" value="${keyword}">
                                    </form>
                                </div>
                                <!-- <div class="filter-container">
                        <button class="filter-btn" id="filterBtn">
                            <i class="fas fa-filter"></i>
                        </button>
                        <div class="filter-dropdown" id="filterDropdown">
                            <label><input type="checkbox" checked> Public</label>
                            <label><input type="checkbox"> Private</label>
                            <i class="fas fa-filter dropdown-icon"></i>
                        </div>
                    </div> -->
                            </div>

                            <div class="deck-grid">
                                <c:forEach var="deck" items="${listDeck}">

                                    <div class="deck-card">

                                        <!-- CLICK vào deck -->
                                        <a href="/client/deck/${deck.id}">
                                            <div class="card-top">
                                                <img src="/images/client/${deck.image}" />

                                                <!-- Scope icon -->

                                                <span class="card-count">${deck.card.size()} cards</span>
                                            </div>

                                            <div class="card-body">
                                                <h3>${deck.title}</h3>
                                                <p>${deck.des}</p>
                                            </div>
                                        </a>

                                        <!-- Footer -->
                                        <div class="card-footer">
                                            <div>
                                                <span>
                                                    <i class="far fa-user"></i>
                                                    ${deck.user.userName}
                                                </span>
                                                <c:choose>

                                                    <c:when test="${deck.isFeatured}">
                                                        <i style="color: rgb(255, 212, 59);"
                                                            class="fa-solid fa-star text-warning"
                                                            style="font-size: 1.1rem;"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i style="color: rgb(255, 212, 59);"
                                                            class="fa-regular fa-star text-secondary"
                                                            style="font-size: 1.1rem;"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="card-actions">
                                            </div>
                                        </div>

                                    </div>

                                </c:forEach>
                            </div>
                            <c:if test="${totalPages > 1}">
                                <c:url value="/client/community" var="baseUrl">
                                    <c:if test="${not empty keyword}">
                                        <c:param name="keyword" value="${keyword}" />
                                    </c:if>
                                    <c:forEach items="${selectedFilters}" var="f">
                                        <c:param name="filters" value="${f}" />
                                    </c:forEach>
                                </c:url>

                                <nav aria-label="Page navigation" style="margin-top: 20px;">
                                    <ul class="custom-pagination">

                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="${baseUrl}${baseUrl.contains('?') ? '&' : '?'}page=${currentPage - 1}"
                                                aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link"
                                                    href="${baseUrl}${baseUrl.contains('?') ? '&' : '?'}page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="${baseUrl}${baseUrl.contains('?') ? '&' : '?'}page=${currentPage + 1}"
                                                aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>

                                    </ul>
                                </nav>
                            </c:if>
                        </section>
                    </main>
                </div>
                <script src="/js/client/script.js"></script>
                <script src="/js/client/head-foot.js"></script>
            </body>

            </html>