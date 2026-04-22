document.querySelectorAll('.menu-item').forEach(item => {
    item.addEventListener('click', function (e) {
        // Xóa class active ở tất cả các item
        document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));

        // Thêm class active vào mục vừa click
        this.classList.add('active');
    });
});


const filterBtn = document.getElementById('filterBtn');
const filterMenu = document.getElementById('filterMenu');

// Toggle menu filter
filterBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    const isVisible = filterMenu.style.display === 'flex';
    filterMenu.style.display = isVisible ? 'none' : 'flex';
});

// Đóng menu nếu click ra ngoài
document.addEventListener('click', () => {
    filterMenu.style.display = 'none';
});

// Ngăn menu bị đóng khi click bên trong nó
filterMenu.addEventListener('click', (e) => {
    e.stopPropagation();
});
