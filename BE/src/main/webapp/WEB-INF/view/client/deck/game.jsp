<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>English Learning - Fill in the Blanks</title>
            <link rel="stylesheet" href="/css/client/game.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body>
            <header class="top-nav">
                <div class="brand">
                    <h1>English Learning Platform</h1>
                    <p>Master English with Interactive Exercises</p>
                </div>
                <div class="nav-links">
                    <a href="/">HOME</a>
                    <a href=" /client/library">FLASHCARD</a>
                </div>
                <div class="container-info" id="userDropdownTrigger">
                    <i class="fa-regular fa-user"></i>
                    <span class="user-name">${sessionScope.fullName}</span>
                    <i class="fa-solid fa-chevron-down mini-arrow"></i>
                    <div class="info-dropdown" id="infoDropdown">
                        <a href="<c:url value='/user/info'/>">
                            <div class="dropdown-item"><i class="fa-solid fa-circle-info"></i> Information</div>
                        </a>
                        <c:if test="${sessionScope.role == 'ADMIN'}">
                            <a href="<c:url value='/admin'/>">
                                <div class="dropdown-item"><i class="fa-regular fa-user"></i> Admin</div>
                            </a>
                        </c:if>
                        <form method="post" action="<c:url value='/logout'/>">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="dropdown-item"
                                style="width: 100%; border: none; background: white; cursor: pointer;">
                                <i class="fa-solid fa-right-from-bracket"></i> Logout
                            </button>
                        </form>
                    </div>
                </div>
            </header>

            <div class="back-nav">
                <i class="fa-solid fa-chevron-left" onclick="history.back()"></i>
            </div>

            <input type="hidden" id="csrfToken" value="${_csrf.token}" />
            <input type="hidden" id="csrfHeader" value="${_csrf.headerName}" />
            <input type="hidden" id="deckId" value="${deck.id}" />

            <main class="container" id="game-screen">
                <div class="topic-info">
                    <h2 id="topic-title">${deck.des}</h2>
                    <p>Learn new words and their meanings</p>
                    <div class="progress" id="progress-text">0/0</div>
                </div>

                <div class="card-fill">
                    <div class="audio-btn" onclick="playAudio()"><i class="fa-solid fa-volume-high"></i></div>
                    <img id="card-image" src="" alt="Word Image">
                    <div class="word-display" id="word-display"></div>
                    <p id="card-phonetic" class="phonetic"></p>
                    <div id="result-text" class="result" style="display:none; margin-top: 10px; font-weight: bold;">
                    </div>
                </div>

                <div class="action-buttons">
                    <button class="btn-check" id="check-btn" onclick="checkAnswer()">Check</button>
                </div>
                <div id="feedback-msg" class="feedback"></div>
            </main>

            <main class="container hidden" id="result-screen">
                <div class="result-header">
                    <h1>Result</h1>
                    <p>See how you performed</p>
                </div>
                <div class="session-info">
                    <div class="trophy-icon"><i class="fa-solid fa-award"></i></div>
                    <h2>Session Complete!</h2>
                    <p>Great job keeping up with your daily goals.</p>
                </div>
                <div class="result-cards">
                    <div class="card">
                        <h3>Performance</h3>
                        <div class="perf-stats">
                            <div class="stat-box correct-bg">
                                <span>Correct</span>
                                <strong id="res-correct">0</strong>
                            </div>
                            <div class="stat-box wrong-bg">
                                <span>Incorrect</span>
                                <strong id="res-wrong">0</strong>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <h3>Play history</h3>
                        <div class="history-list">
                            <div class="history-item">
                                <span id="res-date"></span>
                                <br>
                                <span id="txt-performance"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="result-footer">
                    <button class="btn-outline" onclick="history.back()">Back</button>
                    <button class="btn-primary" onclick="location.reload()">Play again</button>
                </div>
            </main>

            <script id="cards-data" type="application/json">
[
    <c:forEach var="card" items="${listCard}" varStatus="status">
    {
        "id": ${card.id},
        "word": "${card.word}",
        "phonetic": "${card.trans}",
        "image": "${card.image}",
        "sound": "${card.sound}"
    }${!status.last ? ',' : ''}
    </c:forEach>
]
</script>

            <script src="/js/client/game.js"></script>
            <script src="/js/client/head-foot.js"></script>
        </body>

        </html>