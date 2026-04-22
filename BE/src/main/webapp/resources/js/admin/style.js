document.querySelectorAll('.menu-item').forEach(item => {
    item.addEventListener('click', function (e) {
        // Xóa class active ở tất cả các item
        document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));

        // Thêm class active vào mục vừa click
        this.classList.add('active');
    });
});


// BANNER

// const lockButtons = document.querySelectorAll(".btn-lock, .btn-unlock");

// lockButtons.forEach(function (btn) {

//     btn.addEventListener("click", function () {

//         const icon = this;

//         const row = icon.closest("tr");

//         const statusCell = row.querySelector(".status");

//         if (icon.classList.contains("btn-lock")) {

//             icon.classList.remove("fa-lock", "btn-lock");
//             icon.classList.add("fa-lock-open", "btn-unlock");

//             statusCell.textContent = "Active";

//         } else {

//             icon.classList.remove("fa-lock-open", "btn-unlock");
//             icon.classList.add("fa-lock", "btn-lock");

//             statusCell.textContent = "Banned";

//         }

//     });

// });

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
