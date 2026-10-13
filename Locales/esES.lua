local _, ns = ...

ns.Locales.esES = {
    strings = {
        TOAST_ON = "%s está en lanzamiento automático",
        TOAST_OFF = "%s no está en lanzamiento automático",
        REASON_SOLO = "En solitario tu mascota retiene a los enemigos: Gruñido activado, Encogerse desactivado.",
        REASON_DUNGEON = "En un grupo de mazmorra el tanque retiene a los enemigos: Gruñido desactivado, "
            .. "Encogerse activado.",
        REASON_KITE = "Modo kite: el enemigo va a por ti, no a por tu mascota: Gruñido desactivado, "
            .. "Encogerse activado.",
        REASON_TANK = "Modo tanque: tu mascota tanquea para el grupo: Gruñido activado, Encogerse desactivado.",
        HINT_TURN_OFF = "Haz clic derecho en ella en la barra de mascota o en el libro de hechizos de tu "
            .. "mascota para quitar el lanzamiento automático.",
        HINT_TURN_ON = "Haz clic derecho en ella en la barra de mascota o en el libro de hechizos de tu "
            .. "mascota para poner el lanzamiento automático.",

        STATUS = "Modo %s (%s). Vigilando Gruñido %s, Encogerse %s, recordatorio en combate %s. "
            .. "Aviso durante %d s con tamaño %.2f, sonido %s, depuración %s. Comandos: %s",
        STATUS_ON = "activado",
        STATUS_OFF = "desactivado",
        MODE_SOLO = "solitario",
        MODE_DUNGEON = "mazmorra",
        MODE_KITE = "kite",
        MODE_TANK = "tanque",
        MODE_AUTO = "elegido por el addon",
        MODE_CHOSEN = "elegido por ti",
        SOUND_NAME_FAMILY = "grito de la mascota",
        SOUND_NAME_WARNING = "aviso de banda",
        NOT_HUNTER = "Solo las mascotas de cazador tienen Gruñido y Encogerse; en este personaje no se vigila nada.",
        KITE_ON = "Modo kite activado: Gruñido desactivado, Encogerse activado.",
        KITE_OFF = "Modo kite desactivado: otra vez solitario o mazmorra, según toque.",
        TANK_ON = "Modo tanque activado: Gruñido activado, Encogerse desactivado.",
        TANK_OFF = "Modo tanque desactivado: otra vez solitario o mazmorra, según toque.",
        GROWL_ON = "Gruñido muestra un aviso cuando su lanzamiento automático no encaja con el modo.",
        GROWL_OFF = "Gruñido no se vigila.",
        COWER_ON = "Encogerse muestra un aviso cuando su lanzamiento automático no encaja con el modo.",
        COWER_OFF = "Encogerse no se vigila.",
        REMIND_ON = "Lo que siga mal vuelve a avisarse al empezar el combate.",
        REMIND_OFF = "Sin recordatorio al empezar el combate.",
        SOUND_FAMILY = "Sonido: el grito de tu mascota, como al mandarla atacar (el aviso de banda si no tiene).",
        SOUND_WARNING = "Sonido: el aviso de banda.",
        SOUND_OFF = "Sonido desactivado.",
        DURATION_SET = "Duración del aviso: %d segundos.",
        SCALE_SET = "Tamaño del aviso: %.2f.",
        POSITION_RESET = "Posición del aviso restablecida.",
        DEBUG_ON = "Depuración activada.",
        DEBUG_OFF = "Depuración desactivada.",
        OPTIONS_AFTER_COMBAT = "En combate: las opciones se abren cuando termine el combate.",
        MACROS_MADE = "Macros %s creadas para este personaje: arrástralas desde la ventana de macros (/macro) "
            .. "a una barra de acción.",
        MACROS_MADE_ACCOUNT = "%s creada entre las macros de la cuenta, porque las de este personaje están llenas.",
        MACROS_FULL = "No hay sitio para %s: las macros del personaje y de la cuenta están llenas.",
        MACROS_THERE = "Las macros PACKite, PACKiteOff y PACTank ya existen.",
        MACROS_COMBAT = "No se pueden crear macros en combate; inténtalo después del combate.",

        BINDING_KITE = "Activar o desactivar el modo kite",
        BINDING_TANK = "Activar o desactivar el modo tanque",

        OPTION_ABOUT = "Versión %s de %s, licencia %s.",
        OPTION_WEBSITE = "Sitio web (Ctrl+C para copiar):",
        OPTION_DESCRIPTION = "Un aviso en el centro de la pantalla cuando el lanzamiento automático de Gruñido "
            .. "o Encogerse de tu mascota no encaja con lo que haces:\n"
            .. "- En solitario: Gruñido activado, Encogerse desactivado.\n"
            .. "- En un grupo de mazmorra o banda: Gruñido desactivado, Encogerse activado.\n"
            .. "- Modo kite: Gruñido desactivado, Encogerse activado.\n"
            .. "- Modo tanque, cuando tu mascota tanquea para el grupo: Gruñido activado, Encogerse desactivado.\n\n"
            .. "Arrastra el aviso para moverlo, clic derecho para cerrarlo, pasa el ratón por encima para "
            .. "mantenerlo. Escribe /pac para los comandos.",
        OPTION_SETTINGS = "Opciones",
        OPTION_MODE = "Modo",
        OPTION_MODE_AUTO = "Automático: solitario, o mazmorra en un grupo de mazmorra o banda",
        OPTION_MODE_KITE = "Kite: Gruñido desactivado, Encogerse activado",
        OPTION_MODE_TANK = "Tanque: Gruñido activado, Encogerse desactivado, también en mazmorras",
        OPTION_MODE_NOTE = "Igual que /pac kite y /pac tank; los dos tienen un atajo en "
            .. "Esc > Opciones > Asignación de teclas y caben en una macro.",
        OPTION_GROWL = "Vigilar Gruñido",
        OPTION_GROWL_NOTE = "Un aviso cuando el lanzamiento automático de Gruñido no encaja con el modo. "
            .. "Igual que /pac growl on y off.",
        OPTION_COWER = "Vigilar Encogerse",
        OPTION_COWER_NOTE = "Un aviso cuando el lanzamiento automático de Encogerse no encaja con el modo. "
            .. "Igual que /pac cower on y off.",
        OPTION_REMIND = "Recordar al empezar el combate",
        OPTION_REMIND_NOTE = "Lo que siga mal vuelve a avisarse en el pull. Igual que /pac remind on y off.",
        OPTION_SOUND = "Sonido",
        OPTION_SOUND_FAMILY = "El grito de tu mascota, como al mandarla atacar (aviso de banda si no tiene)",
        OPTION_SOUND_WARNING = "El aviso de banda",
        OPTION_SOUND_OFF = "Sin sonido",
        OPTION_DEBUG = "Traza de depuración",
        OPTION_DEBUG_NOTE = "Escribe en el chat cada problema que el addon encuentra o ve resuelto. Igual que /pac debug.",
        OPTION_DURATION = "El aviso dura %d segundos",
        OPTION_SCALE = "Tamaño del aviso: %.2f",
        OPTION_TEST = "Mostrar un aviso",
        OPTION_MACROS = "Crear las macros",
    },
}

ns.Locales.esMX = ns.Locales.esES
