<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>English Learning Platform - Admin Dashboard</title>

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

                <link rel="stylesheet" href="/css/admin/dashboard.css">
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
                        <span class="user-name">${sessionScope.fullName}</span>
                        <i class="fa-solid fa-chevron-down mini-arrow"></i>

                        <div class="info-dropdown" id="infoDropdown">

                            <a href="<c:url value='/user/info'/>">
                                <div class="dropdown-item">
                                    <i class="fa-solid fa-circle-info"></i> Information
                                </div>
                            </a>

                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                <a href="<c:url value='/'/>">
                                    <div class="dropdown-item">
                                        <i class="fa-regular fa-user"></i>Client
                                    </div>
                                </a>
                            </c:if>

                            <form method="post" action="<c:url value='/logout'/>">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <button type="submit" class="dropdown-item"
                                    style="width: 100%; border: none; background-color: white;">
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
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item active">
                                <i class="fa-solid fa-gauge-high"></i> Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/user" class="menu-item">
                                <i class="fa-solid fa-user-large"></i> User
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/deck" class="menu-item">
                                <i class="fa-solid fa-book-open"></i> Deck FlashCard
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/course" class="menu-item">
                                <i class="fa-solid fa-graduation-cap"></i> Course
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/role" class="menu-item">
                                <i class="fa-solid fa-cube"></i> Role
                            </a>
                        </nav>
                    </aside>

                    <main class="main-content">
                        <section class="dashboard-section">
                            <h2 class="section-title">Admin Dashboard</h2>
                            <p class="section-subtitle">Monitor and manage your platform statistics</p>

                            <div class="stats-grid">
                                <div class="stat-card blue">
                                    <div class="stat-icon-wrapper">
                                        <i class="fa-solid fa-users"></i>
                                    </div>
                                    <span class="label">Total Users</span>
                                    <span class="number">
                                        <fmt:formatNumber value="${not empty totalUsers ? totalUsers : 0}"
                                            pattern="#,###" />
                                    </span>
                                </div>

                                <div class="stat-card purple">
                                    <div class="stat-icon-wrapper">
                                        <i class="fa-solid fa-layer-group"></i>
                                    </div>
                                    <span class="label">Total Decks</span>
                                    <span class="number">
                                        <fmt:formatNumber value="${not empty totalDecks ? totalDecks : 0}"
                                            pattern="#,###" />
                                    </span>
                                </div>

                                <div class="stat-card green">
                                    <div class="stat-icon-wrapper">
                                        <i class="fa-solid fa-graduation-cap"></i>
                                    </div>
                                    <span class="label">Total Courses</span>
                                    <span class="number">
                                        <fmt:formatNumber value="${not empty totalCourses ? totalCourses : 0}"
                                            pattern="#,###" />
                                    </span>
                                </div>

                                <div class="stat-card green">
                                    <div class="stat-icon-wrapper">
                                        <i class="fa-solid fa-graduation-cap"></i>
                                    </div>
                                    <span class="label">Total Featured</span>
                                    <span class="number">
                                        <fmt:formatNumber value="${not empty totalFeatured ? totalFeatured : 0}"
                                            pattern="#,###" />
                                    </span>
                                </div>
                            </div>
                        </section>
                    </main>
                </div>

                <script src="/js/client/head-foot.js"></script>
            </body>

            </html>