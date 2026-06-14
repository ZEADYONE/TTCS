<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chơi tương tác - ${deckTitle}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="/css/client/head-foot.css">
    <link rel="stylesheet" href="/css/client/interactive-game.css">
</head>

<body>
    <header class="top-nav">
        <div class="brand">
            <h1>English Learning Platform</h1>
            <p>Chơi tương tác với nhân vật</p>
        </div>
        <div class="game-header-actions">
            <c:if test="${preview}">
                <span class="preview-badge">ADMIN PREVIEW</span>
            </c:if>
            <a href="/client/deck/${deckId}">
                <i class="fa-solid fa-arrow-left"></i> Quay lại deck
            </a>
        </div>
    </header>

    <input type="hidden" id="deckId" value="${deckId}">
    <input type="hidden" id="previewMode" value="${preview}">
    <input type="hidden" id="csrfToken" value="${_csrf.token}">
    <input type="hidden" id="csrfHeader" value="${_csrf.headerName}">

    <main class="interactive-shell">
        <section id="loadingState" class="status-card">
            <div class="loading-dot"></div>
            <p>Đang chuẩn bị trò chơi...</p>
        </section>

        <section id="errorState" class="status-card error-state" hidden>
            <i class="fa-solid fa-circle-exclamation"></i>
            <h2>Chưa thể mở trò chơi</h2>
            <p id="errorMessage"></p>
            <a href="/client/deck/${deckId}">Quay lại deck</a>
        </section>

        <section id="gameApp" hidden>
            <div class="game-topline">
                <div>
                    <p class="game-label">INTERACTIVE COURSE</p>
                    <h2 id="deckTitle">${deckTitle}</h2>
                </div>
                <div class="round-progress">
                    <span id="roundText">Round 1/1</span>
                    <div class="progress-track">
                        <div id="progressBar" class="progress-value"></div>
                    </div>
                </div>
            </div>

            <section id="gameScene" class="game-scene theme--garden-feast">
                <div class="cloud cloud-one"></div>
                <div class="cloud cloud-two"></div>

                <div class="dialogue-box">
                    <div>
                        <strong id="characterName">Bunny</strong>
                        <p id="dialogueText"></p>
                    </div>
                    <button id="speakTaskButton" type="button" title="Nghe nhiệm vụ">
                        <i class="fa-solid fa-volume-high"></i>
                    </button>
                </div>

                <div id="obstacleZone" class="obstacle-zone"></div>

                <div id="dropZone" class="drop-zone" tabindex="0" role="button"
                    aria-label="Thả card vào nhân vật">
                    <div id="character" class="character character-idle">
                        <div id="characterEmoji" class="character-emoji">🐰</div>
                        <div class="character-shadow"></div>
                    </div>
                    <span class="drop-hint">Kéo thẻ vào đây</span>
                </div>
            </section>

            <section class="cards-panel">
                <div class="cards-heading">
                    <div>
                        <h3>Chọn thẻ đúng</h3>
                        <p>Kéo thẻ vào Bunny hoặc bấm thẻ rồi bấm Bunny.</p>
                    </div>
                    <span id="selectionHint"></span>
                </div>
                <div id="cardList" class="interactive-card-list"></div>
            </section>
        </section>

        <section id="completionState" class="completion-card" hidden>
            <div class="completion-character">🐰</div>
            <h2>Hoàn thành!</h2>
            <p id="completionText"></p>
            <div class="completion-actions">
                <button type="button" id="playAgainButton">Chơi lại</button>
                <a href="/client/deck/${deckId}">Quay lại deck</a>
            </div>
        </section>
    </main>

    <script src="/js/client/interactive-game/registry.js"></script>
    <script src="/js/client/interactive-game/templates/feed.js"></script>
    <script src="/js/client/interactive-game/templates/action.js"></script>
    <script src="/js/client/interactive-game/templates/select.js"></script>
    <script src="/js/client/interactive-game/themes.js"></script>
    <script src="/js/client/interactive-game/core.js"></script>
</body>

</html>
