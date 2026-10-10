local ADDON_NAME, ns = ...

-- What counts as wrong, from the pet bar's autocast state:
--   - growl:    Growl on autocast while in a party or raid. There the tank holds threat, and a
--               pet that taunts on its own pulls mobs off them. Solo, Growl on is what you want.
--   - cower:    Cower on autocast outside kite mode. It throws away the threat the pet holds.
--   - cowerOff: Cower off autocast in kite mode. While the hunter kites, the pet should not keep
--               the mob's attention, so Cower belongs on.
-- Each problem toasts when it starts; when it is solved, its toast goes away. With the remind
-- setting, everything still wrong toasts again when combat starts.
--
-- The state comes from GetPetActionInfo, so only abilities on the pet bar are seen. Ability
-- names come from the client by spell ID, so the check works in any language and at any rank.

local L = ns.L

local GROWL, COWER = 2649, 1742

-- The order toasts are shown in when several problems start at once.
local ORDER = { "growl", "cower", "cowerOff" }

-- Per problem: the ability it is about, and the locale keys for the title, the reason and the
-- hint on its toast.
---@type table<string, {spell: number, title: string, reason: string, hint: string}>
local PROBLEMS = {
    growl = { spell = GROWL, title = "TOAST_ON", reason = "REASON_GROWL", hint = "HINT_TURN_OFF" },
    cower = { spell = COWER, title = "TOAST_ON", reason = "REASON_COWER", hint = "HINT_TURN_OFF" },
    cowerOff = { spell = COWER, title = "TOAST_OFF", reason = "REASON_KITE", hint = "HINT_TURN_ON" },
}

-- The English names, for a client that cannot name the spell itself (test toasts only).
local FALLBACK_NAMES = { [GROWL] = "Growl", [COWER] = "Cower" }

---A value the addon may read: not secret (Forever hides some values in combat).
---@param v GameValue
---@return boolean
local function Readable(v)
    return not (issecretvalue and issecretvalue(v))
end

---The abilities on the pet bar that can autocast, by name, with whether autocast is on. Empty
---without a pet.
---@return table<string, PetAutocastCheckAutocastState>
function ns.PetAutocasts()
    ---@type table<string, PetAutocastCheckAutocastState>
    local states = {}
    if not UnitExists("pet") or not GetPetActionInfo then return states end
    for slot = 1, NUM_PET_ACTION_SLOTS or 10 do
        local name, texture, isToken, _, allowed, enabled = GetPetActionInfo(slot)
        -- Attack, Follow and the stances are tokens; they never autocast.
        if type(name) == "string" and not isToken and allowed and Readable(enabled) then
            states[name] = { on = enabled and true or false, icon = texture }
        end
    end
    return states
end

---The toast for a problem, about the ability as the pet bar shows it.
---@param key string one of ORDER
---@param name string? the ability's name; looked up when nil
---@param icon (number|string)? its icon; looked up when nil
---@return PetAutocastCheckToastInfo
function ns.ProblemToast(key, name, icon)
    local problem = PROBLEMS[key]
    local spellName, spellIcon = ns.SpellInfo(problem.spell)
    name = name or spellName or FALLBACK_NAMES[problem.spell]
    return {
        key = key,
        title = ns.Format(problem.title, name),
        name = name,
        icon = icon or spellIcon,
        reason = L[problem.reason],
        hint = L[problem.hint],
    }
end

---What is wrong right now, by problem key.
---@return table<string, PetAutocastCheckToastInfo>
local function Problems()
    ---@type table<string, PetAutocastCheckToastInfo>
    local found = {}
    local db = ns.db
    local states = ns.PetAutocasts()
    local growlName = ns.SpellInfo(GROWL)
    local growl = growlName and states[growlName]
    if growl and growl.on and db.growl and IsInGroup() then
        found.growl = ns.ProblemToast("growl", growlName, growl.icon)
    end
    local cowerName = ns.SpellInfo(COWER)
    local cower = cowerName and states[cowerName]
    if cower and db.kite and not cower.on then
        found.cowerOff = ns.ProblemToast("cowerOff", cowerName, cower.icon)
    elseif cower and not db.kite and db.cower and cower.on then
        found.cower = ns.ProblemToast("cower", cowerName, cower.icon)
    end
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
    for _, event in ipairs({ "PET_BAR_UPDATE", "UNIT_PET", "GROUP_ROSTER_UPDATE", "PLAYER_REGEN_DISABLED" }) do
        self:RegisterEvent(event)
    end
end

function frame:PLAYER_LOGOUT()
    ns.StripDefaults()
end

-- Autocast switched, or the bar filled after a summon.
frame.PET_BAR_UPDATE = ScheduleCheck

-- Joined or left a group.
frame.GROUP_ROSTER_UPDATE = ScheduleCheck

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
