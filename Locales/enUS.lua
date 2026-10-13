local _, ns = ...

-- The fallback locale: every other locale falls back to these strings (see Locale.lua). This file
-- loads first, so it also creates the table the other locale files add themselves to.
-- Slash commands stay English in every locale; ability names come from the client and need
-- nothing here.
ns.Locales = {}
ns.Locales.enUS = {
    strings = {
        CHAT_PREFIX = "Pet Autocast Check:",

        -- The toast. The titles get the ability's name; the reason says what the mode in force
        -- wants.
        TOAST_ON = "%s is on autocast",
        TOAST_OFF = "%s is not on autocast",
        REASON_SOLO = "Solo your pet holds the mobs: Growl on, Cower off.",
        REASON_DUNGEON = "In a dungeon group the tank holds the mobs: Growl off, Cower on.",
        REASON_KITE = "Kite mode: the mob is on you, not on your pet: Growl off, Cower on.",
        REASON_TANK = "Tank mode: your pet tanks for the group: Growl on, Cower off.",
        HINT_TURN_OFF = "Right-click it on the pet bar or in your pet's spellbook to turn autocast off.",
        HINT_TURN_ON = "Right-click it on the pet bar or in your pet's spellbook to turn autocast on.",

        -- /pac. STATUS: the mode in force (a MODE_* name), how it was chosen (MODE_AUTO or
        -- MODE_CHOSEN), Growl, Cower and the combat reminder on/off, the toast's duration in
        -- seconds and scale, sound (a SOUND_NAME_* or STATUS_OFF), debug on/off, the command list.
        STATUS = "Mode %s (%s). Watching Growl %s, Cower %s, reminder in combat %s. "
            .. "Toast for %d s at scale %.2f, sound %s, debug %s. Commands: %s",
        STATUS_ON = "on",
        STATUS_OFF = "off",
        MODE_SOLO = "solo",
        MODE_DUNGEON = "dungeon",
        MODE_KITE = "kite",
        MODE_TANK = "tank",
        MODE_AUTO = "picked by the addon",
        MODE_CHOSEN = "chosen by you",
        SOUND_NAME_FAMILY = "pet's call",
        SOUND_NAME_WARNING = "raid warning",
        NOT_HUNTER = "Only hunter pets have Growl and Cower; nothing is watched on this character.",
        KITE_ON = "Kite mode on: Growl off, Cower on.",
        KITE_OFF = "Kite mode off: solo or dungeon mode again, as fits.",
        TANK_ON = "Tank mode on: Growl on, Cower off.",
        TANK_OFF = "Tank mode off: solo or dungeon mode again, as fits.",
        GROWL_ON = "Growl gets a toast when its autocast does not fit the mode.",
        GROWL_OFF = "Growl is not watched.",
        COWER_ON = "Cower gets a toast when its autocast does not fit the mode.",
        COWER_OFF = "Cower is not watched.",
        REMIND_ON = "What is still wrong toasts again when combat starts.",
        REMIND_OFF = "No reminder when combat starts.",
        SOUND_FAMILY = "Sound: your pet's call, as when you send it to attack (the raid warning when it has none).",
        SOUND_WARNING = "Sound: the raid warning.",
        SOUND_OFF = "Sound off.",
        DURATION_SET = "Toast duration: %d seconds.",
        SCALE_SET = "Toast scale: %.2f.",
        POSITION_RESET = "Toast position reset.",
        DEBUG_ON = "Debug on.",
        DEBUG_OFF = "Debug off.",
        OPTIONS_AFTER_COMBAT = "In combat: the options open when combat ends.",

        -- Esc > Options > Keybindings.
        BINDING_KITE = "Toggle kite mode",
        BINDING_TANK = "Toggle tank mode",

        -- The options panel (Options.lua).
        OPTIONS_TITLE = "Pet Autocast Check",
        -- Version, author and license from the .toc.
        OPTION_ABOUT = "Version %s by %s, %s license.",
        OPTION_WEBSITE = "Website (Ctrl+C to copy):",
        OPTION_DESCRIPTION = "A toast in the middle of the screen when your pet's Growl or Cower autocast "
            .. "does not fit what you are doing:\n"
            .. "- Solo: Growl on, Cower off.\n"
            .. "- In a dungeon or raid group: Growl off, Cower on.\n"
            .. "- Kite mode: Growl off, Cower on.\n"
            .. "- Tank mode, when your pet tanks for the group: Growl on, Cower off.\n\n"
            .. "Drag the toast to move it, right-click to close it, hover to keep it up. "
            .. "Type /pac for the commands.",
        OPTION_SETTINGS = "Settings",
        OPTION_MODE = "Mode",
        OPTION_MODE_AUTO = "Automatic: solo, or dungeon in a dungeon or raid group",
        OPTION_MODE_KITE = "Kite: Growl off, Cower on",
        OPTION_MODE_TANK = "Tank: Growl on, Cower off, in a dungeon too",
        OPTION_MODE_NOTE = "Same as /pac kite and /pac tank; both have a key binding under "
            .. "Esc > Options > Keybindings, and fit in a macro.",
        OPTION_GROWL = "Watch Growl",
        OPTION_GROWL_NOTE = "A toast when Growl's autocast does not fit the mode. Same as /pac growl on and off.",
        OPTION_COWER = "Watch Cower",
        OPTION_COWER_NOTE = "A toast when Cower's autocast does not fit the mode. Same as /pac cower on and off.",
        OPTION_REMIND = "Remind me when combat starts",
        OPTION_REMIND_NOTE = "Whatever is still wrong toasts again at the pull. Same as /pac remind on and off.",
        OPTION_SOUND = "Sound",
        OPTION_SOUND_FAMILY = "Your pet's call, as when you send it to attack (raid warning when it has none)",
        OPTION_SOUND_WARNING = "The raid warning",
        OPTION_SOUND_OFF = "No sound",
        OPTION_DEBUG = "Debug trace",
        OPTION_DEBUG_NOTE = "Print in chat every problem the addon finds or sees solved. Same as /pac debug.",
        -- Slider titles: whole seconds, a size like 1.25.
        OPTION_DURATION = "Toast stays for %d seconds",
        OPTION_SCALE = "Toast size: %.2f",
        OPTION_TEST = "Show a toast",
    },
}
