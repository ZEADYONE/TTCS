<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Create User - English Learning Platform</title>

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="/css/admin/header-slide.css">
                <link rel="stylesheet" href="/css/admin/style_user.css">
            </head>

            <body>

                <div class="app-container">

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
                                <h2 class="form-title">Create user</h2>

                                <div class="button-group">
                                    <a href="/admin/user"><button type="button" class="btn-back">Back</button></a>
                                    <button type="submit" form="userForm" class="btn-create">Create</button>
                                </div>
                            </div>
                            <!-- Spring Form -->
                            <form:form id="userForm" class="user-grid-form" method="post" action="/admin/user/create"
                                modelAttribute="newUser">

                                <c:set var="errorEmail">
                                    <form:errors path="email" />
                                </c:set>
                                <div class="form-group">
                                    <label>Email</label>
                                    <form:input path="Email"
                                        class="form-control ${not empty errorEmail ? 'is-invalid' : ''}" type="email"
                                        placeholder="Email" />

                                    <div class="invalid-feedback d-block">
                                        ${errorEmail}
                                    </div>
                                </div>

                                <c:set var="errorUserName">
                                    <form:errors path="userName" />
                                </c:set>
                                <div class="form-group">
                                    <label>User name</label>
                                    <form:input path="userName"
                                        class="form-control ${not empty errorUserName ? 'is-invalid' : ''}" type="text"
                                        placeholder="Username" required="true" />

                                    <div class="invalid-feedback d-block">
                                        ${errorUserName}
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>FullName</label>
                                    <form:input path="fullName" type="text" placeholder="FullName" />
                                </div>

                                <c:set var="errorPassword">
                                    <form:errors path="passWord" />
                                </c:set>
                                <div class="form-group">
                                    <label>Password</label>

                                    <form:input path="passWord" type="password" placeholder="Password"
                                        class="form-control ${not empty errorPassword ? 'is-invalid' : ''}"
                                        required="true" />

                                    <div class="invalid-feedback d-block">
                                        ${errorPassword}
                                    </div>
                                </div>


                                <div class="form-group">
                                    <label>Phone number</label>
                                    <form:input path="phoneNumber" type="text" placeholder="PhoneNumber" />
                                </div>

                                <div class="form-group">
                                    <label>Date of Birth</label>
                                    <form:input path="dateOfBirth" type="date" />
                                </div>

                                <div class="form-group">
                                    <label>Bio</label>
                                    <form:textarea path="bio" rows="6" placeholder="Bio"></form:textarea>
                                </div>

                                <div class="right-column-group">

                                    <!-- <form:select path="role.id">
                                        <form:options items="${roles}" itemValue="id" itemLabel="name" />
                                    </form:select> -->

                                    <div class="form-group">
                                        <label>Role</label>

                                        <form:select path="role.id">
                                            <form:options items="${roles}" itemValue="id" itemLabel="name" />
                                        </form:select>

                                    </div>

                                    <div class="form-group">
                                        <label>Location</label>
                                        <form:input path="location" type="text" placeholder="Location" />
                                    </div>

                                </div>

                            </form:form>

                        </div>

                    </main>

                </div>

                <script src="/js/admin/script.js"></script>
                <script src="/js/admin/style.js"></script>

            </body>

            </html>