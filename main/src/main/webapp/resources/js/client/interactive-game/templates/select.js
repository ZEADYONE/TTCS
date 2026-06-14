(function (registry) {
    registry.registerTemplate({
        handlerKey: "select",
        dropHint: "Chọn thẻ đúng",
        renderRound(context) {
            context.obstacleZone.replaceChildren();
        },
        successEffect() {
            return "character-happy";
        }
    });
})(window.InteractiveGameRegistry);
