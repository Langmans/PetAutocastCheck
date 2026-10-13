local ADDON_NAME, ns = ...

-- What counts as wrong depends on the mode, which says who holds the mobs:
--   - solo:    the pet does. Growl on, so it keeps them; Cower off, so it does not throw that
--              threat away.
--   - dungeon: the tank does. Growl off, or the pet taunts mobs off the tank; Cower on, so the
--              pet's threat stays under the tank's. Picked by itself inside a dungeon or raid
--              instance while in a group; anywhere else it is solo.
--   - kite:    the hunter does, kiting. Like dungeon: Growl off, Cower on. Chosen by hand.
--   - tank:    the pet does, in a group without a tank. Like solo: Growl on, Cower off. Chosen
--              by hand.
-- Growl or Cower in the other state than the mode wants is a problem (growlOn, growlOff,
-- cowerOn, cowerOff). Each problem toasts when it starts; when it is solved, its toast goes
-- away. With the remind setting, everything still wrong toasts again when combat starts.
--
-- The state comes from the pet's spellbook, which holds every ability whether it is on the pet
-- bar or not (Cower often is not), and from the pet bar. Ability names come from the client by
-- spell ID, so the check works in any language and at any rank.

local L = ns.L

local GROWL, COWER = 2649, 1742

-- Per mode: whether Growl belongs on autocast; Cower belongs the other way.
---@type table<PetAutocastCheckMode, boolean>
local GROWL_WANTED = { solo = true, tank = true, dungeon = false, kite = false }

-- Per mode: the toast's line saying why, with what the mode wants.
---@type table<PetAutocastCheckMode, string>
local REASONS = { solo = "REASON_SOLO", dungeon = "REASON_DUNGEON", kite = "REASON_KITE", tank = "REASON_TANK" }

-- The order toasts are shown in when several problems start at once.
local ORDER = { "growlOn", "growlOff", "cowerOn", "cowerOff" }

-- Per problem: the ability it is about, and the locale keys for the title and the hint on its
-- toast. "On" is on autocast while the mode wants it off.
---@type table<string, {spell: number, title: string, hint: string}>
local PROBLEMS = {
    growlOn = { spell = GROWL, title = "TOAST_ON", hint = "HINT_TURN_OFF" },
    growlOff = { spell = GROWL, title = "TOAST_OFF", hint = "HINT_TURN_ON" },
    cowerOn = { spell = COWER, title = "TOAST_ON", hint = "HINT_TURN_OFF" },
    cowerOff = { spell = COWER, title = "TOAST_OFF", hint = "HINT_TURN_ON" },
}

-- The English names, for a client that cannot name the spell itself (test toasts only).
local FALLBACK_NAMES = { [GROWL] = "Growl", [COWER] = "Cower" }

---A value the addon may read: not secret (Forever hides some values in combat).
---@param v GameValue
---@return boolean
local function Readable(v)
    return not (issecretvalue and issecretvalue(v))
end

---Adds an ability that can autocast to `states`, unless its state is unreadable.
---@param states table<string, PetAutocastCheckAutocastState>
---@param name GameValue
---@param allowed GameValue
---@param enabled GameValue
---@param icon (number|string)?
local function Add(states, name, allowed, enabled, icon)
    if type(name) == "string" and allowed and Readable(enabled) then
        states[name] = { on = enabled and true or false, icon = icon }
    end
end

---Reads the pet's spellbook into `states`, through C_SpellBook as Forever has it. A client
---without it (Classic Era has only the old globals) is left to the pet bar. A command (Attack,
---Follow) is in the book too, with no autocast values; an entry that cannot be read is skipped.
---@param states table<string, PetAutocastCheckAutocastState>
local function ReadBook(states)
    local book = C_SpellBook
    if book and book.GetSpellBookItemAutoCast and book.GetSpellBookItemInfo and book.HasPetSpells then
        local bank = Enum.SpellBookSpellBank.Pet
        -- The first value is the count; the client also returns the pet's type ("PET", "DEMON").
        for index = 1, tonumber((book.HasPetSpells())) or 0 do
            local okInfo, info = pcall(book.GetSpellBookItemInfo, index, bank)
            local okCast, allowed, enabled = pcall(book.GetSpellBookItemAutoCast, index, bank)
            if okInfo and okCast and type(info) == "table" then Add(states, info.name, allowed, enabled) end
        end
    end
end

---Reads the pet bar into `states`; it also gives each ability's icon.
---@param states table<string, PetAutocastCheckAutocastState>
local function ReadBar(states)
    if not GetPetActionInfo then return end
    for slot = 1, NUM_PET_ACTION_SLOTS or 10 do
        local name, texture, isToken, _, allowed, enabled = GetPetActionInfo(slot)
        -- Attack, Follow and the stances are tokens; they never autocast.
        if not isToken then Add(states, name, allowed, enabled, texture) end
    end
end

---The pet's abilities that can autocast, by name, with whether autocast is on. Empty without a
---pet. The spellbook has them all; the pet bar, read last, gives the ones on it their icon.
---@return table<string, PetAutocastCheckAutocastState>
function ns.PetAutocasts()
    ---@type table<string, PetAutocastCheckAutocastState>
    local states = {}
    if not UnitExists("pet") then return states end
    ReadBook(states)
    ReadBar(states)
    return states
end

