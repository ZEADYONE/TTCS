<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>English Learning Platform</title>

            <link rel="stylesheet" href="<c:url value='/css/client/homepage_deck.css'/>">
            <link rel="stylesheet" href="/css/client/head-foot.css">
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

            <main>

                <!-- BACK -->
                <a href="/admin/course"><i class="fa-solid fa-arrow-left exit"></i></a>

                <!-- TITLE -->
                <section class="title-section">
                    <div>
                        <h2>${deck.title}</h2>
                        <p>${deck.des}</p>
                    </div>

                    <form class="search-box" id="searchForm" action="" method="get">
                        <i class="fas fa-search"></i>
                        <input type="text" name="keyword" value="${keyword}" placeholder="Search flashcard ...">
                    </form>

                    <c:choose>
                        <c:when test="${currentUser == deck.user.id}">
                            <a href="<c:url value='/admin/card/create/${deck.id}'/>">
                                <button class="btn add">Add card</button>
                            </a>
                        </c:when>
                    </c:choose>

                </section>

                <!-- CARDS -->
                <section class="flashcards-container">
                    <div class="cards-grid">

                        <c:forEach var="card" items="${listCard}">
                            <div class="card">

                                <a href="<c:url value='/admin/card/view/${card.id}'/>">

                                    <div class="card-bg" style="background-image: url('/images/client/${card.image}')">
                                    </div>

                                    <div class="card-content">
                                        <h3>${card.word}</h3>
                                        <p>${card.mean}</p>
                                    </div>

                                </a>

                                <!-- AUDIO -->
                                <div class="audio-icon" data-word="${card.word}" style="cursor: pointer;">
                                    <i class="fa-solid fa-volume-high"></i>
                                </div>

                                <!-- ACTION -->
                                <c:if test="${currentUser == card.deck.user.id}">
                                    <div class="card-action">

                                        <a href="<c:url value='/admin/card/update/${card.id}'/>">
                                            <i class="fas fa-wrench fix_deck"></i>
                                        </a>

                                        <form action="/admin/card/delete/${card.id}" method="post">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" style=" background: none;border: none; padding: 0;"><i
                                                    class="fas fa-trash-alt trash"></i></button>
                                        </form>
                                    </div>
                                </c:if>


                            </div>
                        </c:forEach>

                    </div>

                    <!-- PAGINATION (có thể làm động sau) -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" style="margin-top: 20px;">
                            <ul class="custom-pagination">

                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
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

                </section>

            </main>


            <script src="/js/client/homepage_deck.js"></script>
            <script src="/js/client/head-foot.js"></script>
        </body>

        </html>