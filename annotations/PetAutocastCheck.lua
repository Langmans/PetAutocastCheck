---@meta
-- Editor-only types for the addon's own tables: the saved settings, the toast and what the pet
-- bar is read into. Not listed in the .toc, so the game never loads this file.

---The account-wide settings, ns.db (PetAutocastCheckDB). Every field but pos falls back to
---Core.lua's DEFAULTS through a metatable, so it always reads as a value.
---@class PetAutocastCheckSettings
---@field duration number whole seconds the toast stays before it fades, from 1 (/pac duration)
---@field scale number from 0.3 to 3 (/pac scale)
---@field sound PetAutocastCheckSoundMode (/pac sound)
---@field growl boolean warn when Growl is on autocast in a group (/pac growl)
---@field growlDungeon boolean the Growl warning only in a dungeon or raid instance (/pac dungeon growl)
---@field cowerDungeon boolean the Cower warning only in a dungeon or raid instance (/pac dungeon cower); kite mode is not affected
---@field cower boolean warn when Cower is on autocast outside kite mode (/pac cower)
---@field kite boolean kite mode: Cower belongs on autocast, so warn when it is off (/pac kite)
---@field remind boolean toast what is still wrong again when combat starts (/pac remind)
---@field debug boolean trace the checks in chat (/pac debug)
---@field pos [string, string, number, number]? point, relativePoint, x, y of a dragged toast

---What plays with the toast: the pet's own call, as when it is sent to attack (the raid warning
---for a family without one), always the raid warning, or nothing.
---@alias PetAutocastCheckSoundMode "family"|"warning"|"off"

---A value the game hands over without a known type: from a SavedVariables file, an event
---argument or an API return.
---@alias GameValue string|number|boolean|table|nil

---What a toast shows (Toast.lua).
---@class PetAutocastCheckToastInfo
---@field key string the problem it is about ("growl", "cower", "cowerOff", or "test:" and one of those); one toast per problem
---@field title string the line over the name, such as "Growl is on autocast"
---@field name string? the ability's name
---@field icon (number|string)? texture; the taunt icon when nil
---@field reason string? why that is wrong now
---@field hint string? what to do about it

---An ability on the pet bar that can autocast (Check.lua).
---@class PetAutocastCheckAutocastState
---@field on boolean whether autocast is on
---@field icon (number|string)?

---A font string with eight faint copies around it (Toast.lua); every setter goes to all nine
---through its Set method.
---@class PetAutocastCheckGlowText
---@field main FontString the readable text; the copies are anchored to it
---@field layers FontString[] the text and its copies
local GlowText = {}

---Calls a FontString method with the same arguments on the text and all its copies.
---@param method string
---@param ... any the method's arguments
function GlowText:Set(method, ...) end

---One entry of ns.Locales, from a file in Locales\.
---@class PetAutocastCheckLocale
---@field strings table<string, string>

---What Settings.RegisterCanvasLayoutCategory returns; the language server's stubs leave it
---untyped.
---@class PetAutocastCheckSettingsCategory
---@field GetID fun(self: PetAutocastCheckSettingsCategory): string|number
