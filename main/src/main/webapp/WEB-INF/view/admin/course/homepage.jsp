<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Course Management - English Learning Platform</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
                <link rel="stylesheet" href="/css/admin/course.css">
                <link rel="stylesheet" href="/css/admin/header-slide.css">
            </head>

            <body>
                <header class="top-nav">
                    <div class="brand">
                        <h1>English Learning Platform</h1>
                        <p>Master English with Interactive Exercises</p>
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
                                <a href="/" class="dropdown-item">
                                    <i class="fa-regular fa-user"></i>
                                    <span>Client</span>
                                </a>
                            </c:if>

                            <form method="post" action="/logout">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="dropdown-item"
                                    style="width: 100%; border: 0px none; background-color: white; cursor: pointer; text-align: left;">
                                    <i class="fa-solid fa-right-from-bracket"></i>
                                    <span>Logout</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </header>

                <div class="container">
                    <aside class="sidebar">
                        <div class="sidebar-header">
                            <i class="fa-solid fa-layer-group logo-icon"></i>
                        </div>
                        <nav class="menu">
                            <a href="/admin/dashboard" class="menu-item">
                                <i class="fa-solid fa-gauge-high"></i> Dashboard
                            </a>
                            <a href="/admin/user" class="menu-item">
                                <i class="fa-solid fa-user-large"></i> User
                            </a>
                            <a href="/admin/deck" class="menu-item">
                                <i class="fa-solid fa-book-open"></i> Deck FlashCard
                            </a>
                            <a href="/admin/course" class="menu-item active">
                                <i class="fa-solid fa-graduation-cap"></i> Course
                            </a>
                            <a href="/admin/role" class="menu-item  ">
                                <i class="fa-solid fa-cube"></i> Role
                            </a>
                        </nav>
                    </aside>

                    <main class="main-content">
                        <section class="library-section">
                            <div class="library-header">
                                <div class="btn-create">
                                    <span>Create deck</span>
                                </div>
                            </div>

                            <div class="toolbar">
                                <form class="search-box" id="searchForm" action="/admin/course" method="get">
                                    <i class="fas fa-search"></i>
                                    <input type="text" name="keyword" value="${keyword}" placeholder="Search course...">
                                </form>

                                <div class="filter-dropdown-container">
                                    <button class="filter-btn" id="filterBtn" type="button">
                                        <i class="fa-solid fa-filter"></i>
                                    </button>
                                    <form class="filter-dropdown" id="filterMenu" style="right: 0px; left: auto;">
                                        <input type="hidden" name="keyword" value="${keyword}">

                                        <label>
                                            <input type="checkbox" name="scope" value="Public" ${selectedScope !=null &&
                                                selectedScope.contains('Public') ? 'checked' : '' }>
                                            Public
                                        </label>

                                        <label>
                                            <input type="checkbox" name="scope" value="Private" ${selectedScope !=null
                                                && selectedScope.contains('Private') ? 'checked' : '' }>
                                            Private
                                        </label>

                                        <button type="submit" class="filter-btn-submit">Apply</button>
                                    </form>
                                </div>
                            </div>

                            <div class="deck-grid">
                                <c:forEach var="deck" items="${listCourse}">
                                    <div class="deck-card" data-id="${deck.id}">
                                        <a href="/admin/course/${deck.id}">
                                            <div class="card-top">
                                                <img src="/images/client/${deck.image}" alt="${deck.title}">

                                                <c:choose>
                                                    <c:when test="${deck.scope == 'Private'}">
                                                        <i class="fas fa-lock status-icon"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-globe status-icon"></i>
                                                    </c:otherwise>
                                                </c:choose>

                                                <span class="card-count">${deck.card.size()} card</span>
                                            </div>

                                            <div class="card-body">
                                                <h3>${deck.title}</h3>
                                                <p>${deck.des}</p>
                                            </div>
                                        </a>

                                        <div class="card-footer">
                                            <div>
                                                <span><i class="far fa-user"></i> Admin</span>
                                                <c:choose>
                                                    <c:when test="${deck.isFeatured}">
                                                        <i style="color: rgb(255, 212, 59);"
                                                            class="fa-solid fa-star text-warning"
                                                            title="Bỏ nổi bật"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i style="color: rgb(255, 212, 59);"
                                                            class="fa-regular fa-star text-secondary"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="card-actions"
                                                style="display: flex; align-items: center; gap: 15px;">
                                                <i class="fas fa-wrench fix_deck" style="cursor: pointer;"
                                                    data-id="${deck.id}" data-title="${deck.title}"
                                                    data-des="${deck.des}" data-scope="${deck.scope}"></i>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" style="margin-top: 20px;">
                                    <ul class="custom-pagination">

                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link"
                                                    href="?page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
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
                    <form:form class="popup" id="form-popup" modelAttribute="deck" action="/admin/course/create"
                        method="post" enctype="multipart/form-data">
                        <div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </div>

                        <input type="hidden" name="id" id="deck-id">

                        <h3 id="feature">Edit Course</h3>
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

                <script src="/js/admin/style.js"></script>
                <script src="/js/admin/course.js"></script>
                <!-- <script>
                    // Hàm dùng chung để chuyển hướng kèm theo tất cả params (search + filter + page)
                    function submitFilter(pageNumber) {
                        const searchInput = document.querySelector('input[name="keyword"]');
                        const filterForm = document.getElementById('filterMenu');

                        // Tạo URLSearchParams từ form filter
                        const params = new URLSearchParams(new FormData(filterForm));

                        // Cập nhật/Ghi đè giá trị keyword và page
                        params.set('keyword', searchInput.value.trim());
                        params.set('page', pageNumber);

                        window.location.href = window.location.pathname + "?" + params.toString();
                    }

                    // Xử lý Click phân trang
                    document.querySelectorAll('.page-node').forEach(button => {
                        button.addEventListener('click', function () {
                            const page = this.getAttribute('data-page');
                            if (page > 0) submitFilter(page);
                        });
                    });

                    // Xử lý khi nhấn Enter ở ô Search
                    document.getElementById('searchForm').addEventListener('submit', function (e) {
                        e.preventDefault();
                        submitFilter(1); // Search mới thì về trang 1
                    });

                    // Xử lý khi nhấn nút Apply trong Filter
                    document.getElementById('filterMenu').addEventListener('submit', function (e) {
                        e.preventDefault();
                        submitFilter(1); // Filter mới thì về trang 1
                    });
                </script> -->
            </body>

            </html>