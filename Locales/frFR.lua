local _, ns = ...

ns.Locales.frFR = {
    strings = {
        TOAST_ON = "%s est en lancement automatique",
        TOAST_OFF = "%s n'est pas en lancement automatique",
        REASON_GROWL = "Vous êtes en groupe : votre familier arrache les monstres au tank.",
        REASON_COWER = "Votre familier jette sa menace. Le mode kite est désactivé.",
        REASON_KITE = "Le mode kite est activé : votre familier doit perdre de la menace pendant que vous kitez.",
        HINT_TURN_OFF = "Clic droit dessus dans la barre du familier pour couper le lancement automatique.",
        HINT_TURN_ON = "Clic droit dessus dans la barre du familier pour activer le lancement automatique.",

        STATUS = "Mode kite %s. Surveillance de Grondement %s, Dérobade %s, rappel en combat %s. "
            .. "Alerte pendant %d s à la taille %.2f, son %s, débogage %s. Commandes : %s",
        STATUS_ON = "activé",
        STATUS_OFF = "désactivé",
        NOT_HUNTER = "Seuls les familiers de chasseur ont Grondement et Dérobade ; rien n'est surveillé sur ce personnage.",
        KITE_ON = "Mode kite activé : Dérobade doit être en lancement automatique.",
        KITE_OFF = "Mode kite désactivé : Dérobade ne doit pas être en lancement automatique.",
        GROWL_ON = "Grondement en lancement automatique en groupe donne une alerte.",
        GROWL_OFF = "Grondement n'est pas surveillé.",
        COWER_ON = "Dérobade en lancement automatique hors du mode kite donne une alerte.",
        COWER_OFF = "Dérobade n'est pas surveillée hors du mode kite.",
        REMIND_ON = "Ce qui est encore faux redonne une alerte au début du combat.",
        REMIND_OFF = "Pas de rappel au début du combat.",
        SOUND_NAME_FAMILY = "cri du familier",
        SOUND_NAME_WARNING = "avertissement de raid",
        SOUND_FAMILY = "Son : le cri de votre familier, comme quand vous l'envoyez attaquer (l'avertissement de raid s'il n'en a pas).",
        SOUND_WARNING = "Son : l'avertissement de raid.",
        SOUND_OFF = "Son désactivé.",
        DURATION_SET = "Durée de l'alerte : %d secondes.",
        SCALE_SET = "Taille de l'alerte : %.2f.",
        POSITION_RESET = "Position de l'alerte réinitialisée.",
        DEBUG_ON = "Débogage activé.",
        DEBUG_OFF = "Débogage désactivé.",
        OPTIONS_AFTER_COMBAT = "En combat : les options s'ouvriront à la fin du combat.",

        BINDING_KITE = "Activer ou désactiver le mode kite",

        OPTION_ABOUT = "Version %s par %s, licence %s.",
        OPTION_WEBSITE = "Site web (Ctrl+C pour copier) :",
        OPTION_DESCRIPTION = "Une alerte au milieu de l'écran quand Grondement ou Dérobade de votre familier "
            .. "est en lancement automatique alors qu'il ne devrait pas l'être : Grondement en groupe, "
            .. "Dérobade sauf quand vous kitez. En mode kite, c'est l'inverse pour Dérobade : elle doit "
            .. "être activée.\n\n"
            .. "Faites glisser l'alerte pour la déplacer, clic droit pour la fermer, survolez-la pour la "
            .. "garder. Seules les techniques de la barre du familier sont vues. Tapez /pac pour les commandes.",
        OPTION_SETTINGS = "Réglages",
        OPTION_KITE = "Mode kite",
        OPTION_KITE_NOTE = "Dérobade doit être en lancement automatique, et une alerte le dit quand elle ne "
            .. "l'est pas. Comme /pac kite ; un raccourci existe dans Échap > Options > Raccourcis.",
        OPTION_GROWL = "Surveiller Grondement",
        OPTION_GROWL_NOTE = "Une alerte quand Grondement est en lancement automatique en groupe ou en raid. "
            .. "Comme /pac growl on et off.",
        OPTION_COWER = "Surveiller Dérobade",
        OPTION_COWER_NOTE = "Une alerte quand Dérobade est en lancement automatique hors du mode kite. "
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
    },
}
