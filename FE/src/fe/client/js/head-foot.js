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