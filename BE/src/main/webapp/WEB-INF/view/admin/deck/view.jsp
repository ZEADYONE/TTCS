<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>View Deck - English Learning Platform</title>

                <link rel="stylesheet" href="<c:url value='/css/admin/view_deck.css'/>">
                <link rel="stylesheet" href="<c:url value='/css/client/head-foot.css'/>">
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

                <main class="container-view">
                    <h2 class="page-title">View Deck</h2>

                    <div class="edit-top">
                        <div class="form-group">
                            <div class="input-item">
                                <label>Title</label>
                                <input type="text" value="${deck.title}" name="title" disabled>
                            </div>
                            <div class="input-item">
                                <label>Description</label>
                                <textarea disabled name="description">${deck.des}</textarea>
                            </div>
                            <div class="input-item">
                                <label>Scope</label>
                                <select disabled id="scopeSelect" name="scope">
                                    <option value="Public" ${deck.scope=='public' ? 'selected' : '' }>Public</option>
                                    <option value="Private" ${deck.scope=='private' ? 'selected' : '' }>Private</option>
                                </select>
                            </div>
                        </div>

                        <div class="upload-area">
                            <div class="upload-box" id="uploadBox" <c:if test="${not empty deck.image}">
                                style="background-image: url('/images/client/${deck.image}'); background-size: cover;
                                background-position: center;"</c:if>>
                            </div>
                            <input type="file" id="img" name="img" hidden disabled>
                        </div>

                        <div class="all-btn">
                            <form class="search-box" id="searchForm" action="/admin/deck/view/${deck.id}" method="get">
                                <button type="submit" style="display: none;"></button>
                                <i class="fa-solid fa-magnifying-glass" style="cursor: pointer;"></i>
                                <input type="text" name="keyword" value="${keyword}" placeholder="Search flashcard...">
                            </form>

                            <a href="<c:url value='/admin/deck'/>">
                                <button type="button" class="btn btn-gray">
                                    <i class="fa-solid fa-xmark"></i> Back
                                </button>
                            </a>
                        </div>
                    </div>




                    <section class="flashcards-container">
                        <div class="cards-grid" id="cardsGrid">

                            <c:forEach var="card" items="${listCard}">
                                <div class="card">

                                    <a href="<c:url value='/client/card/view/${card.id}'/>">
                                        <div class="card-bg"
                                            style="background-image: url('/images/client/${card.image}')">
                                        </div>

                                        <div class="card-content">
                                            <h3>${card.word}</h3>
                                            <p>${card.mean}</p>
                                        </div>
                                    </a>

                                    <div class="audio-icon" data-word="${card.word}" style="cursor: pointer;">
                                        <i class="fa-solid fa-volume-high"></i>
                                    </div>

                                    <!-- <div class="card-action">
                                        <a href="<c:url value='/client/card/update/${card.id}'/>">
                                            <i class="fas fa-wrench fix_deck"></i>
                                        </a>

                                        <form action="/admin/card/delete/${card.id}" method="post"
                                            style="display:inline;">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit"
                                                style="background: none; border: none; padding: 0; cursor: pointer;">
                                                <i class="fas fa-trash-alt trash"></i>
                                            </button>
                                        </form>
                                    </div> -->

                                </div>
                            </c:forEach>

                        </div>

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

                <script src="<c:url value='/js/admin/script.js'/>"></script>
            </body>

            </html>