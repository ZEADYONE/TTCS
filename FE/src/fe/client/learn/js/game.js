// 1. Dữ liệu câu hỏi
const questions = [
    { word: "Hello", phonetic: "/heˈləʊ/", image: "https://th.bing.com/th/id/OIP.tV1Yut2akoObzBb9nU_P-AHaD4?w=276&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3", hiddenIndices: [1, 2], vie: "Xin chào" },
    { word: "Lion", phonetic: "/ˈlaɪ.ən/", image: "https://th.bing.com/th/id/OIP.1v1LyOL7jzgNndpyVfDlGAHaFj?w=234&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3", hiddenIndices: [1, 2, 3], vie: "Sư tử" },
    { word: "Tree", phonetic: "/triː/", image: "https://th.bing.com/th/id/OIP.9JdJHb8SjAuBbZErEIEmbQHaFW?w=223&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3", hiddenIndices: [2, 3], vie: "Cây cối" },
    { word: "Pollution", phonetic: "/pəˈluː.ʃən/", image: "https://th.bing.com/th/id/OIP.7YBSNMI5DuG5XUqmzuHdiQHaDt?w=349&h=174&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3", hiddenIndices: [1, 2, 5], vie: "Ô nhiễm" },
    {
        word: "Spring",
        phonetic: "/sprɪŋ/",
        image: "https://th.bing.com/th/id/R.5b17d0a45f3ebb0f5e45cd0af1463e0d?rik=97RscHNho7ZACA&pid=ImgRaw&r=0",
        vie: "Mùa xuân",
        hiddenIndices: [1, 3]
    }
];

// 2. Khai báo biến (QUAN TRỌNG: Thêm biến score ở đây)
let currentIndex = 0;
let score = { correct: 0, wrong: 0 };
let isLocked = false;

// Dom elements
const volumeBtn = document.querySelector(".fa-volume-high");
const feedbackMsg = document.getElementById('feedback-msg');

const res = document.getElementById("result");
function playAudio(word) {
    const utterance = new SpeechSynthesisUtterance(word);
    utterance.lang = 'en-US';
    window.speechSynthesis.speak(utterance);
}

if (volumeBtn) {
    volumeBtn.onclick = () => playAudio(questions[currentIndex].word);
}

function loadQuestion() {
    const q = questions[currentIndex];
    const display = document.getElementById('word-display');
    const checkBtn = document.getElementById('check-btn');

    res.innerHTML = "";
    res.style.display = "none";
    display.innerHTML = '';
    document.getElementById('card-image').src = q.image;
    document.getElementById('card-phonetic').innerText = q.phonetic;
    document.getElementById('progress-text').innerText = `${currentIndex + 1}/${questions.length}`;
    feedbackMsg.innerText = '';

    checkBtn.disabled = false;
    isLocked = false;

    q.word.split('').forEach((char, index) => {
        const input = document.createElement('input');
        input.type = 'text';
        input.maxLength = 1;
        input.classList.add('char-box');

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

function checkAnswer() {
    if (isLocked) return;

    const q = questions[currentIndex];
    const inputs = document.querySelectorAll('.char-box');
    let allCorrect = true;

    inputs.forEach((input, i) => {
        const userChar = input.value.toLowerCase();
        const correctChar = q.word[i].toLowerCase();

        res.innerHTML = q.word;
        res.style.display = "block";

        if (userChar === correctChar) {
            input.classList.add('correct');
        } else {
            input.classList.add('wrong');
            // input.value = correctChar;
            allCorrect = false;
        }
        input.readOnly = true;
    });

    // CẬP NHẬT ĐIỂM Ở ĐÂY
    if (allCorrect) score.correct++; else score.wrong++;

    isLocked = true;
    document.getElementById('check-btn').disabled = true;
    feedbackMsg.innerText = allCorrect ? "Chính xác!" : `Sai rồi!`;

    setTimeout(() => {
        if (currentIndex < questions.length - 1) {
            currentIndex++;
            loadQuestion();
        } else {
            showResult();
        }
    }, 2000);
}

// GET DATE
function getCurrentDate() {
    const today = new Date();

    const day = today.getDate();
    const month = today.getMonth() + 1;
    const year = today.getFullYear();

    return `${day}/${month}/${year}`;
}

//DISPLAY RES
function showResult() {
    document.getElementById('game-screen').classList.add('hidden');
    document.getElementById('result-screen').classList.remove('hidden');

    document.getElementById('res-correct').innerText = score.correct;
    document.getElementById('res-wrong').innerText = score.wrong;
    document.getElementById("txt-correct").innerText = score.correct + " Correct";
    document.getElementById("txt-wrong").innerText = score.wrong + " Wrong"
    document.getElementById("date").innerText = getCurrentDate();
}

function restartGame() {
    currentIndex = 0;
    score = { correct: 0, wrong: 0 };
    document.getElementById('result-screen').classList.add('hidden');
    document.getElementById('game-screen').classList.remove('hidden');
    loadQuestion();
}

loadQuestion();

// INFOR
document.addEventListener('DOMContentLoaded', () => {
    const trigger = document.getElementById('userDropdownTrigger');
    const dropdown = document.getElementById('infoDropdown');
    const arrow = trigger.querySelector('.mini-arrow');

    // Click vào Nguyễn Văn A để bật/tắt menu
    trigger.addEventListener('click', (e) => {
        e.stopPropagation(); // Ngăn sự kiện nổi bọt
        dropdown.classList.toggle('show');

        // Xoay mũi tên nếu có
        if (arrow) {
            arrow.style.transform = dropdown.classList.contains('show') ? 'rotate(180deg)' : 'rotate(0deg)';
        }
    });

    // Click ra ngoài menu thì tự động đóng lại (UX tốt hơn)
    document.addEventListener('click', () => {
        dropdown.classList.remove('show');
        if (arrow) arrow.style.transform = 'rotate(0deg)';
    });
});