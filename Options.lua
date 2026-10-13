local ADDON_NAME, ns = ...

-- The panel in the game's settings (Esc > Options > AddOns, or /pac config). From top to bottom:
--   - the version, author and license from the .toc, and the website in a box to copy it from (a
--     link in the game cannot open a browser) when the .toc names one, and what the addon does;
--   - the settings: the mode (automatic, /pac kite or /pac tank), checkboxes for /pac growl,
--     cower and remind, sliders for /pac duration and /pac scale, the three /pac sound choices,
--     a checkbox for /pac debug, and a button for /pac test.
-- Everything is filled from ns.db every time the panel is shown, so a change made with /pac in
-- the meantime shows up; a click writes straight to ns.db and checks the pet bar again.
-- The whole panel scrolls: the settings window is shorter than the panel on a small screen.
-- Registered through the Settings API, which every targeted flavor has.

local L = ns.L

local panel = CreateFrame("Frame")
ns.OptionsPanel = panel

-- Everything is laid out on `content`, the scroll child, CONTENT_HEIGHT tall: the panel from the
-- title to the test button, with some room to spare. Its width follows the scroll frame, whose
-- size the settings window decides; CONTENT_WIDTH only holds until then.
-- UIPanelScrollFrameTemplate puts its scroll bar just outside the frame's right edge, hence the
-- room on the right.
local CONTENT_WIDTH, CONTENT_HEIGHT = 600, 900
local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 0, -4)
scroll:SetPoint("BOTTOMRIGHT", -28, 4)
local content = CreateFrame("Frame", nil, scroll)
content:SetSize(CONTENT_WIDTH, CONTENT_HEIGHT)
scroll:SetScrollChild(content)
---@param _ ScrollFrame
---@param width number
local function onScrollSized(_, width)
    content:SetWidth(width)
end
scroll:SetScript("OnSizeChanged", onScrollSized)
ns.OptionsContent = content

-- Where UICheckButtonTemplate's label starts, from the box's left edge (the box is 32 wide).
local CHECKBOX_LABEL_X = 30

---Stretches a text anchored at its top left to 16 pixels from the content's right edge, so it
---wraps there.
---@param fontString FontString
local function toRightEdge(fontString)
    fontString:SetPoint("RIGHT", content, "RIGHT", -16, 0)
    fontString:SetJustifyH("LEFT")
end

local title = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(L.OPTIONS_TITLE)

-- C_AddOns has GetAddOnMetadata on newer clients, the global on older ones.
---@type fun(addon: string, key: string): string?
local GetMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
---A "## Key: value" line of this addon's .toc.
---@param key string
---@return string?
local function Metadata(key)
    return GetMetadata(ADDON_NAME, key)
end

local about = content:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
about:SetText(
    ns.Format("OPTION_ABOUT", Metadata("Version") or "?", Metadata("Author") or "?", Metadata("X-License") or "?")
)
---@type Region
local below = about

local URL = Metadata("X-Website")
if URL then
    local websiteLabel = content:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    websiteLabel:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -12)
    websiteLabel:SetText(L.OPTION_WEBSITE)
    local website = CreateFrame("EditBox", nil, content, "InputBoxTemplate")
    -- InputBoxTemplate draws its border outside the box; the extra x keeps it clear.
    website:SetPoint("LEFT", websiteLabel, "RIGHT", 12, 0)
    website:SetSize(340, 20)
    website:SetAutoFocus(false)
    website:SetFontObject("GameFontHighlightSmall")
    website:SetText(URL)
    website:SetCursorPosition(0)
    -- Read-only: whatever is typed is put back, and a click selects it all for Ctrl+C.
    ---@param _ EditBox the website box
    ---@param userInput boolean true when the player typed, false when code set the text
    local function onTextChanged(_, userInput)
        if not userInput then return end
        website:SetText(URL)
        website:HighlightText()
    end
    website:SetScript("OnTextChanged", onTextChanged)
    website:SetScript("OnEditFocusGained", function()
        website:HighlightText()
    end)
    website:SetScript("OnEditFocusLost", function()
        website:HighlightText(0, 0)
    end)
    website:SetScript("OnEscapePressed", function()
        website:ClearFocus()
    end)
    website:SetScript("OnEnterPressed", function()
        website:ClearFocus()
    end)
    ns.WebsiteBox = website
    below = websiteLabel
end

