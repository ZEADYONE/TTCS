
// Popup
const fixRole = document.querySelectorAll(".btn-edit");
const createDeck = document.querySelectorAll(".btn-create");
const popupContainer = document.getElementById("container-popup");

const popupTitle = document.getElementById("popup-title");
const feature = document.getElementById("feature");


const saveBtn = document.getElementById("save");
const cancelBtn = document.getElementById("cancel");

// POPUP EDIT DECK
fixRole.forEach(item => {

    item.addEventListener("click", function () {

        const roleName = item.closest("tr");

        popupTitle.value = roleName.querySelector(".RoleName").innerText;

        feature.innerHTML = "Edit Role";


        popupContainer.style.display = "flex";

    });

});

// POPUP CREATE DECK
createDeck.forEach(item => {
    item.addEventListener("click", function () {

        popupTitle.value = "";
        feature.innerHTML = "Create Role";
        popupContainer.style.display = "flex";
    })
})

// SAVE CHANGE
saveBtn.addEventListener("click", function () {

    if (!currentCard) return;

    currentCard.querySelector("h3").innerText = popupTitle.value;

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