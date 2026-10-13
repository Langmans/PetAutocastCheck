local _, ns = ...

-- /pac and its subcommands. Commands: one function per subcommand, named after it (lower case)
-- and called with what was typed after it; the slash handler only splits the message and looks
-- the subcommand up. Anything it does not know shows the status line with the list of commands.
-- Settings are read from ns.db, which exists once the addon has loaded (before anyone can type).
--
-- Globals this file writes, besides the slash command: the key binding's function and the names
-- Esc > Options > Keybindings shows for it (Bindings.xml).

local L, Print = ns.L, ns.Print

local COMMAND_LIST = table.concat({
    "/pac kite [on|off]",
    "/pac growl on|off",
    "/pac dungeon on|off",
    "/pac cower on|off",
    "/pac remind on|off",
    "/pac test [growl|cower|kite]",
    "/pac duration <seconds>",
    "/pac scale <0.3-3>",
    "/pac sound family|warning|off",
    "/pac reset",
    "/pac config",
    "/pac debug",
}, ", ") .. "."

---The first word of what was typed after the subcommand, lower case.
---@param rest string
---@return string
local function firstWord(rest)
    local lowered = rest:lower()
    return lowered:match("^%S*") or ""
end

---"on" -> true, "off" -> false, anything else nil.
---@param rest string
---@return boolean?
local function onOff(rest)
    local word = firstWord(rest)
    if word == "on" then return true end
    if word == "off" then return false end
    return nil
end

---@param on boolean
---@return string
local function onOffName(on)
    return on and L.STATUS_ON or L.STATUS_OFF
end

-- How each sound mode is named in the status line.
---@type table<PetAutocastCheckSoundMode, string>
local SOUND_NAMES = { family = L.SOUND_NAME_FAMILY, warning = L.SOUND_NAME_WARNING, off = L.STATUS_OFF }

---The current settings and the list of commands.
local function status()
    if not ns.isHunter then Print(L.NOT_HUNTER) end
    ---@type PetAutocastCheckSettings
    local db = ns.db
    Print(
        ns.Format(
            "STATUS",
            onOffName(db.kite),
            onOffName(db.growl),
            onOffName(db.dungeon),
            onOffName(db.cower),
            onOffName(db.remind),
            db.duration,
            db.scale,
            SOUND_NAMES[db.sound],
            onOffName(db.debug),
            COMMAND_LIST
        )
    )
end

-- What /pac sound takes: the mode names, and "on" for the default.
---@type table<string, PetAutocastCheckSoundMode>
local SOUND_WORDS = { family = "family", on = "family", warning = "warning", off = "off" }

-- What /pac sound answers for each mode.
---@type table<PetAutocastCheckSoundMode, string>
local SOUND_SET = { family = L.SOUND_FAMILY, warning = L.SOUND_WARNING, off = L.SOUND_OFF }

-- What /pac test takes, and the problem each word shows.
---@type table<string, string>
local TEST_KEYS = { growl = "growl", cower = "cower", kite = "cowerOff" }

-- The on/off settings with a command of their own, and what each answers.
---@type table<string, [string, string]>
local SWITCHES = {
    growl = { "GROWL_ON", "GROWL_OFF" },
    dungeon = { "DUNGEON_ON", "DUNGEON_OFF" },
    cower = { "COWER_ON", "COWER_OFF" },
    remind = { "REMIND_ON", "REMIND_OFF" },
}

---@type table<string, fun(rest: string)>
local Commands = {}

---Sets one of SWITCHES from "on" or "off" and checks again, since what counts as wrong changed.
---@param key "growl"|"dungeon"|"cower"|"remind"
---@param rest string
local function Switch(key, rest)
    local on = onOff(rest)
    if on == nil then
        status()
        return
    end
    local db = ns.db
    db[key] = on
    local answers = SWITCHES[key]
    Print(L[on and answers[1] or answers[2]])
    ns.Check()
end

---/pac growl on|off
function Commands.growl(rest)
    Switch("growl", rest)
end

---/pac dungeon on|off: the Growl warning only inside a dungeon or raid.
function Commands.dungeon(rest)
    Switch("dungeon", rest)
end

---/pac cower on|off
function Commands.cower(rest)
    Switch("cower", rest)
end

---/pac remind on|off
function Commands.remind(rest)
    Switch("remind", rest)
end

---/pac kite [on|off]: kite mode, where Cower belongs on autocast. Without a word it toggles.
---Made for macros: `/pac kite on` in a Distracting Shot macro is pressed over and over, so it
---only says something when kite mode actually changes.
function Commands.kite(rest)
    local on = onOff(rest)
    local db = ns.db
    if on == nil then on = not db.kite end
    if on == db.kite then return end
    db.kite = on
    Print(on and L.KITE_ON or L.KITE_OFF)
    ns.Check()
end

---/pac test [growl|cower|kite]: a toast only, whatever the pet bar says.
function Commands.test(rest)
    local key = TEST_KEYS[firstWord(rest)] or "growl"
    local info = ns.ProblemToast(key)
    -- Its own key, so a real toast for the same problem is not taken for this one.
    info.key = "test:" .. key
    ns.ShowToast(info)
end

---/pac sound family|warning|off
function Commands.sound(rest)
    local mode = SOUND_WORDS[firstWord(rest)]
    if not mode then return status() end
    local db = ns.db
    db.sound = mode
    Print(SOUND_SET[mode])
end

---/pac duration <seconds>: how long the toast stays before it fades, whole seconds from 1.
function Commands.duration(rest)
    local seconds = tonumber(firstWord(rest))
    if not seconds then return status() end
    local db = ns.db
    db.duration = math.max(1, math.floor(seconds))
    Print(ns.Format("DURATION_SET", db.duration))
end

---/pac scale <0.3-3>
function Commands.scale(rest)
    local scale = tonumber(firstWord(rest))
    if not scale then return status() end
    local db = ns.db
    db.scale = math.min(3, math.max(0.3, scale))
    Print(ns.Format("SCALE_SET", db.scale))
end

function Commands.reset()
    local db = ns.db
    db.pos = nil
    Print(L.POSITION_RESET)
end

function Commands.config()
    ns.OpenOptions()
end
Commands.options = Commands.config

function Commands.debug()
    local db = ns.db
    db.debug = not db.debug
    Print(db.debug and L.DEBUG_ON or L.DEBUG_OFF)
end

SLASH_PETAUTOCASTCHECK1 = "/pac"
SLASH_PETAUTOCASTCHECK2 = "/petautocastcheck"
---@param message string? what was typed after /pac
SlashCmdList.PETAUTOCASTCHECK = function(message)
    local typed = message or ""
    local name, rest = typed:match("^%s*(%S*)%s*(.-)%s*$")
    local key = name or ""
    local command = Commands[key:lower()]
    if command then
        command(rest or "")
    else
        status()
    end
end

-- The key binding toggles kite mode, like /pac kite.
BINDING_HEADER_PETAUTOCASTCHECK = L.OPTIONS_TITLE
BINDING_NAME_PETAUTOCASTCHECK_KITE = L.BINDING_KITE
function PetAutocastCheck_ToggleKite()
    Commands.kite("")
end
