// document.getElementById('addCardForm').addEventListener('submit', function (e) {
//     e.preventDefault();

//     // Thu thập dữ liệu từ các input
//     const cardData = {
//         word: document.getElementById('word').value,
//         transliteration: document.getElementById('transliteration').value,
//         vietnamese: document.getElementById('vietnamese').value,
//         example: document.getElementById('example').value,
//         definition: document.getElementById('definition').value,
//         sound: document.getElementById('sound').value
//     };
// });

// Xử lý xem trước ảnh khi chọn file (tùy chọn)
// document.getElementById('fileInput').addEventListener('change', function (e) {
//     const file = e.target.files[0];
//     if (file) {
//         const reader = new FileReader();
//         reader.onload = function (event) {
//             const imageBox = document.querySelector('.image-box');
//             imageBox.style.backgroundImage = `url(${event.target.result})`;
//             imageBox.style.backgroundSize = 'cover';
//             imageBox.style.backgroundPosition = 'center';
//             imageBox.innerHTML = ''; // Xóa icon upload
//         }
//         reader.readAsDataURL(file);
//     }
// });


//PREVIEW IMAGE

let currentURL = null;

fileInput.addEventListener("change", function () {

    const file = this.files[0];
    if (!file) return;

    if (currentURL) {
        URL.revokeObjectURL(currentURL);
    }
    const imageBox = document.querySelector(".image-box");
    currentURL = URL.createObjectURL(file);

    imageBox.style.backgroundImage = `url(${currentURL})`;
    imageBox.style.backgroundSize = "cover";
    imageBox.style.backgroundPosition = "center";

    imageBox.innerHTML = "";
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