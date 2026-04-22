// 
const questions = [
    {
        word: "Hello",
        phonetic: "/heˈləʊ/",
        image: "https://th.bing.com/th/id/OIP.tV1Yut2akoObzBb9nU_P-AHaD4?w=276&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
        meaning: "Xin chào",
        definition: "Hello là một thán từ trong tiếng Anh dùng để chào hỏi hoặc bắt đầu cuộc trò chuyện, thường được sử dụng khi gặp ai đó, khi bắt đầu nói chuyện hoặc khi nghe điện thoại, với ý nghĩa tương đương “xin chào” trong tiếng Việt",
        example: "Hello, this is John speaking",
    },
    {
        word: "Lion",
        phonetic: "/ˈlaɪ.ən/",
        image: "https://th.bing.com/th/id/OIP.1v1LyOL7jzgNndpyVfDlGAHaFj?w=234&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
        meaning: "Sư tử",
        definition: "Sư tử là một loài động vật ăn thịt lớn thuộc họ mèo, sống chủ yếu ở châu Phi và một phần Ấn Độ. Chúng nổi tiếng với sức mạnh, tiếng gầm lớn và thường được gọi là “vua của muôn thú",
        example: "The lion is resting under a tree after hunting"
    },
    {
        word: "Tree",
        phonetic: "/triː/",
        image: "https://th.bing.com/th/id/OIP.9JdJHb8SjAuBbZErEIEmbQHaFW?w=223&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
        meaning: "Cây cối",
        definition: "Cây là một loại thực vật lớn có thân gỗ, rễ, cành và lá, thường sống lâu năm và phát triển cao hơn nhiều loại thực vật khác. Cây đóng vai trò quan trọng trong tự nhiên như cung cấp oxy, bóng mát và môi trường sống cho động vật",
        example: "The tree in my garden gives a lot of shade in the summer"
    },
    {
        word: "Pollution",
        phonetic: "/pəˈluː.ʃən/",
        image: "https://th.bing.com/th/id/OIP.7YBSNMI5DuG5XUqmzuHdiQHaDt?w=349&h=174&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
        meaning: "Ô nhiễm",
        definition: "Ô nhiễm là tình trạng môi trường (không khí, nước hoặc đất) bị làm bẩn hoặc bị hư hại bởi các chất độc hại, rác thải hoặc hoạt động của con người, gây ảnh hưởng xấu đến sức khỏe con người, động vật và thiên nhiên",
        example: "Air pollution in big cities can cause serious health problems"
    },
    {
        word: "Spring",
        phonetic: "/sprɪŋ/",
        image: "https://th.bing.com/th/id/R.5b17d0a45f3ebb0f5e45cd0af1463e0d?rik=97RscHNho7ZACA&pid=ImgRaw&r=0",
        meaning: "Mùa xuân",
        definition: "Mùa xuân là một trong bốn mùa trong năm, xảy ra sau mùa đông và trước mùa hè. Đây là thời điểm thời tiết trở nên ấm hơn, cây cối bắt đầu đâm chồi và nở hoa",
        example: "Many flowers bloom in spring"
    }
];

// ... Giữ nguyên mảng questions của bạn ...

let currentIndex = 0;
let correctCount = 0;
let incorrectCount = 0;

const flashcard = document.getElementById('flashcard');
const gameScreen = document.getElementById('game-screen');
const resultScreen = document.getElementById('result-screen');

// Hàm xử lý khi nhấn Correct hoặc Wrong
function handleAnswer(isCorrect) {
    if (isCorrect) {
        correctCount++;
    } else {
        incorrectCount++;
    }

    // Luôn lật về mặt trước khi sang câu mới
    flashcard.classList.remove('flipped');

    setTimeout(() => {
        currentIndex++;

        if (currentIndex < questions.length) {
            updateUI();
        } else {
            showResults();
        }
    }, 150);
}

// Hàm hiển thị màn hình kết quả
function showResults() {
    gameScreen.classList.add('hidden');
    resultScreen.classList.remove('hidden');

    document.getElementById('correct-count').innerText = correctCount;
    document.getElementById('incorrect-count').innerText = incorrectCount;
}

// Hàm chơi lại
function restartGame() {
    currentIndex = 0;
    correctCount = 0;
    incorrectCount = 0;

    resultScreen.classList.add('hidden');
    gameScreen.classList.remove('hidden');

    updateUI();
}

// Cập nhật giao diện (Giữ nguyên logic của bạn nhưng sửa ID progress)
function updateUI() {
    const q = questions[currentIndex];
    document.getElementById('card-word').innerText = q.word;
    document.getElementById('card-phonetic').innerText = q.phonetic;
    document.getElementById('card-image').src = q.image;
    document.getElementById('card-meaning').innerText = q.meaning;
    document.getElementById('progress-text').innerText = `${currentIndex + 1}/${questions.length}`;
    document.getElementById('card-exp').innerText = q.example;
    document.getElementById('card-defi').innerText = q.definition;
}

function flipCard() {
    flashcard.classList.toggle('flipped');
}

// SOUND
const volumeBtn = document.querySelector(".fa-volume-high");

function playAudio(word) {
    const utterance = new SpeechSynthesisUtterance(word);
    utterance.lang = 'en-US';
    window.speechSynthesis.speak(utterance);
}

if (volumeBtn) {
    volumeBtn.onclick = () => playAudio(questions[currentIndex].word);
}
// Khởi tạo
updateUI();

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