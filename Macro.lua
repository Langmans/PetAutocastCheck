local _, ns = ...

-- Three macros for the modes, the way PetCareButton makes its PetCare macro:
--   - PACKite:    Distracting Shot with kite mode on, for kiting a mob off the pet;
--   - PACKiteOff: kite mode off, back to solo or dungeon;
--   - PACTank:    tank mode on and off.
-- Made per character, since a macro bar is per character too; only when the character macros are
-- full does one go among the account-wide ones.
--
-- Made once by themselves: the first time a hunter's macros are loaded (UPDATE_MACROS) outside
-- combat, unless PetAutocastCheckCharDB says they were made (or offered) before. A macro deleted
-- afterwards is not made again; /pac macros makes the missing ones by hand. A macro of the same
-- name that is there already is left as it is. In combat no macro can be made, so the first time
-- waits for the end of combat.
--
-- Spell names in the macro text come from the client, so they read right in any language; they
-- are written once, when the macro is made.
--
-- Only hunters listen (ns.StartMacros, from ADDON_LOADED), so another class never touches the
-- account-wide macros.

local L = ns.L

local DISTRACTING_SHOT, GROWL, COWER = 20736, 2649, 1742
-- The English names, for a client that cannot name a spell itself.
local FALLBACK_NAMES = { [DISTRACTING_SHOT] = "Distracting Shot", [GROWL] = "Growl", [COWER] = "Cower" }
-- INV_Misc_QuestionMark: the icon a macro gets when #showtooltip picks the spell's own.
local QUESTION_MARK = 134400

local MACRO_CONSTS = Constants and Constants.MacroConsts
local MAX_ACCOUNT_MACROS = MACRO_CONSTS and MACRO_CONSTS.MAX_ACCOUNT_MACROS or 120
local MAX_CHARACTER_MACROS = MACRO_CONSTS and MACRO_CONSTS.MAX_CHARACTER_MACROS or 18

---A spell's name and icon as the client gives them, with the English name when it has none.
---@param id number
---@return string name
---@return (number|string)? icon
local function Spell(id)
    local name, icon = ns.SpellInfo(id)
    return name or FALLBACK_NAMES[id], icon
end

---The macros, in the order they are made, with their text as this client would write it now.
---@return PetAutocastCheckMacro[]
function ns.Macros()
    local shot = Spell(DISTRACTING_SHOT)
    local _, cowerIcon = Spell(COWER)
    local _, growlIcon = Spell(GROWL)
    return {
        {
            name = "PACKite",
            icon = QUESTION_MARK,
            body = "#showtooltip " .. shot .. "\n/pac kite on\n/cast " .. shot,
        },
        { name = "PACKiteOff", icon = cowerIcon or QUESTION_MARK, body = "/pac kite off" },
        { name = "PACTank", icon = growlIcon or QUESTION_MARK, body = "/pac tank" },
    }
end

---Makes the macros that are not there yet: per character, or account-wide when the character
---macros are full. Says in chat what it made, and what found no room; by hand it also says when
---all were there already. Making them counts as made for this character, so they are never made
---by themselves again.
---@param byHand boolean? from /pac macros or the panel's button
---@return boolean made whether it could run (not in combat)
function ns.CreateMacros(byHand)
    if InCombatLockdown() then return false end
    ---@type string[], string[], string[]
    local character, account, full = {}, {}, {}
    for _, macro in ipairs(ns.Macros()) do
        if GetMacroIndexByName(macro.name) == 0 then
            local accountMacros, characterMacros = GetNumMacros()
            local perCharacter = characterMacros < MAX_CHARACTER_MACROS
            if perCharacter or accountMacros < MAX_ACCOUNT_MACROS then
                CreateMacro(macro.name, macro.icon, macro.body, perCharacter)
                local made = perCharacter and character or account
                made[#made + 1] = macro.name
            else
                full[#full + 1] = macro.name
            end
        end
    end
    local char = ns.char
    char.macrosMade = true
    if #character > 0 then ns.Print(ns.Format("MACROS_MADE", table.concat(character, ", "))) end
    if #account > 0 then ns.Print(ns.Format("MACROS_MADE_ACCOUNT", table.concat(account, ", "))) end
    if #full > 0 then ns.Print(ns.Format("MACROS_FULL", table.concat(full, ", "))) end
    if byHand and #character + #account + #full == 0 then ns.Print(L.MACROS_THERE) end
    return true
end

local frame = CreateFrame("Frame")

-- Events: one method per event on this frame, named after the event.

-- The macros are loaded: make them the one time. In combat that waits for the end of combat.
function frame:UPDATE_MACROS()
    if ns.char.macrosMade then
        self:UnregisterEvent("UPDATE_MACROS")
        return
    end
    if ns.CreateMacros() then
        self:UnregisterEvent("UPDATE_MACROS")
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
    end
end

function frame:PLAYER_REGEN_ENABLED()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:UPDATE_MACROS()
end

---@param self Frame
---@param event string
local function onEvent(self, event)
    self[event](self)
end
frame:SetScript("OnEvent", onEvent)

---Starts listening for the macros to load; called on ADDON_LOADED for a hunter.
function ns.StartMacros()
    frame:RegisterEvent("UPDATE_MACROS")
end
