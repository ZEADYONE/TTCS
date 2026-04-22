<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Profile</title>

            <link rel="stylesheet" href="<c:url value='/css/admin/profile.css'/>">
            <link rel="stylesheet" href="/css/admin/header-slide.css">
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

            <main class="container">

                <!-- PROFILE -->
                <section class="profile-banner">
                    <div class="banner-content">
                        <div class="avatar-large">
                            <i class="fa-solid fa-user"></i>
                        </div>

                        <div class="user-intro">
                            <h2>${user.fullName}</h2>
                            <p class="email-text">${user.email}</p>

                            <div class="location-badge">
                                <i class="fa-solid fa-location-dot"></i>
                                ${user.location}
                            </div>

                            <p class="mini-bio">${user.bio}</p>
                        </div>
                    </div>
                </section>

                <!-- FORM EDIT -->
                <section class="info-card">
                    <h3><i class="fa-solid fa-user"></i> Personal Information</h3>

                    <form action="<c:url value='/profile/edit'/>" method="post" modelAttribute="user">
                        <div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </div>
                        <div class="form-grid">

                            <div class="input-group">
                                <label>UserName</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-user"></i>
                                    <input type="text" name="userName" value="${user.userName}">
                                </div>
                            </div>

                            <div class="input-group">
                                <label>FullName</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-user"></i>
                                    <input type="text" name="fullName" value="${user.fullName}">
                                </div>
                            </div>

                            <div class="input-group">
                                <label>Email</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-envelope"></i>
                                    <input type="email" value="${user.email}">
                                </div>
                            </div>

                            <div class="input-group">
                                <label>Email</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-envelope"></i>
                                    <input type="email" value="${user.email}">
                                </div>
                            </div>

                            <div class="input-group">
                                <label>Phone Number</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-phone"></i>
                                    <input type="text" name="phoneNumber" value="${user.phoneNumber}">
                                </div>
                            </div>

                            <div class="input-group">
                                <label>Date Of Birth</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-calendar-days"></i>
                                    <input type="date" name="dateOfBirth" value="${user.dateOfBirth}">
                                </div>
                            </div>

                            <div class="input-group">
                                <label>Location</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-location-dot"></i>
                                    <input type="text" name="location" value="${user.location}">
                                </div>
                            </div>

                        </div>

                        <div class="input-group bio-group">
                            <label>Bio</label>
                            <textarea name="bio">${user.bio}</textarea>
                        </div>

                        <div class="group-btn">
                            <div class="form-footer">
                                <button type="submit" class="btn-save">Save change</button>
                            </div>

                            <div class="form-footer">
                                <button type="button" class="btn-cancel" onclick="history.back()">Cancel</button>
                            </div>
                        </div>

                    </form>
                </section>

            </main>

            <script src="<c:url value='/js/admin/profile.js'/>"></script>

        </body>

        </html>