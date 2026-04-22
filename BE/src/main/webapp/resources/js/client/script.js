// Xử lý bật/tắt dropdown bộ lọc
const filterBtn = document.getElementById('filterBtn');
const filterDropdown = document.getElementById('filterDropdown');

if (filterBtn && filterDropdown) {

    filterBtn.addEventListener('click', (e) => {
        filterDropdown.classList.toggle('show');
        e.stopPropagation();
    });

    window.addEventListener('click', () => {
        filterDropdown.classList.remove('show');
    });

    filterDropdown.addEventListener('click', (e) => {
        e.stopPropagation();
    });

}

// Highlight Menu
const currentPage = window.location.pathname;

document.querySelectorAll(".nav-item").forEach(link => {
    if (link.getAttribute("href") === currentPage) {
        link.classList.add("active");
    }
    console.log(window.location);
});




// Popup
const fixDeck = document.querySelectorAll(".fix_deck");
const createDeck = document.querySelectorAll(".btn-create");
const popupContainer = document.getElementById("container-popup");

const popupTitle = document.getElementById("popup-title");
const popupDesc = document.getElementById("popup-desc");
const popupImg = document.getElementById("popup-image");
const feature = document.getElementById("feature");


const saveBtn = document.getElementById("save");
const cancelBtn = document.getElementById("cancel");

const form = document.getElementById("form-popup")
const deckIdInput = document.getElementById("deck-id");

let currentCard = null;
// POPUP EDIT DECK
fixDeck.forEach(item => {

    item.addEventListener("click", function () {

        const card = item.closest(".deck-card");
        currentCard = card;

        const id = card.getAttribute("data-id");
        const title = card.querySelector("h3").innerText;
        const desc = card.querySelector("p").innerText;
        const img = card.querySelector("img").getAttribute("src");

        deckIdInput.value = id;
        deckIdInput.setAttribute("name", "id");

        popupTitle.value = title;
        popupDesc.value = desc;
        popupImg.style.backgroundImage = `url('${img}')`;

        feature.innerHTML = "Edit Deck";

        form.action = "/client/deck/update";

        popupContainer.style.display = "flex";
    });

});

// POPUP CREATE DECK
createDeck.forEach(item => {
    item.addEventListener("click", function () {

        deckIdInput.removeAttribute("name");

        popupTitle.value = "";
        popupDesc.value = "";
        feature.innerHTML = "Create Deck";

        popupImg.style.backgroundImage = "";
        popupImg.innerHTML = "";

        const i = document.createElement("i");
        i.classList.add("fa-solid", "fa-upload");

        popupImg.appendChild(i);

        form.action = "/client/deck/create";
        popupContainer.style.display = "flex";
    })
})

// Đóng popup
cancelBtn.addEventListener("click", () => {
    popupContainer.style.display = "none";
});

// CANCEL
cancelBtn.addEventListener("click", function () {
    popupContainer.style.display = "none";
});


// CLICK OUTSIDE POPUP
popupContainer.addEventListener("click", function (e) {

    if (e.target === popupContainer) {
        popupContainer.style.display = "none";
    }

});

const img = document.getElementById("img");

let currentURL = null;

if (img) {
    img.addEventListener("change", function () {

        const file = this.files[0];
        if (!file) return;

        // Xóa URL cũ tránh memory leak
        if (currentURL) {
            URL.revokeObjectURL(currentURL);
        }

        currentURL = URL.createObjectURL(file);

        const popupImage = document.querySelector(".popup-image");

        popupImage.innerHTML = "";
        popupImage.style.backgroundImage = `url('${currentURL}')`;
        popupImage.style.backgroundSize = "cover";
        popupImage.style.backgroundPosition = "center";
        popupImage.style.backgroundRepeat = "no-repeat";
    });
}


