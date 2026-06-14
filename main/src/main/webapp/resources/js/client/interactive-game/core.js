document.addEventListener("DOMContentLoaded", () => {
    const deckId = document.getElementById("deckId").value;
    const previewMode = document.getElementById("previewMode").value === "true";
    const loadingState = document.getElementById("loadingState");
    const errorState = document.getElementById("errorState");
    const gameApp = document.getElementById("gameApp");
    const completionState = document.getElementById("completionState");
    const gameScene = document.getElementById("gameScene");
    const dialogueText = document.getElementById("dialogueText");
    const character = document.getElementById("character");
    const characterEmoji = document.getElementById("characterEmoji");
    const dropZone = document.getElementById("dropZone");
    const dropHint = dropZone.querySelector(".drop-hint");
    const cardList = document.getElementById("cardList");
    const obstacleZone = document.getElementById("obstacleZone");
    const selectionHint = document.getElementById("selectionHint");

    let game = null;
    let template = null;
    let currentTaskIndex = 0;
    let selectedCardId = null;
    let locked = false;
    let wrongAttempts = 0;

    const VoiceControl = {
        speak(text, lang = "vi-VN") {
            if (!text || !("speechSynthesis" in window)) return;
            window.speechSynthesis.cancel();
            const utterance = new SpeechSynthesisUtterance(text);
            utterance.lang = lang;
            utterance.rate = lang === "en-US" ? 0.85 : 0.95;
            window.speechSynthesis.speak(utterance);
        },
        stop() {
            if ("speechSynthesis" in window) {
                window.speechSynthesis.cancel();
            }
        }
    };

    async function loadGame() {
        try {
            const response = await fetch(
                `/api/decks/${deckId}/interactive-config?preview=${previewMode}`,
                { headers: { "Accept": "application/json" } }
            );
            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.message || "Không tải được cấu hình trò chơi.");
            }

            game = data;
            template = window.InteractiveGameRegistry.getTemplate(game.templateHandler);
            const theme = window.InteractiveGameRegistry.getTheme(game.themeKey);
            if (!template) {
                throw new Error("Template chưa có renderer trên trình duyệt.");
            }
            if (!theme || theme.templateKey !== game.templateKey) {
                throw new Error("Theme không tương thích với template.");
            }
            if (theme.sceneClass !== game.themeClass) {
                throw new Error("Theme renderer không khớp cấu hình backend.");
            }

            loadingState.hidden = true;
            gameApp.hidden = false;
            applyGameTheme(theme);
            renderTask();
        } catch (error) {
            loadingState.hidden = true;
            errorState.hidden = false;
            document.getElementById("errorMessage").innerText = error.message;
        }
    }

    function applyGameTheme(theme) {
        document.getElementById("deckTitle").innerText = game.deckTitle || "Interactive Game";
        document.getElementById("characterName").innerText = game.characterName || "Bunny";
        characterEmoji.innerText = game.characterEmoji || "🐰";
        gameScene.className = `game-scene ${game.themeClass}`;
        dropHint.innerText = template.dropHint;
    }

    function renderTask() {
        if (currentTaskIndex >= game.tasks.length) {
            finishGame();
            return;
        }

        locked = false;
        selectedCardId = null;
        character.className = "character character-idle";
        const task = currentTask();
        const progress = ((currentTaskIndex + 1) / game.tasks.length) * 100;

        document.getElementById("roundText").innerText =
            `Round ${currentTaskIndex + 1}/${game.tasks.length}`;
        document.getElementById("progressBar").style.width = `${progress}%`;
        dialogueText.innerText = task.promptText || game.introText || "Chọn thẻ đúng nhé!";
        selectionHint.innerText = "";

        template.renderRound({ obstacleZone, gameScene, character }, task);
        renderCards();
        setTimeout(() => VoiceControl.speak(dialogueText.innerText), 180);
    }

    function renderCards() {
        cardList.innerHTML = "";
        const optionIds = new Set(currentTask().optionCardIds.map(Number));
        const optionCards = game.cards.filter((card) => optionIds.has(Number(card.id)));
        optionCards.forEach((card) => {
            const item = document.createElement("article");
            item.className = "interactive-card";
            item.draggable = true;
            item.tabIndex = 0;
            item.dataset.cardId = card.id;

            const imageMarkup = card.image
                ? `<img src="/images/client/${escapeAttribute(card.image)}" alt="">`
                : `<div class="card-fallback">${escapeHtml((card.word || "?").charAt(0))}</div>`;

            item.innerHTML = `
                <div class="card-visual">${imageMarkup}</div>
                <div class="card-copy">
                    <strong>${escapeHtml(card.word || "")}</strong>
                </div>
                <button type="button" class="card-audio" aria-label="Nghe từ">
                    <i class="fa-solid fa-volume-high"></i>
                </button>
            `;
            // <span>${escapeHtml(card.mean || "")}</span>
            item.addEventListener("dragstart", (event) => {
                event.dataTransfer.setData("text/card-id", String(card.id));
                event.dataTransfer.effectAllowed = "move";
                item.classList.add("dragging");
            });
            item.addEventListener("dragend", () => item.classList.remove("dragging"));
            item.addEventListener("click", (event) => {
                if (event.target.closest(".card-audio")) return;
                selectCard(card.id);
            });
            item.addEventListener("keydown", (event) => {
                if (event.key === "Enter" || event.key === " ") {
                    event.preventDefault();
                    selectCard(card.id);
                }
            });
            item.querySelector(".card-audio").addEventListener("click", (event) => {
                event.stopPropagation();
                VoiceControl.speak(card.word, "en-US");
            });
            cardList.appendChild(item);
        });
    }

    function selectCard(cardId) {
        if (locked) return;
        selectedCardId = Number(cardId);
        document.querySelectorAll(".interactive-card").forEach((item) => {
            item.classList.toggle("selected", Number(item.dataset.cardId) === selectedCardId);
        });
        const card = findCard(selectedCardId);
        selectionHint.innerText = card ? `Đã chọn: ${card.word}` : "";
    }

    function handleDrop(cardId, sourceElement) {
        if (locked) return;
        const card = findCard(cardId);
        if (!card) return;

        const task = currentTask();
        if (Number(card.id) === Number(task.targetCardId)) {
            locked = true;
            animateCardToCharacter(sourceElement);
            playEffect(template.successEffect(task));
            const message = task.successText || "Giỏi lắm!";
            showMessage(message, true);
            VoiceControl.speak(message);
            setTimeout(() => {
                currentTaskIndex++;
                renderTask();
            }, 1400);
        } else {
            wrongAttempts++;
            playEffect("character-wrong");
            const message = task.wrongText || "Chưa đúng rồi, thử lại nhé!";
            showMessage(message, false);
            VoiceControl.speak(message);
        }
    }

    function showMessage(message, correct) {
        dialogueText.innerText = message;
        dialogueText.closest(".dialogue-box").classList.toggle("correct-message", correct);
        dialogueText.closest(".dialogue-box").classList.toggle("wrong-message", !correct);
    }

    function playEffect(effectClass) {
        character.className = `character ${effectClass}`;
        setTimeout(() => {
            character.className = "character character-idle";
        }, 1050);
    }

    function animateCardToCharacter(sourceElement) {
        if (!sourceElement) return;
        const sourceRect = sourceElement.getBoundingClientRect();
        const targetRect = character.getBoundingClientRect();
        const clone = sourceElement.cloneNode(true);
        clone.className = "flying-card";
        clone.style.left = `${sourceRect.left}px`;
        clone.style.top = `${sourceRect.top}px`;
        clone.style.width = `${sourceRect.width}px`;
        document.body.appendChild(clone);

        requestAnimationFrame(() => {
            clone.style.transform =
                `translate(${targetRect.left - sourceRect.left}px, ${targetRect.top - sourceRect.top}px) scale(.25)`;
            clone.style.opacity = "0";
        });
        setTimeout(() => clone.remove(), 650);
    }

    async function finishGame() {
        VoiceControl.stop();
        gameApp.hidden = true;
        completionState.hidden = false;
        document.querySelector(".completion-character").innerText = game.characterEmoji || "🐰";
        document.getElementById("completionText").innerText =
            game.completionText || "Tuyệt vời! Con đã hoàn thành bài chơi!";
        VoiceControl.speak(document.getElementById("completionText").innerText);
        if (!previewMode) {
            await saveGameResult();
        }
    }

    async function saveGameResult() {
        const token = document.getElementById("csrfToken").value;
        const header = document.getElementById("csrfHeader").value;
        try {
            await fetch("/api/game/save", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    [header]: token
                },
                body: JSON.stringify({
                    deckId: Number(deckId),
                    correct: game.tasks.length,
                    wrong: wrongAttempts
                })
            });
        } catch (error) {
            console.error("Could not save interactive game result", error);
        }
    }

    function currentTask() {
        return game.tasks[currentTaskIndex];
    }

    function findCard(cardId) {
        return game.cards.find((card) => Number(card.id) === Number(cardId));
    }

    function escapeHtml(value) {
        const element = document.createElement("span");
        element.innerText = value == null ? "" : String(value);
        return element.innerHTML;
    }

    function escapeAttribute(value) {
        return String(value || "").replace(/["'<>]/g, "");
    }

    dropZone.addEventListener("dragover", (event) => {
        event.preventDefault();
        dropZone.classList.add("drag-over");
    });
    dropZone.addEventListener("dragleave", () => dropZone.classList.remove("drag-over"));
    dropZone.addEventListener("drop", (event) => {
        event.preventDefault();
        dropZone.classList.remove("drag-over");
        const cardId = Number(event.dataTransfer.getData("text/card-id"));
        handleDrop(cardId, document.querySelector(`.interactive-card[data-card-id="${cardId}"]`));
    });
    dropZone.addEventListener("click", () => {
        if (selectedCardId != null) {
            handleDrop(
                selectedCardId,
                document.querySelector(`.interactive-card[data-card-id="${selectedCardId}"]`)
            );
        }
    });
    dropZone.addEventListener("keydown", (event) => {
        if ((event.key === "Enter" || event.key === " ") && selectedCardId != null) {
            event.preventDefault();
            handleDrop(
                selectedCardId,
                document.querySelector(`.interactive-card[data-card-id="${selectedCardId}"]`)
            );
        }
    });
    document.getElementById("speakTaskButton").addEventListener("click", () => {
        VoiceControl.speak(dialogueText.innerText);
    });
    document.getElementById("playAgainButton").addEventListener("click", () => {
        currentTaskIndex = 0;
        wrongAttempts = 0;
        completionState.hidden = true;
        gameApp.hidden = false;
        renderTask();
    });

    window.addEventListener("beforeunload", VoiceControl.stop);
    loadGame();
});
