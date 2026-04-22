document.addEventListener('DOMContentLoaded', () => {
    // Logic chuyển trang đơn giản (UI only)
    const pages = document.querySelectorAll('.pagination span');
    pages.forEach(page => {
        page.addEventListener('click', () => {
            if (!isNaN(page.innerText)) {
                document.querySelector('.pagination .active').classList.remove('active');
                page.classList.add('active');
            }
        });
    });
});

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

const wordData = [
    { eng: "Hello", vie: "Xin chào", img: "https://th.bing.com/th/id/OIP.tV1Yut2akoObzBb9nU_P-AHaD4?w=276&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3" },
    { eng: "Lion", vie: "Sư tử", img: "https://th.bing.com/th/id/OIP.1v1LyOL7jzgNndpyVfDlGAHaFj?w=234&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3" },
    { eng: "Tree", vie: "Cây cối", img: "https://th.bing.com/th/id/OIP.9JdJHb8SjAuBbZErEIEmbQHaFW?w=223&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3" },
    { eng: "Pollution", vie: "Ô nhiễm", img: "https://th.bing.com/th/id/OIP.7YBSNMI5DuG5XUqmzuHdiQHaDt?w=349&h=174&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3" },
    { eng: "Spring", vie: "Mùa xuân", img: "https://th.bing.com/th/id/R.5b17d0a45f3ebb0f5e45cd0af1463e0d?rik=97RscHNho7ZACA&pid=ImgRaw&r=0" }
];

const cardsGrid = document.getElementById('cardsGrid');

function renderCards() {
    cardsGrid.innerHTML = wordData.map(word => `
        <div class="card">
            <a href="/src/fe/admin/course/view.html">
                <div class="card-bg" style="background-image: url('${word.img}')"></div>

                <div class="card-content">
                    <h3>${word.eng}</h3>
                    <p>${word.vie}</p>
                </div>
            </a>
           
            <div class="audio-icon" onclick="playAudio('${word.eng}')">
                <i class="fa-solid fa-volume-high"></i>
            </div>
            <div class="card-action">
                <a href="/src/fe/admin/course/update.html" style="display: flex;">
                    <i class="fas fa-wrench fix_deck"></i>
                </a>
                <i class="fas fa-trash-alt trash"></i>
            </div>
        </div>
    `).join('');
}
function removeActionCard() {
    const item = document.location.pathname;
    const action = document.querySelectorAll(".card-action");

    if (item === "/src/fe/admin/deck/view.html") {
        action.forEach(i => {
            i.style.display = "none";
        })

    }

}

function playAudio(word) {
    // Giả lập phát âm thanh (Có thể dùng Web Speech API)
    const utterance = new SpeechSynthesisUtterance(word);
    utterance.lang = 'en-US';
    window.speechSynthesis.speak(utterance);
}

// Chạy hàm render khi trang web tải xong
document.addEventListener('DOMContentLoaded', renderCards);
document.addEventListener('DOMContentLoaded', removeActionCard);

//Delete
cardsGrid.addEventListener("click", function (e) {
    console.log(e);
    if (e.target.classList.contains("trash")) {

        const card = e.target.closest(".card");

        card.remove();

    }

});

const img = document.getElementById("img");

let currentURL = null;
if (img) {
    img.addEventListener("change", function () {

        const file = this.files[0];
        if (!file) return;

        if (currentURL) {
            URL.revokeObjectURL(currentURL);
        }

        currentURL = URL.createObjectURL(file);
        console.log(currentURL);
        const popupImage = document.querySelector(".upload-box");
        popupImage.innerHTML = "";
        popupImage.style.backgroundImage = `url(${currentURL})`;
        popupImage.style.backgroundSize = "cover";
        popupImage.style.backgroundPosition = "center";

    });
}


