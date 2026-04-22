<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Flashcard</title>

            <link rel="stylesheet" href="/css/client/flashcard.css">
            <link rel="stylesheet" href="/css/client/head-foot.css">
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
                            <div class="dropdown-item">
                                <i class="fa-solid fa-circle-info"></i> Information
                            </div>
                        </a>

                        <c:if test="${sessionScope.role == 'ADMIN'}">
                            <a href="<c:url value='/admin'/>">
                                <div class="dropdown-item">
                                    <i class="fa-regular fa-user"></i> Admin
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

            <input type="hidden" id="csrfToken" value="${_csrf.token}" />
            <input type="hidden" id="csrfHeader" value="${_csrf.headerName}" />

            <div id="game-screen">
                <main class="container">
                    <h2>${deck.des}</h2>
                    <div id="progress-text">0/0</div>

                    <div class="flashcard-container">
                        <div class="flashcard" id="flashcard" onclick="flipCard()">

                            <div class="card-face card-front">
                                <button class="audio-btn" onclick="playAudio(event)">
                                    <i class="fas fa-volume-up"></i>
                                </button>

                                <img id="card-image" src="">
                                <h3 id="card-word"></h3>
                                <p id="card-phonetic"></p>
                            </div>

                            <div class="card-face card-back">
                                <div class="info-group">
                                    <div class="info-label">Definition</div>
                                    <p id="card-defi"></p>
                                </div>
                                <div class="info-group">
                                    <div class="info-label">Example</div>
                                    <p id="card-exp"></p>
                                </div>
                                <div class="info-group">
                                    <div class="info-label">Vietnamese</div>
                                    <p id="card-meaning"></p>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="action-buttons">
                        <button class="btn-wrong" onclick="handleAnswer(false)">
                            <i class="fas fa-times"></i> Wrong
                        </button>
                        <button class="btn-flip" onclick="flipCard()">Flip Card</button>
                        <button class="btn-correct" onclick="handleAnswer(true)">
                            <i class="fas fa-check"></i> Correct
                        </button>
                    </div>

                </main>
            </div>

            <!-- RESULT -->
            <div id="result-screen" style="display:none;">
                <div class="result-wrapper">

                    <div class="award-icon">
                        <i class="fas fa-award"></i>
                    </div>

                    <div class="result-card">
                        <h2>Review Complete!</h2>

                        <div class="score-container">
                            <div class="score-box correct-box">
                                <span class="score-label">Correct<br>Answers</span>
                                <span class="score-number" id="correct-count">0</span>
                            </div>

                            <div class="score-box incorrect-box">
                                <span class="score-label">Incorrect<br>Answers</span>
                                <span class="score-number" id="incorrect-count">0</span>
                            </div>
                        </div>
                    </div>

                    <div class="result-actions">
                        <button class="btn-back" onclick="window.history.back()">Back</button>
                        <button class="btn-play-again" onclick="location.reload()">Play again</button>
                    </div>

                </div>
            </div>

            <!-- DATA -->
            <script id="cards-data" type="application/json">
[
<c:forEach var="card" items="${listCard}" varStatus="status">
{
"id": ${card.id},
"word": "${card.word}",
"phonetic": "${card.trans}",
"image": "${card.image}",
"sound": "${card.sound}",
"definition": "${card.definition}",
"example": "${card.example}",
"meaning": "${card.mean}"
}${!status.last ? ',' : ''}
</c:forEach>
]
</script>

            <script>
                const cards = JSON.parse(document.getElementById('cards-data').textContent);

                let currentIndex = 0;
                let scores = { correct: 0, incorrect: 0 };
                let isLoading = false;

                // ================= RENDER =================
                function renderCard() {
                    if (currentIndex >= cards.length) {
                        showResult();
                        return;
                    }

                    const card = cards[currentIndex];

                    document.getElementById("flashcard").classList.remove("flipped");

                    document.getElementById("card-word").innerText = card.word || "";
                    document.getElementById("card-phonetic").innerText = card.phonetic || "";
                    document.getElementById("card-image").src = card.image ? "/images/client/" + card.image : "";

                    document.getElementById("card-defi").innerText = card.definition || "";
                    document.getElementById("card-exp").innerText = card.example || "";
                    document.getElementById("card-meaning").innerText = card.meaning || "";

                    document.getElementById("progress-text").innerText = (currentIndex + 1) + "/" + cards.length;
                }

                // ================= AUDIO =================
                const VoiceControl = {
                    speak(text) {
                        if (!text) return;

                        // Dừng các câu đang đọc dở để ưu tiên từ mới nhất
                        window.speechSynthesis.cancel();

                        const utterance = new SpeechSynthesisUtterance(text);
                        utterance.lang = 'en-US';
                        utterance.rate = 0.9; // Đọc chậm một chút để người học dễ nghe

                        window.speechSynthesis.speak(utterance);
                    }
                };

                function playAudio(event) {
                    event.stopPropagation();

                    const card = cards[currentIndex];
                    VoiceControl.speak(card.word);
                }

                // ================= ANSWER =================
                async function handleAnswer(isCorrect) {
                    if (isLoading) return;
                    isLoading = true;

                    const card = cards[currentIndex];
                    const token = document.getElementById('csrfToken').value;
                    const header = document.getElementById('csrfHeader').value;

                    try {
                        await fetch("/api/progress/save", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                                [header]: token
                            },
                            body: JSON.stringify({
                                cardId: card.id,
                                isCorrect: isCorrect
                            })
                        });

                        if (isCorrect) scores.correct++;
                        else scores.incorrect++;

                        currentIndex++;
                        renderCard();

                    } catch (e) {
                        console.error(e);
                    }

                    isLoading = false;
                }

                // ================= UI =================
                function flipCard() {
                    document.getElementById("flashcard").classList.toggle("flipped");
                }

                function showResult() {
                    document.getElementById("game-screen").style.display = "none";
                    document.getElementById("result-screen").style.display = "block";

                    document.getElementById("correct-count").innerText = scores.correct;
                    document.getElementById("incorrect-count").innerText = scores.incorrect;
                }

                window.onload = renderCard;
            </script>
            <script src="/js/client/head-foot.js"></script>
        </body>

        </html>