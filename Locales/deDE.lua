local _, ns = ...

ns.Locales.deDE = {
    strings = {
        TOAST_ON = "%s wird automatisch gewirkt",
        TOAST_OFF = "%s wird nicht automatisch gewirkt",
        REASON_SOLO = "Allein hält dein Begleiter die Gegner: Knurren an, Ducken aus.",
        REASON_DUNGEON = "In einer Dungeongruppe hält der Tank die Gegner: Knurren aus, Ducken an.",
        REASON_KITE = "Kite-Modus: der Gegner ist bei dir, nicht bei deinem Begleiter: Knurren aus, Ducken an.",
        REASON_TANK = "Tank-Modus: dein Begleiter tankt für die Gruppe: Knurren an, Ducken aus.",
        HINT_TURN_OFF = "Rechtsklick darauf in der Begleiterleiste oder im Zauberbuch deines Begleiters "
            .. "schaltet das automatische Wirken aus.",
        HINT_TURN_ON = "Rechtsklick darauf in der Begleiterleiste oder im Zauberbuch deines Begleiters "
            .. "schaltet das automatische Wirken ein.",

        STATUS = "Modus %s (%s). Überwacht: Knurren %s, Ducken %s, Erinnerung im Kampf %s. "
            .. "Anzeige für %d s mit Größe %.2f, Ton %s, Debug %s. Befehle: %s",
        STATUS_ON = "an",
        STATUS_OFF = "aus",
        MODE_SOLO = "allein",
        MODE_DUNGEON = "Dungeon",
        MODE_KITE = "Kiten",
        MODE_TANK = "Tank",
        MODE_AUTO = "vom Addon gewählt",
        MODE_CHOSEN = "von dir gewählt",
        SOUND_NAME_FAMILY = "Ruf des Begleiters",
        SOUND_NAME_WARNING = "Schlachtzugswarnung",
        NOT_HUNTER = "Nur Jägerbegleiter haben Knurren und Ducken; auf diesem Charakter wird nichts überwacht.",
        KITE_ON = "Kite-Modus an: Knurren aus, Ducken an.",
        KITE_OFF = "Kite-Modus aus: wieder allein oder Dungeon, je nachdem.",
        TANK_ON = "Tank-Modus an: Knurren an, Ducken aus.",
        TANK_OFF = "Tank-Modus aus: wieder allein oder Dungeon, je nachdem.",
        GROWL_ON = "Knurren wird angezeigt, wenn sein automatisches Wirken nicht zum Modus passt.",
        GROWL_OFF = "Knurren wird nicht überwacht.",
        COWER_ON = "Ducken wird angezeigt, wenn sein automatisches Wirken nicht zum Modus passt.",
        COWER_OFF = "Ducken wird nicht überwacht.",
        REMIND_ON = "Was noch falsch ist, wird bei Kampfbeginn erneut angezeigt.",
        REMIND_OFF = "Keine Erinnerung bei Kampfbeginn.",
        SOUND_FAMILY = "Ton: der Ruf deines Begleiters, wie beim Angriffsbefehl (ohne einen die Schlachtzugswarnung).",
        SOUND_WARNING = "Ton: die Schlachtzugswarnung.",
        SOUND_OFF = "Ton aus.",
        DURATION_SET = "Anzeigedauer: %d Sekunden.",
        SCALE_SET = "Anzeigegröße: %.2f.",
        POSITION_RESET = "Position der Anzeige zurückgesetzt.",
        DEBUG_ON = "Debug an.",
        DEBUG_OFF = "Debug aus.",
        OPTIONS_AFTER_COMBAT = "Im Kampf: die Optionen öffnen sich, wenn der Kampf endet.",

        BINDING_KITE = "Kite-Modus umschalten",
        BINDING_TANK = "Tank-Modus umschalten",

        OPTION_ABOUT = "Version %s von %s, Lizenz %s.",
        OPTION_WEBSITE = "Webseite (Strg+C zum Kopieren):",
        OPTION_DESCRIPTION = "Eine Anzeige in der Bildschirmmitte, wenn das automatische Wirken von Knurren "
            .. "oder Ducken deines Begleiters nicht zu dem passt, was du tust:\n"
            .. "- Allein: Knurren an, Ducken aus.\n"
            .. "- In einer Dungeon- oder Schlachtzuggruppe: Knurren aus, Ducken an.\n"
            .. "- Kite-Modus: Knurren aus, Ducken an.\n"
            .. "- Tank-Modus, wenn dein Begleiter für die Gruppe tankt: Knurren an, Ducken aus.\n\n"
            .. "Ziehe die Anzeige, um sie zu verschieben, Rechtsklick schließt sie, mit der Maus darüber "
            .. "bleibt sie stehen. /pac zeigt die Befehle.",
        OPTION_SETTINGS = "Einstellungen",
        OPTION_MODE = "Modus",
        OPTION_MODE_AUTO = "Automatisch: allein, oder Dungeon in einer Dungeon- oder Schlachtzuggruppe",
        OPTION_MODE_KITE = "Kiten: Knurren aus, Ducken an",
        OPTION_MODE_TANK = "Tank: Knurren an, Ducken aus, auch im Dungeon",
        OPTION_MODE_NOTE = "Wie /pac kite und /pac tank; beide haben eine Tastenbelegung unter "
            .. "Esc > Optionen > Tastaturbelegung und passen in ein Makro.",
        OPTION_GROWL = "Knurren überwachen",
        OPTION_GROWL_NOTE = "Eine Anzeige, wenn das automatische Wirken von Knurren nicht zum Modus passt. "
            .. "Wie /pac growl on und off.",
        OPTION_COWER = "Ducken überwachen",
        OPTION_COWER_NOTE = "Eine Anzeige, wenn das automatische Wirken von Ducken nicht zum Modus passt. "
            .. "Wie /pac cower on und off.",
        OPTION_REMIND = "Bei Kampfbeginn erinnern",
        OPTION_REMIND_NOTE = "Was noch falsch ist, wird beim Pull erneut angezeigt. Wie /pac remind on und off.",
        OPTION_SOUND = "Ton",
        OPTION_SOUND_FAMILY = "Der Ruf deines Begleiters, wie beim Angriffsbefehl (ohne einen die Schlachtzugswarnung)",
        OPTION_SOUND_WARNING = "Die Schlachtzugswarnung",
        OPTION_SOUND_OFF = "Kein Ton",
        OPTION_DEBUG = "Debug-Ausgabe",
        OPTION_DEBUG_NOTE = "Schreibt jedes gefundene und jedes gelöste Problem in den Chat. Wie /pac debug.",
        OPTION_DURATION = "Anzeige bleibt %d Sekunden",
        OPTION_SCALE = "Anzeigegröße: %.2f",
        OPTION_TEST = "Anzeige zeigen",
    },
}
