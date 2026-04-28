<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Report Management - English Learning Platform</title>
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
                            <a href="/admin/deck" class="menu-item">
                                <i class="fa-solid fa-book-open"></i> Deck FlashCard
                            </a>
                            <a href="/admin/course" class="menu-item">
                                <i class="fa-solid fa-graduation-cap"></i> Course
                            </a>
                            <a href="/admin/groups" class="menu-item">
                                <i class="fa-solid fa-users"></i> Group
                            </a>
                            <a href="/admin/reports" class="menu-item active">
                                <i class="fa-solid fa-flag"></i> Reports
                            </a>
                            <a href="/admin/role" class="menu-item">
                                <i class="fa-solid fa-cube"></i> Role
                            </a>
                        </nav>
                    </aside>

                    <main class="main-content">
                        <section class="library-section">
                            <div class="library-header">
                                <div class="title-area">
                                    <h2 style="color: #ef4444;"><i class="fas fa-exclamation-triangle"></i> Quản lý Báo
                                        cáo</h2>
                                    <p>Danh sách các bộ thẻ bị cộng đồng báo cáo vi phạm.</p>
                                </div>
                            </div>

                            <div class="toolbar">
                                <form class="search-box" id="searchForm" action="/admin/reports" method="get">
                                    <i class="fas fa-search"></i>
                                    <input type="text" name="keyword" value="${keyword}"
                                        placeholder="Tìm kiếm báo cáo...">
                                </form>
                            </div>

                            <div class="deck-grid">
                                <c:forEach var="report" items="${reports}">
                                    <div class="deck-card" data-id="${report.id}" style="border: 1px solid #fee2e2;">

                                        <div class="card-top">
                                            <img src="/images/client/${report.deck.image}" alt="${report.deck.title}">
                                            <span class="card-count" style="background-color: #ef4444;">Pending</span>
                                        </div>

                                        <a href="/admin/deck/update/${report.deck.id}" class="card-link">
                                            <div class="card-body">
                                                <h3 style="color: #ef4444; font-size: 1.1rem; margin-bottom: 10px;">
                                                    Deck: ${report.deck.title}
                                                </h3>
                                                <p style="font-size: 0.9rem; color: #4b5563; margin-bottom: 5px;">
                                                    <strong><i class="fas fa-user-shield"></i> Người báo cáo:</strong>
                                                    ${report.user.userName}
                                                </p>
                                                <p
                                                    style="font-size: 0.9rem; color: #4b5563; background: #f3f4f6; padding: 8px; border-radius: 5px; border-left: 3px solid #ef4444;">
                                                    "${report.description}"
                                                </p>
                                            </div>
                                        </a>

                                        <div class="card-footer" style="background-color: #fff5f5;">
                                            <div>
                                                <span style="font-size: 0.85rem;"><i class="far fa-user"></i> Chủ thẻ:
                                                    ${report.deck.user.userName}</span>
                                            </div>

                                            <div class="card-actions"
                                                style="display: flex; align-items: center; gap: 10px;">

                                                <form action="/admin/reports/ban/${report.deck.id}" method="post"
                                                    style="margin: 0;">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <button type="submit" title="Banned deck này"
                                                        style="background: #ef4444; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">
                                                        <i class="fas fa-ban"></i> Banned
                                                    </button>
                                                </form>

                                                <form action="/admin/reports/cancel/${report.id}" method="post"
                                                    style="margin: 0;">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <button type="submit" title="Đánh dấu đã xử lý"
                                                        style="background: #10b981; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">
                                                        <i class="fas fa-check"></i> Xong
                                                    </button>
                                                </form>

                                            </div>
                                        </div>

                                    </div>
                                </c:forEach>
                            </div>

                            <c:if test="${empty reports}">
                                <div style="text-align: center; padding: 50px; color: #6b7280;">
                                    <i class="fas fa-check-circle"
                                        style="font-size: 3rem; color: #10b981; margin-bottom: 15px;"></i>
                                    <h3>Tuyệt vời!</h3>
                                    <p>Hiện không có báo cáo vi phạm nào cần xử lý.</p>
                                </div>
                            </c:if>
                            <c:if test="${totalPages > 1}">
                                <c:url value="/admin/reports" var="baseUrl">
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
                <script src="/js/admin/style.js"></script>
            </body>

            </html>