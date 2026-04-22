
const view = document.querySelectorAll(".btn-view");
view.forEach(item => {
    item.addEventListener("click", function () {
        window.location.href = "http://127.0.0.1:5500/src/fe/admin/user/view.html";
    });
})

const update = document.querySelectorAll(".btn-edit");
update.forEach(item => {
    item.addEventListener("click", function () {
        window.location.href = "http://127.0.0.1:5500/src/fe/admin/user/update.html";
    });
})