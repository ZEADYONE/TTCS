<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>User Management - English Learning Platform</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
                <link rel="stylesheet" href="/css/admin/user.css">
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
                            <a href="/admin/user" class="menu-item active">
                                <i class="fa-solid fa-user-large"></i> User
                            </a>
                            <a href="/admin/deck" class="menu-item">
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
                                        <form action="/admin/user" method="get" class="search-box">
                                            <i class="fa-solid fa-magnifying-glass"></i>
                                            <input type="text" name="keyword" value="${keyword}"
                                                placeholder="Search User...">
                                        </form>

                                        <div class="filter-dropdown-container">
                                            <button class="filter-btn" id="filterBtn">
                                                <i class="fa-solid fa-filter"></i>
                                            </button>
                                            <form class="filter-dropdown" id="filterMenu" action="/admin/user"
                                                method="get">
                                                <label><input type="checkbox" name="status" value="false"
                                                        ${selectedStatus !=null && selectedStatus.contains(false)
                                                        ? 'checked' : '' }> Banned</label>
                                                <label><input type="checkbox" name="status" value="true"
                                                        ${selectedStatus !=null && selectedStatus.contains(true)
                                                        ? 'checked' : '' }> Active</label>

                                                <c:forEach var="r" items="${roles}">
                                                    <label>
                                                        <input type="checkbox" name="roleIds" value="${r.id}" <c:forEach
                                                            var="sId" items="${selectedRoles}">
                                                        <c:if test="${sId == r.id}">checked</c:if>
                                                </c:forEach>>
                                                ${r.name}
                                                </label>
                                                </c:forEach>
                                                <button type="submit" class="filter-btn-submit">Apply</button>
                                            </form>
                                        </div>
                                    </div>
                                    <a href="/admin/user/create">
                                        <button class="btn-create">Create user</button>
                                    </a>
                                </div>

                                <table class="user-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>UserName</th>
                                            <th>Email</th>
                                            <th>Phone Number</th>
                                            <th>Role</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${listUser}">
                                            <tr>
                                                <td>${user.id}</td>
                                                <td>${user.userName}</td>
                                                <td>${user.email}</td>
                                                <td>${user.phoneNumber}</td>
                                                <td>${user.role.name}</td>
                                                <td class="status">
                                                    <c:if test="${user.status == true}">
                                                        Active
                                                    </c:if>
                                                    <c:if test="${user.status == false}">
                                                        Banned
                                                    </c:if>
                                                </td>
                                                <td class="actions">
                                                    <a href="/admin/user/view/${user.id}"><i
                                                            class="fa-regular fa-eye btn-view"></i></a>
                                                    <a href="/admin/user/update/${user.id}"><i
                                                            class="fa-solid fa-wrench btn-edit"></i></a>

                                                    <form action="/admin/user/status/${user.id}" method="POST"
                                                        style="display:inline;">
                                                        <div style="display: none;">
                                                            <input type="hidden" name="${_csrf.parameterName}"
                                                                value="${_csrf.token}" />
                                                        </div>
                                                        <button type="submit"
                                                            style="background: none; border: none; padding: 0; cursor: pointer;">
                                                            <c:choose>
                                                                <c:when test="${user.status == true}">
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
                <script src="/js/admin/user.js"></script>
                <!-- <script>
                    document.querySelectorAll('.page-node').forEach(button => {
                        button.addEventListener('click', function (e) {
                            e.preventDefault();
                            const page = this.getAttribute('data-page');

                            // Lấy keyword từ ô search
                            const keyword = document.querySelector('input[name="keyword"]').value;

                            // Lấy dữ liệu từ form filter
                            const filterForm = document.getElementById('filterMenu');
                            const formData = new FormData(filterForm);
                            const params = new URLSearchParams(formData);

                            // Đưa thêm page và keyword vào URL
                            params.set('page', page);
                            if (keyword) params.set('keyword', keyword);

                            // Chuyển hướng
                            window.location.href = "/admin/user?" + params.toString();
                        });
                    });

                    // Sửa lại form search để khi enter nó cũng giữ lại filter
                    document.querySelector('.search-box').addEventListener('submit', function (e) {
                        e.preventDefault();
                        const keyword = this.querySelector('input').value;
                        const filterForm = document.getElementById('filterMenu');
                        const params = new URLSearchParams(new FormData(filterForm));
                        params.set('keyword', keyword);
                        params.set('page', 1); // Reset về trang 1 khi search mới
                        window.location.href = "/admin/user?" + params.toString();
                    });
                </script> -->
            </body>

            </html>