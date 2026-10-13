local _, ns = ...

ns.Locales.esES = {
    strings = {
        TOAST_ON = "%s está en lanzamiento automático",
        TOAST_OFF = "%s no está en lanzamiento automático",
        REASON_GROWL = "Estás en un grupo: tu mascota le quita los enemigos al tanque.",
        REASON_COWER = "Tu mascota tira su amenaza. El modo kite está desactivado.",
        REASON_KITE = "El modo kite está activado: tu mascota debe soltar amenaza mientras kiteas.",
        HINT_TURN_OFF = "Haz clic derecho en ella en la barra de mascota o en el libro de hechizos de tu "
            .. "mascota para quitar el lanzamiento automático.",
        HINT_TURN_ON = "Haz clic derecho en ella en la barra de mascota o en el libro de hechizos de tu "
            .. "mascota para poner el lanzamiento automático.",

        STATUS = "Modo kite %s. Vigilando Gruñido %s (solo en mazmorras %s), Encogerse %s (solo en mazmorras %s), "
            .. "recordatorio en combate %s. "
            .. "Aviso durante %d s con tamaño %.2f, sonido %s, depuración %s. Comandos: %s",
        STATUS_ON = "activado",
        STATUS_OFF = "desactivado",
        NOT_HUNTER = "Solo las mascotas de cazador tienen Gruñido y Encogerse; en este personaje no se vigila nada.",
        KITE_ON = "Modo kite activado: Encogerse va en lanzamiento automático.",
        KITE_OFF = "Modo kite desactivado: Encogerse no va en lanzamiento automático.",
        GROWL_ON = "Gruñido en lanzamiento automático en un grupo muestra un aviso.",
        GROWL_OFF = "Gruñido no se vigila.",
        GROWL_DUNGEON_ON = "Gruñido solo se vigila en mazmorras y bandas.",
        GROWL_DUNGEON_OFF = "Gruñido se vigila en cualquier grupo, también en el mundo abierto.",
        COWER_DUNGEON_ON = "Encogerse solo se vigila en mazmorras y bandas (el modo kite sigue en todas partes).",
        COWER_DUNGEON_OFF = "Encogerse se vigila en todas partes.",
        COWER_ON = "Encogerse en lanzamiento automático fuera del modo kite muestra un aviso.",
        COWER_OFF = "Encogerse no se vigila fuera del modo kite.",
        REMIND_ON = "Lo que siga mal vuelve a avisarse al empezar el combate.",
        REMIND_OFF = "Sin recordatorio al empezar el combate.",
        SOUND_NAME_FAMILY = "grito de la mascota",
        SOUND_NAME_WARNING = "aviso de banda",
        SOUND_FAMILY = "Sonido: el grito de tu mascota, como al mandarla atacar (el aviso de banda si no tiene).",
        SOUND_WARNING = "Sonido: el aviso de banda.",
        SOUND_OFF = "Sonido desactivado.",
        DURATION_SET = "Duración del aviso: %d segundos.",
        SCALE_SET = "Tamaño del aviso: %.2f.",
        POSITION_RESET = "Posición del aviso restablecida.",
        DEBUG_ON = "Depuración activada.",
        DEBUG_OFF = "Depuración desactivada.",
        OPTIONS_AFTER_COMBAT = "En combate: las opciones se abren cuando termine el combate.",

        BINDING_KITE = "Activar o desactivar el modo kite",

        OPTION_ABOUT = "Versión %s de %s, licencia %s.",
        OPTION_WEBSITE = "Sitio web (Ctrl+C para copiar):",
        OPTION_DESCRIPTION = "Un aviso en el centro de la pantalla cuando Gruñido o Encogerse de tu mascota "
            .. "están en lanzamiento automático sin deber estarlo: Gruñido en un grupo, Encogerse salvo "
            .. "cuando kiteas. En modo kite, Encogerse es al revés: debe estar activado.\n\n"
            .. "Arrastra el aviso para moverlo, clic derecho para cerrarlo, pasa el ratón por encima para "
            .. "mantenerlo. Escribe /pac para los comandos.",
        OPTION_SETTINGS = "Opciones",
        OPTION_KITE = "Modo kite",
        OPTION_KITE_NOTE = "Encogerse va en lanzamiento automático, y un aviso lo dice cuando no lo está. "
            .. "Igual que /pac kite; hay un atajo de teclado en Esc > Opciones > Asignación de teclas.",
        OPTION_GROWL = "Vigilar Gruñido",
        OPTION_GROWL_NOTE = "Un aviso cuando Gruñido está en lanzamiento automático en un grupo o banda. "
            .. "Igual que /pac growl on y off.",
        OPTION_GROWL_DUNGEON = "Gruñido solo en mazmorras y bandas",
        OPTION_GROWL_DUNGEON_NOTE = "Vigilar Gruñido solo dentro de una mazmorra o banda, donde un tanque "
            .. "mantiene la amenaza; un grupo de misiones fuera no se toca. Igual que /pac dungeon growl on y off.",
        OPTION_COWER = "Vigilar Encogerse",
        OPTION_COWER_NOTE = "Un aviso cuando Encogerse está en lanzamiento automático fuera del modo kite. "
            .. "Igual que /pac cower on y off.",
        OPTION_COWER_DUNGEON = "Encogerse solo en mazmorras y bandas",
        OPTION_COWER_DUNGEON_NOTE = "Vigilar Encogerse solo dentro de una mazmorra o banda; el modo kite sigue "
            .. "avisando en todas partes. Igual que /pac dungeon cower on y off.",
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
    },
}

ns.Locales.esMX = ns.Locales.esES
