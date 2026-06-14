(function (registry) {
    registry.registerTheme({
        key: "GARDEN_FEAST",
        templateKey: "FEED",
        sceneClass: "theme--garden-feast"
    });
    registry.registerTheme({
        key: "PLAYGROUND_ADVENTURE",
        templateKey: "ACTION",
        sceneClass: "theme--playground-adventure"
    });
    registry.registerTheme({
        key: "COLOR_WORLD",
        templateKey: "SELECT",
        sceneClass: "theme--color-world"
    });
})(window.InteractiveGameRegistry);
