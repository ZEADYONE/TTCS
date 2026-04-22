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

// 2. Logic Audio
// Control: Xử lý giọng đọc
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

// Lắng nghe sự kiện (Boundary -> Control)
document.addEventListener('click', (e) => {
    // Kiểm tra xem user có click vào icon loa hoặc div bao quanh không
    const btn = e.target.closest('.audio-icon');

    if (btn) {
        const word = btn.getAttribute('data-word');
        VoiceControl.speak(word);
    }
});

const fileInput = document.getElementById('fileInput');
const uploadBox = document.getElementById('uploadBox'); // Khớp với ID trong HTML
let currentURL = null;

if (fileInput) {
    fileInput.addEventListener("change", function () {
        const file = this.files[0];
        if (!file) return;

        // Giải phóng bộ nhớ nếu có URL cũ
        if (currentURL) {
            URL.revokeObjectURL(currentURL);
        }

        // Tạo URL tạm thời cho file mới chọn
        currentURL = URL.createObjectURL(file);

        // Cập nhật background cho uploadBox
        uploadBox.style.backgroundImage = `url('${currentURL}')`;
        uploadBox.style.backgroundSize = "cover";
        uploadBox.style.backgroundPosition = "center";

        // Xóa nội dung bên trong (ví dụ các icon hoặc text "Click to upload")
        uploadBox.innerHTML = "";
    });

}