---The toast for a problem, about the ability as the pet bar shows it.
---@param key string one of ORDER
---@param mode PetAutocastCheckMode the mode it is wrong for
---@param name string? the ability's name; looked up when nil
---@param icon (number|string)? its icon; looked up when nil
---@return PetAutocastCheckToastInfo
function ns.ProblemToast(key, mode, name, icon)
    local problem = PROBLEMS[key]
    local spellName, spellIcon = ns.SpellInfo(problem.spell)
    name = name or spellName or FALLBACK_NAMES[problem.spell]
    return {
        key = key,
        title = ns.Format(problem.title, name),
        name = name,
        icon = icon or spellIcon,
        reason = L[REASONS[mode]],
        hint = L[problem.hint],
    }
end

---Whether the player is inside a dungeon or raid instance (not a battleground or arena).
---@return boolean
local function InDungeon()
    local inInstance, kind = IsInInstance()
    return inInstance == true and (kind == "party" or kind == "raid")
end

---The mode in force: kite or tank when chosen, else dungeon in a dungeon or raid group, else
---solo.
---@return PetAutocastCheckMode
function ns.Mode()
    local chosen = ns.db.mode
    if chosen == "kite" or chosen == "tank" then return chosen end
    if IsInGroup() and InDungeon() then return "dungeon" end
    return "solo"
end

---Adds the problem of one ability to `found`, when it is watched and not as the mode wants.
---@param found table<string, PetAutocastCheckToastInfo>
---@param states table<string, PetAutocastCheckAutocastState>
---@param spell number
---@param prefix "growl"|"cower" the problem keys' start
---@param wanted boolean whether the mode wants it on autocast
---@param mode PetAutocastCheckMode
local function Compare(found, states, spell, prefix, wanted, mode)
    local name = ns.SpellInfo(spell)
    local state = name and states[name]
    if not state or state.on == wanted then return end
    local key = prefix .. (state.on and "On" or "Off")
    found[key] = ns.ProblemToast(key, mode, name, state.icon)
end

---What is wrong right now, by problem key.
---@return table<string, PetAutocastCheckToastInfo>
local function Problems()
    ---@type table<string, PetAutocastCheckToastInfo>
    local found = {}
    local db = ns.db
    local states = ns.PetAutocasts()
    local mode = ns.Mode()
    local growlWanted = GROWL_WANTED[mode]
    if db.growl then Compare(found, states, GROWL, "growl", growlWanted, mode) end
    if db.cower then Compare(found, states, COWER, "cower", not growlWanted, mode) end
    return found
end

-- The problems found by the last check.
---@type table<string, PetAutocastCheckToastInfo>
local active = {}

---Compares what is wrong now with the last check: a new problem toasts, a solved one takes its
---toast away. With remindAll, every problem toasts, new or not.
---@param remindAll boolean?
function ns.Check(remindAll)
    local found = Problems()
    for _, key in ipairs(ORDER) do
        local info = found[key]
        if info and (remindAll or not active[key]) then
            ns.Debug("problem: " .. key)
            ns.ShowToast(info)
        elseif not info and active[key] then
            ns.Debug("solved: " .. key)
            ns.DropToast(key)
        end
    end
    active = found
end

-- The pet bar sends several updates for one change (a summon fills every slot); one check a
-- moment later covers them all.
local CHECK_DELAY = 0.2
local checkPending = false

local function DelayedCheck()
    checkPending = false
    ns.Check()
end

local function ScheduleCheck()
    if checkPending then return end
    checkPending = true
    C_Timer.After(CHECK_DELAY, DelayedCheck)
end

-- Events: one method per event on this frame, named after the event and called with the event's
-- own arguments. Only ADDON_LOADED is registered up front; it registers the rest once the saved
-- settings are there. PLAYER_LOGOUT strips the default values from them before the client saves
-- them.
--
-- Only a hunter has Growl and Cower. On any other class the addon stays loaded (the addon list is
-- account-wide, so disabling it here would disable it for the hunters too) but registers nothing
-- past PLAYER_LOGOUT, while /pac and the options panel keep working.
local frame = CreateFrame("Frame")

---@param name string the addon that finished loading
function frame:ADDON_LOADED(name)
    if name ~= ADDON_NAME then return end
    self:UnregisterEvent("ADDON_LOADED")
    ns.LoadSettings()
    self:RegisterEvent("PLAYER_LOGOUT")
    local _, class = UnitClass("player")
    ---@type boolean
    ns.isHunter = class == "HUNTER"
    if not ns.isHunter then return end
    ns.StartMacros()
    for _, event in ipairs({
        "PET_BAR_UPDATE",
        "UNIT_PET",
        "GROUP_ROSTER_UPDATE",
        "PLAYER_ENTERING_WORLD",
        "PLAYER_REGEN_DISABLED",
    }) do
        self:RegisterEvent(event)
    end
end

function frame:PLAYER_LOGOUT()
    ns.StripDefaults()
end

-- Autocast switched, on the pet bar or in the spellbook (Blizzard's spellbook redraws its pet
-- autocast on this event too), or the bar filled after a summon.
frame.PET_BAR_UPDATE = ScheduleCheck

-- Joined or left a group.
frame.GROUP_ROSTER_UPDATE = ScheduleCheck

-- Into or out of a dungeon: every instance has a loading screen, which ends with this event.
frame.PLAYER_ENTERING_WORLD = ScheduleCheck

-- A pet summoned, tamed or dismissed.
---@param unit string
function frame:UNIT_PET(unit)
    if unit == "player" then ScheduleCheck() end
end

-- Combat starts: the moment a wrong autocast costs something.
function frame:PLAYER_REGEN_DISABLED()
    ns.Check(ns.db.remind)
end

---@param self Frame
---@param event string
---@param ... any the event's own arguments
local function onEvent(self, event, ...)
    self[event](self, ...)
end
frame:SetScript("OnEvent", onEvent)
frame:RegisterEvent("ADDON_LOADED")
