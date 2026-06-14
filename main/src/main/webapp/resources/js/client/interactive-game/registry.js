(function () {
    const templates = new Map();
    const themes = new Map();

    window.InteractiveGameRegistry = {
        registerTemplate(definition) {
            templates.set(definition.handlerKey, Object.freeze(definition));
        },
        registerTheme(definition) {
            themes.set(definition.key, Object.freeze(definition));
        },
        getTemplate(handlerKey) {
            return templates.get(handlerKey);
        },
        getTheme(themeKey) {
            return themes.get(themeKey);
        }
    };
})();
