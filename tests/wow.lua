-- A simulated WoW client: just the API this addon touches, with every value a
-- test may want to vary exposed on the client object. NewClient() resets all
-- globals and loads the addon files in .toc order into a fresh namespace, so
-- tests never share state.

-- The spells the simulated client knows, per locale: id -> { name, icon }.
local SPELLS = {
    enUS = {
        [2649] = { "Growl", 132270 },
        [14916] = { "Growl", 132270 }, -- a higher rank: same name
        [1742] = { "Cower", 132118 },
        [17253] = { "Bite", 132278 },
    },
    deDE = {
        [2649] = { "Knurren", 132270 },
        [14916] = { "Knurren", 132270 },
        [1742] = { "Ducken", 132118 },
        [17253] = { "Biss", 132278 },
    },
}

---@param opts {locale: string?, class: string?, savedDB: table?, oldSpellAPI: boolean?, noSpellAPI: boolean?, noTextureAPI: boolean?, noPetBarAPI: boolean?, noMasks: boolean?, oldCheckButton: boolean?, oldSlider: boolean?, metadata: table?, noAddOnsAPI: boolean?}?
function NewClient(opts)
    opts = opts or {}
    -- opts.locale: the client's language. Spell names exist here for enUS and deDE; any other
    -- locale reads the English ones.
    local locale = opts.locale or "enUS"
    local spells = SPELLS[locale] or SPELLS.enUS
    function GetLocale()
        return locale
    end
    local client = {
        time = 100,
        timers = {},
        frames = {},
        printed = {},
        sounds = {},
        -- The pet bar of the active pet: one entry per slot, { spellID, autocast } for a spell
        -- (autocast nil when it cannot autocast) or { token = "PET_ACTION_ATTACK" }. nil means
        -- no pet out.
        petBar = {
            { token = "PET_ACTION_ATTACK" },
            { token = "PET_ACTION_FOLLOW" },
            { 17253, true },
            { 2649, true },
            { 1742, false },
        },
        inGroup = false,
        mouseOver = false,
    }

    function UnitClass()
        local classFile = opts.class or "HUNTER"
        return classFile, classFile
    end
    function UnitExists(unit)
        return unit == "player" or (unit == "pet" and client.petBar ~= nil)
    end
    function IsInGroup()
        return client.inGroup
    end
    -- client.familyID: the pet's CreatureFamily ID (2 = cat by default).
    client.familyID = 2
    function UnitCreatureFamily(unit)
        if unit ~= "pet" or not client.petBar then return nil end
        return "Cat", client.familyID
    end
    -- client.sounds: { file = FileDataID } for a sound file, { id = SoundKit ID } for a kit.
    function PlaySoundFile(file, channel)
        client.sounds[#client.sounds + 1] = { file = file, channel = channel }
    end
    function PlaySound(id, channel)
        client.sounds[#client.sounds + 1] = { id = id, channel = channel }
    end
    function print(text)
        client.printed[#client.printed + 1] = text
    end
    -- client.secret: a value the client hides from addons (in combat, on Forever).
    issecretvalue = function(value)
        return value ~= nil and value == client.secret
    end

    -- Spell lookups: C_Spell on newer clients, GetSpellInfo with opts.oldSpellAPI, neither with
    -- opts.noSpellAPI.
    local function getName(id)
        local s = spells[id]
        return s and s[1]
    end
    local function getTexture(id)
        local s = spells[id]
        return s and s[2]
    end
    C_Spell, GetSpellInfo = nil, nil
    if opts.oldSpellAPI then
        function GetSpellInfo(id)
            local s = spells[id]
            if s then return s[1], nil, s[2] end
        end
    elseif not opts.noSpellAPI then
        C_Spell = { GetSpellName = getName, GetSpellTexture = not opts.noTextureAPI and getTexture or nil }
    end

    -- GetPetActionInfo as the Classic pet bar reads it: name, texture, isToken, isActive,
    -- autoCastAllowed, autoCastEnabled, spellID. A token's name is a global string's name.
    -- Absent with opts.noPetBarAPI.
    NUM_PET_ACTION_SLOTS = 10
    if opts.noPetBarAPI then
        GetPetActionInfo = nil
    else
        function GetPetActionInfo(slot)
            local entry = client.petBar and client.petBar[slot]
            if not entry then return nil end
            if entry.token then return entry.token, entry.token .. "_TEXTURE", true, false, false, false end
            local id, autocast = entry[1], entry[2]
            return getName(id), getTexture(id), false, false, autocast ~= nil, autocast == true, id
        end
    end

    C_Timer = {
        After = function(seconds, callback)
            client.timers[#client.timers + 1] = { at = client.time + seconds, callback = callback }
        end,
    }

    -- Layout calls only matter to the real UI; they do nothing here. A region keeps what tests
    -- read back: text, texture, alpha, scale, shown state, points and font.
    local function noop() end
    local Region = {}
    -- Methods the addon tests for before calling them stay absent unless defined.
    -- So do parentKeys, which are fields rather than methods.
    local OPTIONAL =
        { CreateMaskTexture = true, Text = true, text = true, Low = true, High = true, SetObeyStepOnDrag = true }
    Region.__index = function(_, key)
        if OPTIONAL[key] then return Region[key] end
        return Region[key] or noop
    end
    function Region:SetText(text)
        self.text = text
    end
    function Region:GetText()
        return self.text
    end
    function Region:SetTexture(texture)
        self.texture = texture
    end
    function Region:SetAlpha(alpha)
        self.alpha = alpha
    end
    function Region:SetScale(scale)
        self.scale = scale
    end
    function Region:SetWidth(width)
        self.width = width
    end
    function Region:SetSize(width, height)
        self.width, self.height = width, height
    end
    function Region:Show()
        self.shown = true
    end
    function Region:Hide()
        self.shown = false
    end
    function Region:IsShown()
        return self.shown
    end
    function Region:ClearAllPoints()
        self.points = {}
    end
    function Region:SetPoint(point, relativeTo, relativePoint, x, y)
        self.points[#self.points + 1] = { point, relativeTo, relativePoint, x, y }
    end
    function Region:GetPoint(index)
        local p = self.points[index]
        return p[1], p[2], p[3], p[4], p[5]
    end
    function Region:GetFont()
        return self.fontPath or "Fonts\\FRIZQT__.TTF", self.fontSize or 12, self.fontFlags
    end
    function Region:SetFont(path, size, flags)
        self.fontPath, self.fontSize, self.fontFlags = path, size, flags
    end

    local function newRegion(fields)
        fields = fields or { shown = true }
        fields.points = {}
        return setmetatable(fields, Region)
    end

    function Region:CreateTexture()
        return newRegion()
    end
    client.fontStrings = {}
    function Region:CreateFontString()
        local region = newRegion()
        client.fontStrings[#client.fontStrings + 1] = region
        return region
    end
    if not opts.noMasks then
        function Region:CreateMaskTexture()
            return newRegion()
        end
    end
    function Region:RegisterEvent(event)
        self.events[event] = true
    end
    function Region:UnregisterEvent(event)
        self.events[event] = nil
    end
    function Region:SetScript(script, handler)
        self.scripts[script] = handler
    end
    function Region:IsMouseOver()
        return client.mouseOver
    end
    function Region:StopMovingOrSizing()
        -- The real client leaves the frame anchored where it was dropped.
        self.points = { { "TOPLEFT", nil, "BOTTOMLEFT", 300, 700 } }
    end

    function CreateFrame(kind, name, parent)
        local frame = newRegion({ kind = kind, parent = parent, events = {}, scripts = {}, shown = true })
        client.frames[#client.frames + 1] = frame
        if name then _G[name] = frame end
        -- Like UICheckButtonTemplate: a checked state and its label as the Text parentKey, or as
        -- `text` on older clients (opts.oldCheckButton).
        if kind == "CheckButton" then
            local label = newRegion()
            if opts.oldCheckButton then
                frame.text = label
            else
                frame.Text = label
            end
            function frame:SetChecked(checked)
                self.checked = checked and true or false
            end
            -- Some clients answer 1/nil rather than true/false.
            function frame:GetChecked()
                return self.checked and 1 or nil
            end
        end
        -- Like OptionsSliderTemplate: its labels as parentKeys, or with opts.oldSlider only as
        -- global names ($parentText, ...) and without SetObeyStepOnDrag. SetValue reports a
        -- change through OnValueChanged, as the client does.
        if kind == "Slider" then
            local text, low, high = newRegion(), newRegion(), newRegion()
            if opts.oldSlider then
                _G[name .. "Text"], _G[name .. "Low"], _G[name .. "High"] = text, low, high
            else
                frame.Text, frame.Low, frame.High = text, low, high
                function frame:SetObeyStepOnDrag(obey)
                    self.obeyStep = obey
                end
            end
            function frame:SetValue(value)
                if value == self.value then return end
                self.value = value
                if self.scripts.OnValueChanged then self.scripts.OnValueChanged(self, value) end
            end
        end
        return frame
    end
    UIParent = newRegion()

    -- The .toc's "## Key: value" lines (handed over by run.mjs), plus opts.metadata on top:
    -- through C_AddOns, or the global on older clients (opts.noAddOnsAPI).
    local function getMetadata(name, key)
        if name ~= "PetAutocastCheck" then return nil end
        if opts.metadata and opts.metadata[key] ~= nil then return opts.metadata[key] or nil end
        return TOC_METADATA[key]
    end
    if opts.noAddOnsAPI then
        C_AddOns, GetAddOnMetadata = nil, getMetadata
    else
        C_AddOns, GetAddOnMetadata = { GetAddOnMetadata = getMetadata }, nil
    end

    -- client.inCombat: whether the player is in combat.
    function InCombatLockdown()
        return client.inCombat == true
    end
    -- The settings window: client.categories holds what was registered, client.opened the IDs
    -- of the categories opened.
    client.categories, client.opened = {}, {}
    Settings = {
        RegisterCanvasLayoutCategory = function(frame, name)
            local category = { frame = frame, name = name }
            function category:GetID()
                return self.name
            end
            return category
        end,
        RegisterAddOnCategory = function(category)
            client.categories[#client.categories + 1] = category
        end,
        OpenToCategory = function(id)
            client.opened[#client.opened + 1] = id
        end,
    }

    SlashCmdList = {}
    PetAutocastCheckDB = opts.savedDB

    local ns = {}
    for _, file in ipairs(TOC_FILES) do
        local chunk = assert(loadfile(ROOT .. "/" .. file))
        chunk("PetAutocastCheck", ns)
    end
    client.ns = ns
    client.toast = ns.toast

    ---Delivers an event to every frame registered for it.
    function client:fire(event, ...)
        for _, frame in ipairs(self.frames) do
            if frame.events[event] and frame.scripts.OnEvent then frame.scripts.OnEvent(frame, event, ...) end
        end
        return self
    end

    ---Moves the clock on and runs the C_Timer callbacks that came due.
    function client:advance(seconds)
        self.time = self.time + seconds
        local due = {}
        for i = #self.timers, 1, -1 do
            if self.timers[i].at <= self.time then table.insert(due, 1, table.remove(self.timers, i)) end
        end
        for _, timer in ipairs(due) do
            timer.callback()
        end
        return self
    end

    ---What the client does at login: ADDON_LOADED for each addon, then the pet bar filling.
    function client:login()
        self:fire("ADDON_LOADED", "SomeOtherAddon")
        self:fire("ADDON_LOADED", "PetAutocastCheck")
        return self:petBarUpdate()
    end

    ---The pet bar changed (autocast switched, a pet summoned); the addon checks a moment later.
    function client:petBarUpdate()
        self:fire("PET_BAR_UPDATE")
        return self:advance(0.2)
    end

    ---Switches autocast of the pet bar slot holding `id`.
    function client:autocast(id, on)
        for _, entry in ipairs(self.petBar) do
            if entry[1] == id then entry[2] = on end
        end
        return self:petBarUpdate()
    end

    ---Joins or leaves a group.
    function client:group(inGroup)
        self.inGroup = inGroup
        self:fire("GROUP_ROSTER_UPDATE")
        return self:advance(0.2)
    end

    ---Runs the toast's OnUpdate for `seconds`, in frames of `step`. Like the client, a hidden
    ---frame gets no more updates.
    function client:animate(seconds, step)
        step = step or 0.05
        local elapsed = 0
        while elapsed < seconds - 1e-9 and self.toast.shown and self.toast.scripts.OnUpdate do
            self.toast.scripts.OnUpdate(self.toast, step)
            elapsed = elapsed + step
        end
        return self
    end

    function client:slash(message)
        SlashCmdList.PETAUTOCASTCHECK(message)
        return self
    end

    function client:printedContains(text)
        for _, line in ipairs(self.printed) do
            if line:find(text, 1, true) then return true end
        end
        return false
    end

    ---The title of the toast that is up, or nil.
    function client:toastTitle()
        if not self.toast.shown then return nil end
        return self.toast.Title.text
    end

    return client
end

function Saved()
    return PetAutocastCheckDB
end

GROWL, COWER = 2649, 1742
