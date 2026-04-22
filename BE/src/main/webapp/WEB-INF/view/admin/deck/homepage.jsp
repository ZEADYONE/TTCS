<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Deck FlashCard Management - English Learning Platform</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
                <link rel="stylesheet" href="/css/admin/deck.css">
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
                                    style="width: 100%; border: 0px none; background-color: white;">
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
                            <a href="/admin/deck" class="menu-item active">
                                <i class="fa-solid fa-book-open"></i> Deck FlashCard
                            </a>
                            <a href="/admin/course" class="menu-item">
                                <i class="fa-solid fa-graduation-cap"></i> Course
                            </a>
                            <a href="/admin/role" class="menu-item">
                                <i class="fa-solid fa-cube"></i> Role
                            </a>
                        </nav>
                    </aside>

                    <main class="main-content">
                        <section class="content-body">
                            <div class="table-wrapper">
                                <div class="toolbar">
                                    <div class="search-filter-group">
                                        <form action="/admin/deck" method="get" class="search-box">
                                            <i class="fa-solid fa-magnifying-glass"></i>
                                            <input type="text" name="keyword" value="${keyword}"
                                                placeholder="Search Deck...">
                                        </form>

                                        <div class="filter-dropdown-container">
                                            <button class="filter-btn" id="filterBtn">
                                                <i class="fa-solid fa-filter"></i>
                                            </button>
                                            <form class="filter-dropdown" id="filterMenu" action="/admin/deck"
                                                method="get">
                                                <label><input type="checkbox" name="status" value="false"
                                                        ${selectedStatus !=null && selectedStatus.contains(false)
                                                        ? 'checked' : '' }> Banned</label>
                                                <label><input type="checkbox" name="status" value="true"
                                                        ${selectedStatus !=null && selectedStatus.contains(true)
                                                        ? 'checked' : '' }> Active</label>
                                                <button type="submit" class="filter-btn-submit">Apply</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>ID-Deck</th>
                                            <th>Title</th>
                                            <th>ID-User</th>
                                            <th>Email</th>
                                            <th class="text-center">Featured</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="deck" items="${listDeck}">
                                            <tr>
                                                <td>${deck.id}</td>
                                                <td><strong>${deck.title}</strong></td>
                                                <td>${deck.user.id}</td>
                                                <td><strong>${deck.user.email}</strong></td>

                                                <td class="text-center">
                                                    <form action="/admin/deck/featured/${deck.id}" method="POST"
                                                        style="display:inline;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <button type="submit"
                                                            style="background: none; border: none; padding: 0; cursor: pointer;">
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
                                                        </button>
                                                    </form>
                                                </td>
                                                <td class="status">
                                                    <span id="status-text-${deck.id}">
                                                        ${deck.status ? 'Active' : 'Banned'}
                                                    </span>
                                                </td>

                                                <td class="actions">
                                                    <a href="/admin/deck/view/${deck.id}"><i
                                                            class="fa-regular fa-eye btn-view"></i></a>
                                                    <a href="/admin/deck/update/${deck.id}"><i
                                                            class="fa-solid fa-wrench btn-edit"></i></a>

                                                    <form action="/admin/deck/status/${deck.id}" method="POST"
                                                        style="display:inline;">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <button type="submit"
                                                            style="background: none; border: none; padding: 0; cursor: pointer;">
                                                            <c:choose>
                                                                <c:when test="${deck.status}">
                                                                    <i class="fa-solid fa-lock-open btn-unlock"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fa-solid fa-lock btn-lock"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>


                                <c:if test="${totalPages > 1}">
                                    <nav aria-label="Page navigation" style="margin-top: 20px;">
                                        <ul class="custom-pagination">

                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="?page=${currentPage - 1}"
                                                    aria-label="Previous">
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
                            </div>
                        </section>
                    </main>
                </div>

                <script src="/js/admin/style.js"></script>
                <script src="/js/admin/deck.js"></script>
                <script>
                    function handleToggleFeatured(deckId) {
                        const token = $("meta[name='_csrf']").attr("content");
                        const header = $("meta[name='_csrf_header']").attr("content");

                        $.ajax({
                            url: "/admin/deck/toggle-featured/" + deckId,
                            type: "POST",
                            beforeSend: function (xhr) {
                                if (header && token) xhr.setRequestHeader(header, token);
                            },
                            success: function (isFeatured) {
                                const icon = $("#featured-icon-" + deckId);
                                if (isFeatured) {
                                    // Nếu là nổi bật: Sao vàng, hình đặc
                                    icon.removeClass('fa-regular text-secondary').addClass('fa-solid text-warning');
                                } else {
                                    // Nếu không: Sao xám, chỉ có viền
                                    icon.removeClass('fa-solid text-warning').addClass('fa-regular text-secondary');
                                }
                            },
                            error: function () {
                                console.error("Lỗi khi cập nhật trạng thái nổi bật");
                            }
                        });
                    }
                </script>
            </body>

            </html>