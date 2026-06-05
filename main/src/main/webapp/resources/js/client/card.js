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

document.addEventListener("DOMContentLoaded", function () {
    const btnGenAI = document.getElementById("btnGenAI");
    if (btnGenAI) {
        btnGenAI.addEventListener("click", function () {
            const wordInput = document.querySelector('input[name="word"]');
            const word = wordInput ? wordInput.value.trim() : "";

            if (!word) {
                alert("Vui lòng nhập từ vựng");
                return;
            }

            const originalText = btnGenAI.innerText;
            btnGenAI.disabled = true;
            btnGenAI.innerText = "Generating...";

            const csrfToken = document.querySelector('input[name="_csrf"]').value;

            fetch('/api/ai/flashcards/generate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': csrfToken
                },
                body: JSON.stringify({ word: word })
            })
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(text => { throw new Error(text) });
                    }
                    return response.json();
                })
                .then(data => {
                    const transInput = document.querySelector('input[name="trans"]');
                    const meanInput = document.querySelector('input[name="mean"]');
                    const exampleTextarea = document.querySelector('textarea[name="example"]');
                    const definitionTextarea = document.querySelector('textarea[name="definition"]');

                    if (transInput && data.transliteration) transInput.value = data.transliteration;
                    if (meanInput && data.vietnamese) meanInput.value = data.vietnamese;
                    if (exampleTextarea && data.example) exampleTextarea.value = data.example;
                    if (definitionTextarea && data.definition) definitionTextarea.value = data.definition;
                })
                .catch(error => {
                    console.error("Error generating AI content:", error);
                    alert("Failed to generate AI content: " + error.message);
                })
                .finally(() => {
                    btnGenAI.disabled = false;
                    btnGenAI.innerText = originalText;
                });
        });
    }
});