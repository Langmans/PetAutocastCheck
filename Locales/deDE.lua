local _, ns = ...

ns.Locales.deDE = {
    strings = {
        TOAST_ON = "%s wird automatisch gewirkt",
        TOAST_OFF = "%s wird nicht automatisch gewirkt",
        REASON_GROWL = "Du bist in einer Gruppe: dein Begleiter spottet dem Tank die Gegner weg.",
        REASON_COWER = "Dein Begleiter wirft seine Bedrohung weg. Der Kite-Modus ist aus.",
        REASON_KITE = "Der Kite-Modus ist an: dein Begleiter soll Bedrohung abbauen, während du kitest.",
        HINT_TURN_OFF = "Rechtsklick darauf in der Begleiterleiste oder im Zauberbuch deines Begleiters "
            .. "schaltet das automatische Wirken aus.",
        HINT_TURN_ON = "Rechtsklick darauf in der Begleiterleiste oder im Zauberbuch deines Begleiters "
            .. "schaltet das automatische Wirken ein.",

        STATUS = "Kite-Modus %s. Überwacht: Knurren %s, Ducken %s, Erinnerung im Kampf %s. "
            .. "Anzeige für %d s mit Größe %.2f, Ton %s, Debug %s. Befehle: %s",
        STATUS_ON = "an",
        STATUS_OFF = "aus",
        NOT_HUNTER = "Nur Jägerbegleiter haben Knurren und Ducken; auf diesem Charakter wird nichts überwacht.",
        KITE_ON = "Kite-Modus an: Ducken gehört auf automatisch.",
        KITE_OFF = "Kite-Modus aus: Ducken gehört nicht auf automatisch.",
        GROWL_ON = "Knurren auf automatisch in einer Gruppe wird angezeigt.",
        GROWL_OFF = "Knurren wird nicht überwacht.",
        COWER_ON = "Ducken auf automatisch außerhalb des Kite-Modus wird angezeigt.",
        COWER_OFF = "Ducken wird außerhalb des Kite-Modus nicht überwacht.",
        REMIND_ON = "Was noch falsch ist, wird bei Kampfbeginn erneut angezeigt.",
        REMIND_OFF = "Keine Erinnerung bei Kampfbeginn.",
        SOUND_NAME_FAMILY = "Ruf des Begleiters",
        SOUND_NAME_WARNING = "Schlachtzugswarnung",
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

        OPTION_ABOUT = "Version %s von %s, Lizenz %s.",
        OPTION_WEBSITE = "Webseite (Strg+C zum Kopieren):",
        OPTION_DESCRIPTION = "Eine Anzeige in der Bildschirmmitte, wenn Knurren oder Ducken deines Begleiters "
            .. "automatisch gewirkt wird, obwohl das nicht sein sollte: Knurren in einer Gruppe, Ducken "
            .. "außer beim Kiten. Im Kite-Modus ist es bei Ducken umgekehrt: es soll an sein.\n\n"
            .. "Ziehe die Anzeige, um sie zu verschieben, Rechtsklick schließt sie, mit der Maus darüber "
            .. "bleibt sie stehen. /pac zeigt die Befehle.",
        OPTION_SETTINGS = "Einstellungen",
        OPTION_KITE = "Kite-Modus",
        OPTION_KITE_NOTE = "Ducken gehört auf automatisch, und eine Anzeige sagt es, wenn es aus ist. "
            .. "Wie /pac kite; eine Tastenbelegung gibt es unter Esc > Optionen > Tastaturbelegung.",
        OPTION_GROWL = "Knurren überwachen",
        OPTION_GROWL_NOTE = "Eine Anzeige, wenn Knurren in einer Gruppe oder einem Schlachtzug automatisch "
            .. "gewirkt wird. Wie /pac growl on und off.",
        OPTION_COWER = "Ducken überwachen",
        OPTION_COWER_NOTE = "Eine Anzeige, wenn Ducken außerhalb des Kite-Modus automatisch gewirkt wird. "
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
