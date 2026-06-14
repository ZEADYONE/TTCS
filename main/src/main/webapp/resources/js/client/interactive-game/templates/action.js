(function (registry) {
    const variants = Object.freeze({
        JUMP: { effect: "character-jump-over", obstacle: "hurdle" },
        SWIM: { effect: "character-swim-over", obstacle: "pool" },
        RUN: { effect: "character-run-over", obstacle: "track" }
    });

    function renderObstacle(container, obstacleType) {
        container.replaceChildren();
        const obstacle = document.createElement("div");
        obstacle.className = `obstacle obstacle--${obstacleType}`;

        if (obstacleType === "hurdle") {
            obstacle.innerHTML = "<span></span><span></span><span></span>";
        } else if (obstacleType === "pool") {
            obstacle.innerHTML = "<span class='wave'></span><span class='wave second'></span>";
        } else if (obstacleType === "track") {
            obstacle.innerHTML = "<span class='finish-line'></span>";
        }
        container.appendChild(obstacle);
    }

    registry.registerTemplate({
        handlerKey: "action",
        dropHint: "Chọn hành động đúng",
        renderRound(context, task) {
            const variant = variants[task.templateVariant];
            if (!variant) {
                throw new Error("Round ACTION chưa có hành động hợp lệ.");
            }
            renderObstacle(context.obstacleZone, variant.obstacle);
        },
        successEffect(task) {
            return variants[task.templateVariant].effect;
        }
    });
})(window.InteractiveGameRegistry);
