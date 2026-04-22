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
                <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"> -->
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
                                    <h2>My library</h2>
                                    <p>Manage your personal collections and study progress</p>
                                </div>
                                <div class="btn-create">
                                    <span>Create deck</span>
                                </div>
                            </div>

                            <div class="toolbar">
                                <form action="/client/library" method="GET" style="margin: 0; flex-grow: 1;">
                                    <div class="search-box">
                                        <i class="fas fa-search"></i>
                                        <input type="text" name="keyword" value="${keyword}"
                                            placeholder="Search library ...">
                                        <c:forEach items="${selectedFilters}" var="filter">
                                            <input type="hidden" name="filters" value="${filter}">
                                        </c:forEach>
                                    </div>
                                </form>

                                <div class="filter-container">
                                    <button class="filter-btn" id="filterBtn">
                                        <i class="fas fa-filter"></i>
                                    </button>
                                    <div class="filter-dropdown" id="filterDropdown">
                                        <form action="/client/library" method="GET"
                                            style="display:flex; flex-direction: column;">
                                            <input type="hidden" name="keyword" value="${keyword}">

                                            <label style="font-weight: bold; margin-top: 5px;">Hiển thị:</label>
                                            <label>
                                                <input type="checkbox" name="filters" value="Public" ${selectedFilters
                                                    !=null && selectedFilters.contains('Public') ? 'checked' : '' }>
                                                Public
                                            </label>
                                            <label>
                                                <input type="checkbox" name="filters" value="Private" ${selectedFilters
                                                    !=null && selectedFilters.contains('Private') ? 'checked' : '' }>
                                                Private
                                            </label>

                                            <label style="font-weight: bold; margin-top: 10px;">Người tạo:</label>
                                            <label>
                                                <input type="checkbox" name="filters" value="Mine" ${selectedFilters
                                                    !=null && selectedFilters.contains('Mine') ? 'checked' : '' }> You
                                            </label>
                                            <label>
                                                <input type="checkbox" name="filters" value="Admin" ${selectedFilters
                                                    !=null && selectedFilters.contains('Admin') ? 'checked' : '' }>
                                                Admin
                                            </label>
                                            <label>
                                                <input type="checkbox" name="filters" value="Other" ${selectedFilters
                                                    !=null && selectedFilters.contains('Other') ? 'checked' : '' }>
                                                Other
                                            </label>

                                            <button type="submit"
                                                style="margin-top: 10px; padding: 5px; cursor: pointer;">
                                                Apply <i class="fas fa-filter dropdown-icon"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="deck-grid">
                                <c:forEach var="deck" items="${listDeck}">
                                    <div class="deck-card" data-id="${deck.id}">

                                        <a href="/client/deck/${deck.id}">
                                            <div class="card-top">
                                                <img src="/images/client/${deck.image}" />

                                                <c:choose>
                                                    <c:when test="${deck.scope == 'Public'}">
                                                        <i class="fas fa-globe status-icon"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-lock status-icon"></i>
                                                    </c:otherwise>
                                                </c:choose>

                                                <span class="card-count">${deck.totalCards}
                                                    cards</span>
                                            </div>

                                            <div class="card-body">
                                                <h3>${deck.title}</h3>
                                                <p>${deck.des}</p>

                                                <div class="progress-container">
                                                    <div class="progress-bar"
                                                        style="--p: ${deck.progressPercent}%; width: var(--p);">
                                                    </div>
                                                </div>

                                                <span class="progress-text">
                                                    ${deck.correctCards}/${deck.totalCards}
                                                </span>

                                            </div>


                                        </a>

                                        <div class="card-footer">
                                            <div>
                                                <span>
                                                    <i class="far fa-user"></i>
                                                    ${deck.userName}
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
                                            <c:if test="${currentUser == deck.userId}">
                                                <div class="card-actions"
                                                    style="display: flex; align-items: center; gap: 15px;">
                                                    <i class="fas fa-wrench fix_deck" style="cursor: pointer;"
                                                        data-id="${deck.id}" data-title="${deck.title}"
                                                        data-des="${deck.des}" data-scope="${deck.scope}"></i>

                                                    <form action="/client/deck/delete/${deck.id}" method="post"
                                                        style="margin: 0; display: flex;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <button type="submit"
                                                            style="background: none; border: none; padding: 0; cursor: pointer; color: inherit;">
                                                            <i class="fas fa-trash-alt trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>

                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <c:if test="${totalPages > 1}">
                                <c:url value="/client/library" var="baseUrl">
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
                <div id="container-popup" class="container-popup">
                    <form:form class="popup" id="form-popup" modelAttribute="deck" action="/client/deck/create"
                        method="post" enctype="multipart/form-data">
                        <div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </div>

                        <input type="hidden" name="id" id="deck-id">

                        <h3 id="feature">Edit Deck</h3>
                        <label for="popup-title">Title</label>
                        <input id="popup-title" name="title" placeholder="Title" required>

                        <label for="popup-desc">Description</label>
                        <input id="popup-desc" name="des" placeholder="Description" required>

                        <label>Scope</label>
                        <select id="popup-scope" name="scope">
                            <option value="Public">Public</option>
                            <option value="Private">Private</option>
                        </select>

                        <label for="img">Image
                            <div id="popup-image" class="popup-image">
                            </div>
                            <input type="file" name="images" id="img" accept=".png, .jpg, .jpeg" hidden>
                        </label>

                        <div class="popup-buttons">
                            <button type="submit" id="save">Save change</button>
                            <button type="button" id="cancel">Cancel</button>
                        </div>
                    </form:form>


                </div>

                <script src="/js/client/script.js"></script>
                <script src="/js/client/head-foot.js"></script>
            </body>

            </html>