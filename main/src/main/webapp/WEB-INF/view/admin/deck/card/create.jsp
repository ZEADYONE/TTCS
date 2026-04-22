<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Add Card - English Learning Platform</title>

            <link rel="stylesheet" href="/css/client/card.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

            <main class="container">
                <h1 class="page-title">Add Card</h1>

                <!-- FORM -->
                <form id="addCardForm" class="form-content" action="<c:url value='/admin/deck/card/create/${deckId}'/>"
                    method="post" modelAttribute="card" enctype="multipart/form-data">

                    <!-- CSRF -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="form-row">

                        <div class="form-group">
                            <label>Word</label>
                            <input type="text" name="word" placeholder="Word" required>
                        </div>

                        <div class="form-group">
                            <label>Transliteration</label>
                            <input type="text" name="trans" placeholder="Transliteration">
                        </div>

                        <div class="form-group">
                            <label>Vietnamese</label>
                            <input type="text" name="mean" placeholder="Vietnamese" required>
                        </div>

                    </div>

                    <div class="form-group full-width">
                        <label>Example</label>
                        <textarea name="example" placeholder="Example"></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label>Definition</label>
                        <textarea name="definition" placeholder="Definition"></textarea>
                    </div>

                    <div class="bottom-section">

                        <!-- IMAGE -->
                        <div class="image-upload-wrapper">
                            <label style="font-weight: bold;font-size: 1.1rem;">Image</label>

                            <div class="image-box" onclick="document.getElementById('fileInput').click()">
                                <i class="fa-solid fa-upload"></i>
                            </div>

                            <input type="file" id="fileInput" name="images" hidden>
                        </div>

                        <!-- SOUND -->
                        <div class="sound-and-actions">

                            <div class="form-group">
                                <!-- <label>Sound</label> -->
                                <input type="file" name="sounds" hidden>
                            </div>

                            <div class="button-group">
                                <button type="submit" class="btn btn-add">Add</button>
                                <button type="button" class="btn btn-back" onclick="history.back()">Back</button>
                            </div>

                        </div>

                    </div>

                </form>
            </main>

            <script src="/js/client/head-foot.js"></script>
            <script src="/js/client/card.js"></script>

        </body>

        </html>