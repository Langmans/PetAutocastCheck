local _, ns = ...

-- The fallback locale: every other locale falls back to these strings (see Locale.lua). This file
-- loads first, so it also creates the table the other locale files add themselves to.
-- Slash commands stay English in every locale; ability names come from the client and need
-- nothing here.
ns.Locales = {}
ns.Locales.enUS = {
    strings = {
        CHAT_PREFIX = "Pet Autocast Check:",

        -- The toast. The titles get the ability's name.
        TOAST_ON = "%s is on autocast",
        TOAST_OFF = "%s is not on autocast",
        REASON_GROWL = "You are in a group: your pet taunts mobs off the tank.",
        REASON_COWER = "Your pet throws away its threat. Kite mode is off.",
        REASON_KITE = "Kite mode is on: your pet should shed threat while you kite.",
        HINT_TURN_OFF = "Right-click it on the pet bar or in your pet's spellbook to turn autocast off.",
        HINT_TURN_ON = "Right-click it on the pet bar or in your pet's spellbook to turn autocast on.",

        -- /pac. STATUS: kite mode, Growl, Growl only in dungeons, Cower, Cower only in dungeons and
        -- the combat reminder on/off, the toast's duration in seconds and scale, sound (a
        -- SOUND_NAME_* or STATUS_OFF), debug on/off, the command list.
        STATUS = "Kite mode %s. Watching Growl %s (only in dungeons %s), Cower %s (only in dungeons %s), "
            .. "reminder in combat %s. "
            .. "Toast for %d s at scale %.2f, sound %s, debug %s. Commands: %s",
        STATUS_ON = "on",
        STATUS_OFF = "off",
        SOUND_NAME_FAMILY = "pet's call",
        SOUND_NAME_WARNING = "raid warning",
        NOT_HUNTER = "Only hunter pets have Growl and Cower; nothing is watched on this character.",
        KITE_ON = "Kite mode on: Cower belongs on autocast.",
        KITE_OFF = "Kite mode off: Cower belongs off autocast.",
        GROWL_ON = "Growl on autocast in a group gets a toast.",
        GROWL_OFF = "Growl is not watched.",
        GROWL_DUNGEON_ON = "Growl is only watched in a dungeon or raid.",
        GROWL_DUNGEON_OFF = "Growl is watched in every group, in the open world too.",
        COWER_ON = "Cower on autocast outside kite mode gets a toast.",
        COWER_OFF = "Cower is not watched outside kite mode.",
        COWER_DUNGEON_ON = "Cower is only watched in a dungeon or raid (kite mode still everywhere).",
        COWER_DUNGEON_OFF = "Cower is watched everywhere.",
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

        -- The options panel (Options.lua).
        OPTIONS_TITLE = "Pet Autocast Check",
        -- Version, author and license from the .toc.
        OPTION_ABOUT = "Version %s by %s, %s license.",
        OPTION_WEBSITE = "Website (Ctrl+C to copy):",
        OPTION_DESCRIPTION = "A toast in the middle of the screen when your pet's Growl or Cower is on "
            .. "autocast when it should not be: Growl while you are in a group, Cower unless you kite. "
            .. "In kite mode it is the other way round for Cower: it should be on.\n\n"
            .. "Drag the toast to move it, right-click to close it, hover to keep it up. "
            .. "Type /pac for the commands.",
        OPTION_SETTINGS = "Settings",
        OPTION_KITE = "Kite mode",
        OPTION_KITE_NOTE = "Cower belongs on autocast, and a toast says so when it is off. "
            .. "Same as /pac kite; there is a key binding for it under Esc > Options > Keybindings.",
        OPTION_GROWL = "Watch Growl",
        OPTION_GROWL_NOTE = "A toast when Growl is on autocast while you are in a party or raid. "
            .. "Same as /pac growl on and off.",
        OPTION_GROWL_DUNGEON = "Growl only in dungeons and raids",
        OPTION_GROWL_DUNGEON_NOTE = "Watch Growl only inside a dungeon or raid, where a tank holds the threat; "
            .. "a group questing outside is left alone. Same as /pac dungeon growl on and off.",
        OPTION_COWER = "Watch Cower",
        OPTION_COWER_NOTE = "A toast when Cower is on autocast outside kite mode. Same as /pac cower on and off.",
        OPTION_COWER_DUNGEON = "Cower only in dungeons and raids",
        OPTION_COWER_DUNGEON_NOTE = "Watch Cower only inside a dungeon or raid; kite mode still warns everywhere. "
            .. "Same as /pac dungeon cower on and off.",
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
