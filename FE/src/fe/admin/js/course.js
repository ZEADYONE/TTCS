const fixDeck = document.querySelectorAll(".fix_deck");
const createDeck = document.querySelectorAll(".btn-create");
const popupContainer = document.getElementById("container-popup");

const popupTitle = document.getElementById("popup-title");
const popupDesc = document.getElementById("popup-desc");
const popupImg = document.getElementById("popup-image");
const feature = document.getElementById("feature");


const saveBtn = document.getElementById("save");
const cancelBtn = document.getElementById("cancel");

let currentCard = null;
// POPUP EDIT DECK
fixDeck.forEach(item => {

    item.addEventListener("click", function () {

        const card = item.closest(".deck-card");

        currentCard = card;

        const title = card.querySelector("h3").innerText;
        const desc = card.querySelector("p").innerText;
        const img = card.querySelector("img").getAttribute("src");

        popupTitle.value = title;
        popupDesc.value = desc;
        popupImg.style.backgroundImage = `url('${img}')`;

        feature.innerHTML = "Edit Deck";


        popupContainer.style.display = "flex";

    });

});

// POPUP CREATE DECK
createDeck.forEach(item => {
    item.addEventListener("click", function () {

        popupTitle.value = "";
        popupDesc.value = "";
        feature.innerHTML = "Create Deck";

        popupImg.style.backgroundImage = "";
        popupImg.innerHTML = ""; // xóa nội dung cũ

        const i = document.createElement("i");
        i.classList.add("fa-solid", "fa-upload");

        popupImg.appendChild(i); // thêm icon vào div

        popupContainer.style.display = "flex";
    })
})


// SCOPE POPUP
const scopeSelect = document.getElementById("popup-scope");
const icon = document.querySelector(".status-icon");

scopeSelect.addEventListener("change", function () {

    if (scopeSelect.value === "Private") {
        icon.classList.remove("fa-globe");
        icon.classList.add("fa-lock");
    } else {
        icon.classList.remove("fa-lock");
        icon.classList.add("fa-globe");
    }

});

// SAVE CHANGE
saveBtn.addEventListener("click", function () {

    if (!currentCard) return;

    currentCard.querySelector("h3").innerText = popupTitle.value;
    currentCard.querySelector("p").innerText = popupDesc.value;

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

// DELETE DECK
const trash = document.querySelectorAll(".trash");

trash.forEach(item => {
    item.addEventListener("click", function () {
        const deck = item.closest(".deck-card");
        deck.style.display = "none";
    })
})


const img = document.getElementById("img");

let currentURL = null;

img.addEventListener("change", function () {

    const file = this.files[0];
    if (!file) return;

    if (currentURL) {
        URL.revokeObjectURL(currentURL);
    }

    currentURL = URL.createObjectURL(file);
    console.log(currentURL);
    const popupImage = document.querySelector(".popup-image");
    popupImage.innerHTML = "";
    popupImage.style.backgroundImage = `url(${currentURL})`;
    popupImage.style.backgroundSize = "cover";
    popupImage.style.backgroundPosition = "center";

});
