document.addEventListener('DOMContentLoaded', () => {
    // Hiệu ứng khi nhấn nút Bắt đầu ngay
    // const btnStart = document.querySelector('.btn-start');
    // btnStart.addEventListener('click', () => {
    //     alert('Chào mừng bạn đến với hành trình chinh phục tiếng Anh!');
    // });

    // Thêm hiệu ứng xuất hiện dần cho các Step Card khi cuộn chuột (tùy chọn)
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    });

    document.querySelectorAll('.step-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = '0.5s ease-out';
        observer.observe(card);
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