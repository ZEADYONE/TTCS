<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Sign up</title>

                <link rel="stylesheet" href="/css/client/auth/css/style.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body>

                <div class="Sologan">
                    <a href="/">
                        <div class=" title">English Learning Platform
                        </div>
                    </a>
                </div>

                <div class="login">
                    <div class="main">

                        <div class="title">Sign up</div>

                        <!-- Spring Form -->
                        <form:form method="POST" action="/client/sign_up" modelAttribute="newUser">

                            <c:set var="errorEmail">
                                <form:errors path="email" />
                            </c:set>

                            <div class="field">
                                <label>Email</label>
                                <form:input path="email"
                                    class="form-control ${not empty errorEmail ? 'is-invalid' : ''}" type="email"
                                    placeholder="abc@gmail.com" cssClass="input" />

                                <div class="invalid-feedback d-block">
                                    ${errorEmail}
                                </div>
                            </div>

                            <c:set var="errorUserName">
                                <form:errors path="userName" />
                            </c:set>
                            <div class="field">
                                <label>UserName</label>
                                <form:input path="userName"
                                    class="form-control ${not empty errorUserName ? 'is-invalid' : ''}" type="text"
                                    placeholder="username...." cssClass="input" />
                                <div class="invalid-feedback d-block">
                                    ${errorUserName}
                                </div>
                            </div>

                            <div class="field">
                                <label>FullName</label>
                                <form:input path="fullName" type="text" placeholder="fullname...." cssClass="input" />
                            </div>

                            <div class="field">
                                <label>Password</label>
                                <form:input path="passWord" type="password" placeholder="1234.." cssClass="input" />
                            </div>

                            <c:set var="errorRewritePassWord">
                                <form:errors path="rewritePassWord" />
                            </c:set>
                            <div class="field">
                                <label>Rewrite password</label>
                                <form:input path="rewritePassWord"
                                    class="form-control ${not empty errorRewritePassWord ? 'is-invalid' : ''}"
                                    type="password" placeholder="1234.." cssClass="input" />
                                <div class="invalid-feedback d-block">
                                    ${errorRewritePassWord}
                                </div>
                            </div>

                            <button type="submit" class="submit">
                                Sign up
                            </button>

                        </form:form>

                        <div class="new_user">
                            Already have an account? <a href="/client/login">Log in</a>
                        </div>

                    </div>
                </div>

            </body>

            </html>