-- From here on each element goes under the one before (`below`), at `x` pixels from the column's
-- left edge. `belowX` is where `below` itself sits, so an indented line (a checkbox's note) does
-- not push everything after it to the right.
local belowX = 0

---Anchors `region` `gap` pixels under the element before, `x` pixels into the column.
---@param region Region
---@param x number
---@param gap number
local function Place(region, x, gap)
    region:SetPoint("TOPLEFT", below, "BOTTOMLEFT", x - belowX, -gap)
    below, belowX = region, x
end

local description = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
Place(description, 0, 20)
toRightEdge(description)
description:SetText(L.OPTION_DESCRIPTION)

local heading = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
Place(heading, 0, 24)
heading:SetText(L.OPTION_SETTINGS)

-- Functions that put a setting's current value into its control, run when the panel is shown.
---@type fun()[]
local syncs = {}

---A check button's label: the parentKey Text on newer clients, text on older ones (the language
---server's stubs know neither, hence rawget).
---@param button CheckButton
---@return FontString
local function LabelOf(button)
    return (rawget(button, "Text") or rawget(button, "text")) --[[@as FontString]]
end

---Radio buttons for a setting with a few named values, under a label: one button per value,
---and a line of explanation under them when there is a note. A click saves the value and checks
---the pet again, since the mode decides what counts as wrong.
---@param key "mode"|"sound"
---@param label string
---@param gap number pixels above the label
---@param choices string[][] each value with its button's label
---@param note string?
---@return table<string, CheckButton> buttons by value
local function AddRadios(key, label, gap, choices, note)
    local title = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    Place(title, 0, gap)
    title:SetText(label)
    ---@type table<string, CheckButton>
    local buttons = {}
    for _, choice in ipairs(choices) do
        ---@type string
        local value = choice[1]
        local radio = CreateFrame("CheckButton", nil, content, "UIRadioButtonTemplate")
        Place(radio, 0, 6)
        local text = LabelOf(radio)
        text:SetFontObject("GameFontHighlightSmall")
        text:SetText(choice[2])
        radio:SetScript("OnClick", function()
            local db = ns.db
            db[key] = value
            for other, button in pairs(buttons) do
                button:SetChecked(other == value)
            end
            ns.Check()
        end)
        buttons[value] = radio
    end
    if note then
        local noteText = content:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
        Place(noteText, CHECKBOX_LABEL_X, 4)
        toRightEdge(noteText)
        noteText:SetText(note)
    end
    syncs[#syncs + 1] = function()
        for value, button in pairs(buttons) do
            button:SetChecked(ns.db[key] == value)
        end
    end
    return buttons
end

---A checkbox for one boolean setting, with a line of explanation under it.
---@param key "growl"|"cower"|"remind"|"debug"
---@param label string
---@param note string
---@return CheckButton
local function AddCheckbox(key, label, note)
    local box = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
    -- The box has a few pixels of padding; two to the left lines it up with the text above.
    Place(box, -2, 10)
    local text = LabelOf(box)
    text:SetFontObject("GameFontHighlight")
    text:SetText(label)
    -- The note goes under the box, indented to where its label starts.
    local noteText = content:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    Place(noteText, CHECKBOX_LABEL_X, 0)
    toRightEdge(noteText)
    noteText:SetText(note)
    box:SetScript("OnClick", function()
        -- GetChecked returns 1/nil on some clients; the saved value must be a boolean.
        local db = ns.db
        db[key] = box:GetChecked() and true or false
        ns.Check()
    end)
    syncs[#syncs + 1] = function()
        box:SetChecked(ns.db[key])
    end
    return box
end

ns.ModeButtons = AddRadios("mode", L.OPTION_MODE, 12, {
    { "auto", L.OPTION_MODE_AUTO },
    { "kite", L.OPTION_MODE_KITE },
    { "tank", L.OPTION_MODE_TANK },
}, L.OPTION_MODE_NOTE)
---@type CheckButton
ns.GrowlBox = AddCheckbox("growl", L.OPTION_GROWL, L.OPTION_GROWL_NOTE)
---@type CheckButton
ns.CowerBox = AddCheckbox("cower", L.OPTION_COWER, L.OPTION_COWER_NOTE)
---@type CheckButton
ns.RemindBox = AddCheckbox("remind", L.OPTION_REMIND, L.OPTION_REMIND_NOTE)

-- OptionsSliderTemplate's labels have parentKeys on newer clients and only global names
-- ($parentText, ...) on older ones, hence a global name per slider.
---A slider for a number setting, with its value in its title.
---@param name string the slider's global name
---@param key "duration"|"scale"
---@param low number
---@param high number
---@param step number
---@param format fun(value: number): string the title for a value
---@return Slider
local function AddSlider(name, key, low, high, step, format)
    local slider = CreateFrame("Slider", name, content, "OptionsSliderTemplate")
    -- Room above for the title, which the template puts over the bar.
    Place(slider, 6, 32)
    slider:SetWidth(300)
    slider:SetMinMaxValues(low, high)
    slider:SetValueStep(step)
    if slider.SetObeyStepOnDrag then slider:SetObeyStepOnDrag(true) end
    ---@type FontString
    local text = slider.Text or _G[name .. "Text"]
    ---@type FontString
    local lowText = slider.Low or _G[name .. "Low"]
    ---@type FontString
    local highText = slider.High or _G[name .. "High"]
    lowText:SetText(tostring(low))
    highText:SetText(tostring(high))
    ---@param _ Slider
    ---@param value number
    local function onValueChanged(_, value)
        -- Snapped to the step and to two decimals, so a drag cannot leave 1.2999 behind.
        local snapped = math.floor(math.floor(value / step + 0.5) * step * 100 + 0.5) / 100
        local db = ns.db
        db[key] = snapped
        text:SetText(format(snapped))
    end
    slider:SetScript("OnValueChanged", onValueChanged)
    syncs[#syncs + 1] = function()
        slider:SetValue(ns.db[key])
        -- SetValue only reports a change; the title must show an unchanged value too.
        text:SetText(format(ns.db[key]))
    end
    return slider
end

---@param value number whole seconds
---@return string
local function durationTitle(value)
    return ns.Format("OPTION_DURATION", value)
end
---@param value number
---@return string
local function scaleTitle(value)
    return ns.Format("OPTION_SCALE", value)
end
---@type Slider
ns.DurationSlider = AddSlider("PetAutocastCheckDurationSlider", "duration", 1, 30, 1, durationTitle)
---@type Slider
ns.ScaleSlider = AddSlider("PetAutocastCheckScaleSlider", "scale", 0.3, 3, 0.05, scaleTitle)

-- 28 pixels: below the slider's own low/high labels.
ns.SoundButtons = AddRadios("sound", L.OPTION_SOUND, 28, {
    { "family", L.OPTION_SOUND_FAMILY },
    { "warning", L.OPTION_SOUND_WARNING },
    { "off", L.OPTION_SOUND_OFF },
})

---@type CheckButton
ns.DebugBox = AddCheckbox("debug", L.OPTION_DEBUG, L.OPTION_DEBUG_NOTE)

---@type UIPanelButtonTemplate
ns.TestButton = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
ns.TestButton:SetSize(160, 24)
ns.TestButton:SetText(L.OPTION_TEST)
ns.TestButton:SetScript("OnClick", function()
    SlashCmdList.PETAUTOCASTCHECK("test")
end)
Place(ns.TestButton, 0, 16)

-- Fills every control. The settings window calls a canvas frame's OnRefresh each time it shows
-- it; OnShow alone is not enough, since showing a frame that is already shown (the canvas was up
-- for another addon's panel) fires no OnShow.
local function Refresh()
    for i = 1, #syncs do
        syncs[i]()
    end
end
panel.OnRefresh = Refresh
panel:SetScript("OnShow", Refresh)

---@type PetAutocastCheckSettingsCategory
local category = Settings.RegisterCanvasLayoutCategory(panel, L.OPTIONS_TITLE)
Settings.RegisterAddOnCategory(category)

-- In combat the settings window is not opened from an addon: the call can be blocked or taint
-- the window. /pac config then waits for the end of combat and opens it once.
local afterCombat = CreateFrame("Frame")
afterCombat:SetScript("OnEvent", function()
    afterCombat:UnregisterEvent("PLAYER_REGEN_ENABLED")
    Settings.OpenToCategory(category:GetID())
end)

---Opens the panel in the game's settings, or once combat ends.
function ns.OpenOptions()
    if InCombatLockdown() then
        afterCombat:RegisterEvent("PLAYER_REGEN_ENABLED")
        ns.Print(L.OPTIONS_AFTER_COMBAT)
        return
    end
    Settings.OpenToCategory(category:GetID())
end
