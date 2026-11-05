/* ==========================================================================
   Epicentro Gourmet · Lógica del Modo Oscuro (JavaScript nativo)
   --------------------------------------------------------------------------
   - Alterna el atributo data-theme (y data-bs-theme, por compatibilidad con
     Bootstrap 5.3+) en la etiqueta <html>.
   - Persiste la elección en localStorage (clave: "theme") con valores
     "dark" | "light". Sin valor almacenado → modo claro por defecto.
   - El <head> incluye un script inline equivalente (fragment
     "fragments/darkmode :: head") que aplica el tema ANTES del primer
     renderizado para evitar el destello blanco (FOUC).
   ========================================================================== */
(function () {
    'use strict';

    var STORAGE_KEY = 'theme';
    var DARK = 'dark';
    var LIGHT = 'light';

    /** Tema actual según <html> (sin atributo → claro). */
    function currentTheme() {
        return document.documentElement.getAttribute('data-theme') === DARK ? DARK : LIGHT;
    }

    /** Escribe (o limpia) los atributos en <html>. */
    function applyTheme(theme) {
        var root = document.documentElement;
        if (theme === DARK) {
            root.setAttribute('data-theme', DARK);
            root.setAttribute('data-bs-theme', DARK); /* compatibilidad Bootstrap 5.3+ */
        } else {
            root.setAttribute('data-theme', LIGHT);
            root.setAttribute('data-bs-theme', LIGHT);
        }
    }

    /** Sincroniza el botón flotante (icono, aria-pressed, aria-label, title). */
    function syncToggle(theme) {
        var btn = document.getElementById('themeToggle');
        if (!btn) {
            return;
        }
        var isDark = theme === DARK;
        var icon = btn.querySelector('.theme-toggle-icon');
        if (icon) {
            icon.textContent = isDark ? '☀️' : '🌙';
        }
        btn.setAttribute('aria-pressed', String(isDark));
        var descripcion = isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro';
        btn.setAttribute('aria-label', descripcion);
        btn.title = descripcion;
    }

    /** Alterna el tema, lo persiste en localStorage y actualiza el botón. */
    function toggleTheme() {
        var siguiente = currentTheme() === DARK ? LIGHT : DARK;
        applyTheme(siguiente);
        try {
            window.localStorage.setItem(STORAGE_KEY, siguiente);
        } catch (e) {
            /* Sin localStorage (modo privado, etc.): el tema aplica solo a esta visita */
        }
        syncToggle(siguiente);
    }

    document.addEventListener('DOMContentLoaded', function () {
        var tema = currentTheme(); /* el inline del <head> ya aplicó localStorage si había */
        syncToggle(tema);

        var btn = document.getElementById('themeToggle');
        if (btn) {
            btn.addEventListener('click', toggleTheme);
        }
    });
})();
