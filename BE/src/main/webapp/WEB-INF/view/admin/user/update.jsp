<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
                <title>Update User - English Learning Platform</title>
                <link rel="stylesheet" href="/css/admin/style_user.css">
                <link rel="stylesheet" href="/css/admin/header-slide.css">
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
                                <i style="font-size: 50px;" class="fa-solid fa-wrench"></i>
                                <div class="button-group">
                                    <a href="/admin/user" class="btn-back"
                                        style="text-decoration: none; display: inline-block; padding: 10px 20px;">Back</a>
                                    <button type="submit" form="userForm" class="btn-create">Update</button>
                                </div>
                            </div>

                            <form:form id="userForm" class="user-grid-form" action="/admin/user/update" method="post"
                                modelAttribute="newUser">

                                <form:input type="hidden" path="id" />

                                <div class="form-group">
                                    <label>Email</label>
                                    <form:input type="email" path="email" required="required" readonly="true" />
                                </div>

                                <div class="form-group">
                                    <label>User name</label>
                                    <form:input type="text" path="userName" required="required" />
                                </div>

                                <div class="form-group">
                                    <label>Full Name</label>
                                    <form:input type="text" path="fullName" />
                                </div>

                                <div class="form-group">
                                    <label>Location</label>
                                    <form:input type="text" path="location" />
                                </div>

                                <div class="form-group" style="display: none;">
                                    <label>Password</label>
                                    <form:input path="passWord" type="password" placeholder="Password" required="true"
                                        readonly="true" />
                                </div>

                                <div class="form-group">
                                    <label>Phone number</label>
                                    <form:input type="text" path="phoneNumber" />
                                </div>

                                <div class="form-group">
                                    <label>Date of Birth</label>
                                    <form:input type="date" path="dateOfBirth" />
                                </div>

                                <div class="form-group">
                                    <label>Bio</label>
                                    <form:textarea path="bio" rows="6" />
                                </div>

                                <div class="form-group" style="display: none;">
                                    <label>Status</label>
                                    <form:input path="status" />
                                </div>

                                <div class="right-column-group">
                                    <div class="form-group">
                                        <label>Role</label>

                                        <form:select path="role.id">
                                            <form:options items="${roles}" itemValue="id" itemLabel="name" />
                                        </form:select>
                                    </div>
                                </div>
                            </form:form>
                        </div>
                    </main>
                </div>
                <script src="/js/admin/script.js"></script>
            </body>

            </html>