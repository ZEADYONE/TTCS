<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                <title>View User - English Learning Platform</title>
                <link rel="stylesheet" href="/css/admin/style_user.css">
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

                <main class="content-area">
                    <div class="form-container">
                        <div class="form-header">
                            <i style="font-size: 50px;" class="fa-regular fa-eye"></i>
                            <div class="button-group">
                                <button type="button" class="btn-back" onclick="history.back()">Back</button>
                            </div>
                        </div>

                        <form:form id="userForm" class="user-grid-form" modelAttribute="user" method="GET">
                            <div class="form-group">
                                <label>Email</label>
                                <form:input path="email" type="email" readonly="true" />
                            </div>

                            <div class="form-group">
                                <label>User name</label>
                                <form:input path="userName" type="text" readonly="true" />
                            </div>

                            <div class="form-group">
                                <label>FullName</label>
                                <form:input path="fullName" type="text" readonly="true" />
                            </div>

                            <div class="form-group">
                                <label>Location</label>
                                <form:input path="location" type="text" readonly="true" />
                            </div>

                            <div class="form-group">
                                <label>Phone number</label>
                                <form:input path="phoneNumber" type="text" readonly="true" />
                            </div>

                            <div class="form-group">
                                <label>Date of Birth</label>
                                <form:input path="dateOfBirth" type="date" readonly="true" />
                            </div>

                            <div class="form-group">
                                <label>Bio</label>
                                <form:textarea path="bio" rows="6" readonly="true" />
                            </div>

                            <div class="right-column-group">
                                <div class="form-group">
                                    <label>Role</label>
                                    <form:input path="role.name" readonly="true" />
                                </div>
                            </div>
                        </form:form>
                    </div>
                </main>

                <script src="/js/admin/script.js"></script>
            </body>

            </html>