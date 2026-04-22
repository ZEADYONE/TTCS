let currentURL = null;

fileInput.addEventListener("change", function () {

    const file = this.files[0];
    if (!file) return;

    if (currentURL) {
        URL.revokeObjectURL(currentURL);
    }
    const imageBox = document.querySelector(".image-box");
    currentURL = URL.createObjectURL(file);

    imageBox.style.backgroundImage = `url(${currentURL})`;
    imageBox.style.backgroundSize = "cover";
    imageBox.style.backgroundPosition = "center";

    imageBox.innerHTML = "";
});