<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interactive Game - ${deck.title}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="/css/admin/header-slide.css">
    <link rel="stylesheet" href="/css/admin/interaction.css">
</head>

<body>
    <header class="top-nav">
        <div class="brand">
            <h1>English Learning Platform</h1>
            <p>Interactive Course Configuration</p>
        </div>
        <a class="header-back" href="/admin/course">
            <i class="fa-solid fa-arrow-left"></i> Course list
        </a>
    </header>

    <main class="interaction-admin">
        <section class="page-heading">
            <div>
                <p class="eyebrow">ADMIN COURSE</p>
                <h2>${deck.title}</h2>
                <p>${deck.des}</p>
            </div>
            <a class="preview-button" href="/admin/course/${deck.id}/interaction/preview">
                <i class="fa-regular fa-eye"></i> Preview
            </a>
        </section>

        <c:if test="${not empty successMessage}">
            <div class="alert success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert error">${errorMessage}</div>
        </c:if>

        <nav class="section-nav">
            <a href="#general">Cấu hình chung</a>
            <a href="#tasks">Task / Round</a>
        </nav>

        <section class="panel" id="general">
            <div class="panel-heading">
                <div>
                    <span class="step-number">1</span>
                    <h3>Template và Theme</h3>
                </div>
                <span class="state-pill ${config.enabled ? 'enabled' : 'disabled'}">
                    ${config.enabled ? 'Đang bật' : 'Đang tắt'}
                </span>
            </div>

            <div class="architecture-note">
                Template quyết định luật chơi. Theme quyết định giao diện và chỉ hiển thị khi tương thích
                với template. Hiệu ứng và chướng ngại được lập trình viên đóng gói sẵn trong hai thành phần này.
            </div>

            <form class="form-grid" action="/admin/course/${deck.id}/interaction/config" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                <label class="toggle-field">
                    <input type="checkbox" name="enabled" value="true" ${config.enabled ? 'checked' : ''}>
                    <span>Bật “Chơi tương tác” cho học viên</span>
                </label>

                <label>
                    Template
                    <select name="templateKey" id="templateKey" required>
                        <c:forEach var="template" items="${templates}">
                            <option value="${template.key}"
                                ${config.templateKey == template.key ? 'selected' : ''}>
                                ${template.displayName}
                            </option>
                        </c:forEach>
                    </select>
                </label>

                <label>
                    Theme tương thích
                    <select name="themeKey" id="themeKey" required>
                        <c:forEach var="theme" items="${themes}">
                            <option value="${theme.key}" data-template="${theme.templateKey}"
                                ${config.themeKey == theme.key ? 'selected' : ''}>
                                ${theme.displayName}
                            </option>
                        </c:forEach>
                    </select>
                </label>

                <div class="wide theme-description" id="themeDescription"></div>
                <c:forEach var="theme" items="${themes}">
                    <span class="theme-description-source" data-theme="${theme.key}" hidden>
                        ${theme.description}
                    </span>
                </c:forEach>

                <label>
                    Character name
                    <input name="characterName" value="${config.characterName}" maxlength="100">
                </label>

                <label>
                    Character emoji
                    <input name="characterEmoji" value="${config.characterEmoji}" maxlength="20">
                </label>

                <label class="wide">
                    Intro text
                    <textarea name="introText" rows="2">${config.introText}</textarea>
                </label>

                <label class="wide">
                    Completion text
                    <textarea name="completionText" rows="2">${config.completionText}</textarea>
                </label>

                <div class="wide form-actions">
                    <button class="primary-button" type="submit">Lưu cấu hình chung</button>
                </div>
            </form>
        </section>

        <section class="panel" id="tasks">
            <div class="panel-heading">
                <div>
                    <span class="step-number">2</span>
                    <h3>Task / Round</h3>
                </div>
                <span>${tasks.size()} rounds</span>
            </div>

            <div class="empty-note">
                Mỗi round có đúng 3 lựa chọn: target card và 2 card ngẫu nhiên khác trong deck.
                <c:if test="${config.templateKey == 'ACTION'}">
                    Template ACTION yêu cầu chọn riêng hành động cho từng round.
                </c:if>
            </div>

            <div class="task-list">
                <c:forEach var="task" items="${tasks}" varStatus="status">
                    <article class="task-card">
                        <div class="task-title">
                            <strong>Round ${task.orderIndex}</strong>
                            <div class="task-order-actions">
                                <form action="/admin/course/${deck.id}/interaction/tasks/${task.id}/move"
                                    method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <input type="hidden" name="direction" value="up">
                                    <button type="submit" title="Move up" ${status.first ? 'disabled' : ''}>
                                        <i class="fa-solid fa-arrow-up"></i>
                                    </button>
                                </form>
                                <form action="/admin/course/${deck.id}/interaction/tasks/${task.id}/move"
                                    method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <input type="hidden" name="direction" value="down">
                                    <button type="submit" title="Move down" ${status.last ? 'disabled' : ''}>
                                        <i class="fa-solid fa-arrow-down"></i>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <form class="task-form" action="/admin/course/${deck.id}/interaction/tasks" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            <input type="hidden" name="taskId" value="${task.id}">

                            <label class="wide">
                                Prompt
                                <textarea name="promptText" rows="2" required>${task.promptText}</textarea>
                            </label>

                            <label>
                                Target card
                                <select name="targetCardId" required>
                                    <option value="">-- Chọn card --</option>
                                    <c:forEach var="card" items="${cards}">
                                        <option value="${card.id}"
                                            ${task.targetCard.id == card.id ? 'selected' : ''}>
                                            ${card.word}
                                        </option>
                                    </c:forEach>
                                </select>
                            </label>

                            <c:if test="${config.templateKey == 'ACTION'}">
                                <label>
                                    Action variant
                                    <select name="templateVariant" required>
                                        <option value="">-- Chọn hành động --</option>
                                        <c:forEach var="variant" items="${variants}">
                                            <option value="${variant.key}"
                                                ${task.templateVariant == variant.key ? 'selected' : ''}>
                                                ${variant.displayName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </label>
                            </c:if>

                            <label class="wide">
                                Success text
                                <input name="successText" value="${task.successText}">
                            </label>

                            <label class="wide">
                                Wrong text
                                <input name="wrongText" value="${task.wrongText}">
                            </label>

                            <div class="wide task-buttons">
                                <button class="small-button" type="submit">Update round</button>
                            </div>
                        </form>

                        <form class="delete-task"
                            action="/admin/course/${deck.id}/interaction/tasks/${task.id}/delete" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            <button type="submit" onclick="return confirm('Xóa round này?')">
                                <i class="fa-solid fa-trash"></i> Delete
                            </button>
                        </form>
                    </article>
                </c:forEach>
            </div>

            <article class="task-card new-task">
                <div class="task-title">
                    <strong>Thêm round mới</strong>
                </div>
                <form class="task-form" action="/admin/course/${deck.id}/interaction/tasks" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <label class="wide">
                        Prompt
                        <textarea name="promptText" rows="2" required></textarea>
                    </label>

                    <label>
                        Target card
                        <select name="targetCardId" required>
                            <option value="">-- Chọn card --</option>
                            <c:forEach var="card" items="${cards}">
                                <option value="${card.id}">${card.word}</option>
                            </c:forEach>
                        </select>
                    </label>

                    <c:if test="${config.templateKey == 'ACTION'}">
                        <label>
                            Action variant
                            <select name="templateVariant" required>
                                <option value="">-- Chọn hành động --</option>
                                <c:forEach var="variant" items="${variants}">
                                    <option value="${variant.key}">${variant.displayName}</option>
                                </c:forEach>
                            </select>
                        </label>
                    </c:if>

                    <label class="wide">
                        Success text
                        <input name="successText">
                    </label>

                    <label class="wide">
                        Wrong text
                        <input name="wrongText">
                    </label>

                    <div class="wide form-actions">
                        <button class="primary-button" type="submit">Add round</button>
                    </div>
                </form>
            </article>
        </section>
    </main>

    <script>
        (() => {
            const templateSelect = document.getElementById("templateKey");
            const themeSelect = document.getElementById("themeKey");
            const description = document.getElementById("themeDescription");

            function updateThemes() {
                const templateKey = templateSelect.value;
                let selectedIsValid = false;
                Array.from(themeSelect.options).forEach((option) => {
                    const compatible = option.dataset.template === templateKey;
                    option.hidden = !compatible;
                    option.disabled = !compatible;
                    if (compatible && option.selected) selectedIsValid = true;
                });
                if (!selectedIsValid) {
                    const firstCompatible = Array.from(themeSelect.options)
                        .find((option) => !option.disabled);
                    if (firstCompatible) firstCompatible.selected = true;
                }
                const source = document.querySelector(
                    ".theme-description-source[data-theme=\"" + themeSelect.value + "\"]"
                );
                description.textContent = source ? source.textContent.trim() : "";
            }

            templateSelect.addEventListener("change", updateThemes);
            themeSelect.addEventListener("change", updateThemes);
            updateThemes();
        })();
    </script>
</body>

</html>
