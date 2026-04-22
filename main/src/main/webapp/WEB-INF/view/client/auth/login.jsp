<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Login</title>

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

                        <div class="title">Login</div>

                        <!-- Spring Form -->
                        <form method="POST" action="/login">
                            <c:if test="${param.error != null}">
                                <div class="my-2" style="color: red;">Sai email hoặc password.</div>
                            </c:if>
                            <div class="field">
                                <label>Email</label>
                                <input name="username" type="email" placeholder="abc@gmail.com" class="input" />
                            </div>

                            <div class="field">
                                <label>Password</label>
                                <input name="password" type="password" placeholder="1234.." class="input" />
                            </div>

                            <div>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            </div>

                            <button type="submit" class="submit">
                                Login
                            </button>

                        </form>

                        <div class="new_user">
                            New user? <a href="/client/sign_up">Sign up</a>
                        </div>

                    </div>
                </div>

            </body>

            </html>