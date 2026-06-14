(function (registry) {
    registry.registerTemplate({
        handlerKey: "feed",
        dropHint: "Kéo thẻ vào nhân vật",
        renderRound(context) {
            context.obstacleZone.replaceChildren();
        },
        successEffect() {
            return "character-eat";
        }
    });
})(window.InteractiveGameRegistry);
