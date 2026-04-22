
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