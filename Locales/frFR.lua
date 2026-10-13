local _, ns = ...

ns.Locales.frFR = {
    strings = {
        TOAST_ON = "%s est en lancement automatique",
        TOAST_OFF = "%s n'est pas en lancement automatique",
        REASON_SOLO = "En solo votre familier retient les monstres : Grondement activé, Dérobade désactivée.",
        REASON_DUNGEON = "En groupe de donjon le tank retient les monstres : Grondement désactivé, Dérobade activée.",
        REASON_KITE = "Mode kite : le monstre est sur vous, pas sur votre familier : Grondement désactivé, "
            .. "Dérobade activée.",
        REASON_TANK = "Mode tank : votre familier tanke pour le groupe : Grondement activé, Dérobade désactivée.",
        HINT_TURN_OFF = "Clic droit dessus dans la barre du familier ou dans le grimoire du familier "
            .. "pour couper le lancement automatique.",
        HINT_TURN_ON = "Clic droit dessus dans la barre du familier ou dans le grimoire du familier "
            .. "pour activer le lancement automatique.",

        STATUS = "Mode %s (%s). Surveillance de Grondement %s, Dérobade %s, rappel en combat %s. "
            .. "Alerte pendant %d s à la taille %.2f, son %s, débogage %s. Commandes : %s",
        STATUS_ON = "activé",
        STATUS_OFF = "désactivé",
        MODE_SOLO = "solo",
        MODE_DUNGEON = "donjon",
        MODE_KITE = "kite",
        MODE_TANK = "tank",
        MODE_AUTO = "choisi par l'addon",
        MODE_CHOSEN = "choisi par vous",
        SOUND_NAME_FAMILY = "cri du familier",
        SOUND_NAME_WARNING = "avertissement de raid",
        NOT_HUNTER = "Seuls les familiers de chasseur ont Grondement et Dérobade ; rien n'est surveillé sur ce personnage.",
        KITE_ON = "Mode kite activé : Grondement désactivé, Dérobade activée.",
        KITE_OFF = "Mode kite désactivé : de nouveau solo ou donjon, selon le cas.",
        TANK_ON = "Mode tank activé : Grondement activé, Dérobade désactivée.",
        TANK_OFF = "Mode tank désactivé : de nouveau solo ou donjon, selon le cas.",
        GROWL_ON = "Grondement donne une alerte quand son lancement automatique ne va pas avec le mode.",
        GROWL_OFF = "Grondement n'est pas surveillé.",
        COWER_ON = "Dérobade donne une alerte quand son lancement automatique ne va pas avec le mode.",
        COWER_OFF = "Dérobade n'est pas surveillée.",
        REMIND_ON = "Ce qui est encore faux redonne une alerte au début du combat.",
        REMIND_OFF = "Pas de rappel au début du combat.",
        SOUND_FAMILY = "Son : le cri de votre familier, comme quand vous l'envoyez attaquer (l'avertissement de raid s'il n'en a pas).",
        SOUND_WARNING = "Son : l'avertissement de raid.",
        SOUND_OFF = "Son désactivé.",
        DURATION_SET = "Durée de l'alerte : %d secondes.",
        SCALE_SET = "Taille de l'alerte : %.2f.",
        POSITION_RESET = "Position de l'alerte réinitialisée.",
        DEBUG_ON = "Débogage activé.",
        DEBUG_OFF = "Débogage désactivé.",
        OPTIONS_AFTER_COMBAT = "En combat : les options s'ouvriront à la fin du combat.",
        MACROS_MADE = "Macros %s créées pour ce personnage : faites-les glisser de la fenêtre des macros "
            .. "(/macro) vers une barre d'action.",
        MACROS_MADE_ACCOUNT = "%s créée parmi les macros du compte, car celles de ce personnage sont pleines.",
        MACROS_FULL = "Pas de place pour %s : les macros du personnage et du compte sont pleines.",
        MACROS_THERE = "Les macros PACKite, PACKiteOff et PACTank existent déjà.",
        MACROS_COMBAT = "Impossible de créer des macros en combat ; réessayez après le combat.",

        BINDING_KITE = "Activer ou désactiver le mode kite",
        BINDING_TANK = "Activer ou désactiver le mode tank",

        OPTION_ABOUT = "Version %s par %s, licence %s.",
        OPTION_WEBSITE = "Site web (Ctrl+C pour copier) :",
        OPTION_DESCRIPTION = "Une alerte au milieu de l'écran quand le lancement automatique de Grondement "
            .. "ou de Dérobade de votre familier ne va pas avec ce que vous faites :\n"
            .. "- En solo : Grondement activé, Dérobade désactivée.\n"
            .. "- En groupe de donjon ou de raid : Grondement désactivé, Dérobade activée.\n"
            .. "- Mode kite : Grondement désactivé, Dérobade activée.\n"
            .. "- Mode tank, quand votre familier tanke pour le groupe : Grondement activé, Dérobade désactivée.\n\n"
            .. "Faites glisser l'alerte pour la déplacer, clic droit pour la fermer, survolez-la pour la "
            .. "garder. Tapez /pac pour les commandes.",
        OPTION_SETTINGS = "Réglages",
        OPTION_MODE = "Mode",
        OPTION_MODE_AUTO = "Automatique : solo, ou donjon en groupe de donjon ou de raid",
        OPTION_MODE_KITE = "Kite : Grondement désactivé, Dérobade activée",
        OPTION_MODE_TANK = "Tank : Grondement activé, Dérobade désactivée, en donjon aussi",
        OPTION_MODE_NOTE = "Comme /pac kite et /pac tank ; les deux ont un raccourci dans "
            .. "Échap > Options > Raccourcis et vont dans une macro.",
        OPTION_GROWL = "Surveiller Grondement",
        OPTION_GROWL_NOTE = "Une alerte quand le lancement automatique de Grondement ne va pas avec le mode. "
            .. "Comme /pac growl on et off.",
        OPTION_COWER = "Surveiller Dérobade",
        OPTION_COWER_NOTE = "Une alerte quand le lancement automatique de Dérobade ne va pas avec le mode. "
            .. "Comme /pac cower on et off.",
        OPTION_REMIND = "Rappel au début du combat",
        OPTION_REMIND_NOTE = "Ce qui est encore faux redonne une alerte au pull. Comme /pac remind on et off.",
        OPTION_SOUND = "Son",
        OPTION_SOUND_FAMILY = "Le cri de votre familier, comme à l'ordre d'attaque (avertissement de raid s'il n'en a pas)",
        OPTION_SOUND_WARNING = "L'avertissement de raid",
        OPTION_SOUND_OFF = "Aucun son",
        OPTION_DEBUG = "Trace de débogage",
        OPTION_DEBUG_NOTE = "Écrit dans le chat chaque problème trouvé ou résolu. Comme /pac debug.",
        OPTION_DURATION = "L'alerte reste %d secondes",
        OPTION_SCALE = "Taille de l'alerte : %.2f",
        OPTION_TEST = "Montrer une alerte",
        OPTION_MACROS = "Créer les macros",
    },
}
