// 1. Khởi tạo dữ liệu
const rawData = JSON.parse(document.getElementById('cards-data').textContent);

// Xử lý dữ liệu thô để thêm logic ẩn chữ cái
const questions = rawData.map(card => {
    const word = card.word || "";
    const indices = [];
    const count = Math.ceil(word.length * 0.4); // Ẩn 40% số chữ cái

    while (indices.length < count && word.length > 0) {
        let r = Math.floor(Math.random() * word.length);
        if (!indices.includes(r)) indices.push(r);
    }

    return {
        ...card,
        hiddenIndices: indices
    };
});

const DECK_ID = document.getElementById('deckId') ? document.getElementById('deckId').value : 0;

let currentIndex = 0;
let score = { correct: 0, wrong: 0 };
let isLocked = false;
let isLoading = false;

// DOM Elements
const feedbackMsg = document.getElementById('feedback-msg');
const resText = document.getElementById('result-text');

// 2. Logic Audio
function playAudio() {
    const card = questions[currentIndex];
    if (!card.sound) {
        const utterance = new SpeechSynthesisUtterance(card.word);
        utterance.lang = 'en-US';
        window.speechSynthesis.speak(utterance);
        return;
    }
    const audio = new Audio("/sound/client/" + card.sound);
    audio.play();
}

// 3. Hiển thị câu hỏi
function loadQuestion() {
    if (currentIndex >= questions.length) {
        showResult();
        return;
    }

    const q = questions[currentIndex];
    const display = document.getElementById('word-display');
    const checkBtn = document.getElementById('check-btn');

    // Reset UI
    if (resText) resText.style.display = "none";
    display.innerHTML = '';
    feedbackMsg.innerText = '';
    checkBtn.disabled = false;
    isLocked = false;

    // Load nội dung
    document.getElementById('card-image').src = q.image ? "/images/client/" + q.image : "";
    document.getElementById('card-phonetic').innerText = q.phonetic || "";
    document.getElementById('progress-text').innerText = `${currentIndex + 1}/${questions.length}`;

    // Tạo các ô nhập liệu
    q.word.split('').forEach((char, index) => {
        const input = document.createElement('input');
        input.type = 'text';
        input.maxLength = 1;
        input.classList.add('char-box');

        // Kiểm tra xem vị trí này có bị ẩn không
        if (!q.hiddenIndices.includes(index)) {
            input.value = char;
            input.readOnly = true;
            input.classList.add('fixed');
        }

        input.addEventListener('keyup', (e) => handleInput(e, index));
        display.appendChild(input);
    });

    focusNextEmpty(0);
}

// 4. Xử lý Input (Tự nhảy ô)
function handleInput(e, index) {
    if (isLocked) return;
    const inputs = document.querySelectorAll('.char-box');

    if (e.key === "Backspace") {
        if (index > 0) {
            let prev = index - 1;
            while (prev >= 0 && inputs[prev].readOnly) prev--;
            if (prev >= 0) inputs[prev].focus();
        }
    } else if (e.target.value.length === 1) {
        let next = index + 1;
        while (next < inputs.length && inputs[next].readOnly) next++;
        if (next < inputs.length) inputs[next].focus();
    }
}

function focusNextEmpty(startIdx) {
    const inputs = document.querySelectorAll('.char-box');
    for (let i = startIdx; i < inputs.length; i++) {
        if (!inputs[i].readOnly) {
            inputs[i].focus();
            break;
        }
    }
}

// 5. Kiểm tra đáp án
async function checkAnswer() {
    if (isLocked || isLoading) return;

    const q = questions[currentIndex];
    const inputs = document.querySelectorAll('.char-box');
    let allCorrect = true;

    inputs.forEach((input, i) => {
        const userChar = input.value.toLowerCase();
        const correctChar = q.word[i].toLowerCase();

        if (userChar === correctChar) {
            input.classList.add('correct');
        } else {
            input.classList.add('wrong');
            allCorrect = false;
        }
        input.readOnly = true;
    });

    if (allCorrect) score.correct++; else score.wrong++;

    isLocked = true;
    document.getElementById('check-btn').disabled = true;
    feedbackMsg.innerText = allCorrect ? "Correct!" : "Incorrect!";

    if (resText) {
        resText.innerText = "Answer: " + q.word;
        resText.style.display = "block";
    }

    setTimeout(() => {
        currentIndex++;
        loadQuestion();
    }, 2000);
}

// 6. Hiển thị kết quả & Lưu API
async function showResult() {
    document.getElementById('game-screen').classList.add('hidden');
    document.getElementById('result-screen').classList.remove('hidden');

    document.getElementById('res-correct').innerText = score.correct;
    document.getElementById('res-wrong').innerText = score.wrong;
    document.getElementById("res-date").innerText = new Date().toLocaleDateString('vi-VN');
    document.getElementById("txt-performance").innerText = `${score.correct} Correct | ${score.wrong} Wrong`;

    const token = document.getElementById('csrfToken').value;
    const header = document.getElementById('csrfHeader').value;

    try {
        await fetch("/api/game/save", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                [header]: token
            },
            body: JSON.stringify({
                deckId: DECK_ID,
                correct: score.correct,
                wrong: score.wrong
            })
        });
    } catch (e) {
        console.error("Error saving result:", e);
    }
}

window.onload = loadQuestion;