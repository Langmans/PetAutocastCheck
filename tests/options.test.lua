-- The panel in the game's settings.

---The text of the first font string that starts with `prefix`.
local function textStarting(client, prefix)
    for _, fontString in ipairs(client.fontStrings) do
        local text = fontString.text
        if type(text) == "string" and text:sub(1, #prefix) == prefix then return text end
    end
end

local function refresh(client)
    client.ns.OptionsPanel.OnRefresh()
    return client
end

test("the panel is registered under the addon's name", function()
    local client = NewClient():login()
    eq(#client.categories, 1)
    eq(client.categories[1].name, "Pet Autocast Check")
    eq(client.categories[1].frame, client.ns.OptionsPanel)
end)

test("everything sits in a scroll frame whose content follows its width", function()
    local client = NewClient():login()
    local content = client.ns.OptionsContent
    eq(client.ns.TestButton.parent, content, "the last control scrolls too")
    eq(client.ns.KiteBox.parent, content)
    eq(content.parent.kind, "ScrollFrame")
    eq(content.parent.parent, client.ns.OptionsPanel)
    content.parent.scripts.OnSizeChanged(content.parent, 512)
    eq(content.width, 512)
end)

test("the about line comes from the .toc, through either metadata API", function()
    for _, old in ipairs({ false, true }) do
        local client = NewClient({ noAddOnsAPI = old })
        local expected = ("Version %s by %s, %s license."):format(
            TOC_METADATA.Version,
            TOC_METADATA.Author,
            TOC_METADATA["X-License"]
        )
        eq(textStarting(client, "Version "), expected)
    end
end)

test("missing metadata shows question marks and no website box", function()
    local client = NewClient({
        metadata = { Version = false, Author = false, ["X-License"] = false, ["X-Website"] = false },
    })
    eq(textStarting(client, "Version "), "Version ? by ?, ? license.")
    eq(client.ns.WebsiteBox, nil)
end)

test("a website in the .toc gets a read-only copy box", function()
    local url = "https://example.invalid/petautocastcheck"
    local client = NewClient({ metadata = { ["X-Website"] = url } })
    local box = client.ns.WebsiteBox
    eq(box.text, url)
    box:SetText("typed")
    box.scripts.OnTextChanged(box, false)
    eq(box.text, "typed", "a change by code is left alone")
    box.scripts.OnTextChanged(box, true)
    eq(box.text, url, "typing is undone")
    box.scripts.OnEditFocusGained(box)
    box.scripts.OnEditFocusLost(box)
    box.scripts.OnEscapePressed(box)
    box.scripts.OnEnterPressed(box)
end)

test("the controls show the settings, also after a change made with /pac", function()
    local client = refresh(NewClient({ savedDB = { kite = true, duration = 9, scale = 1.25 } }):login())
    local ns = client.ns
    eq(ns.KiteBox.checked, true)
    eq(ns.GrowlBox.checked, true)
    eq(ns.DurationSlider.value, 9)
    eq(ns.DurationSlider.Text.text, "Toast stays for 9 seconds")
    eq(ns.ScaleSlider.Text.text, "Toast size: 1.25")
    eq(ns.SoundButtons.family.checked, true)
    client:slash("growl off"):slash("sound off")
    refresh(client)
    eq(ns.GrowlBox.checked, false)
    eq(ns.SoundButtons.off.checked, true)
    eq(ns.SoundButtons.family.checked, false)
    ns.OptionsPanel.scripts.OnShow(ns.OptionsPanel)
end)

test("a checkbox saves a boolean and checks the pet bar again", function()
    local client = refresh(NewClient():login())
    local box = client.ns.KiteBox
    box:SetChecked(true)
    box.scripts.OnClick(box)
    eq(Saved().kite, true)
    eq(client:toastTitle(), "Cower is not on autocast")
    box:SetChecked(false)
    box.scripts.OnClick(box)
    eq(Saved().kite, false)
end)

test("a slider snaps to its step and saves", function()
    local client = refresh(NewClient():login())
    local slider = client.ns.ScaleSlider
    slider:SetValue(1.3299)
    eq(Saved().scale, 1.35)
    eq(slider.Text.text, "Toast size: 1.35")
end)

test("a sound radio button saves its mode and clears the others", function()
    local client = refresh(NewClient():login())
    local warning = client.ns.SoundButtons.warning
    warning.scripts.OnClick(warning)
    eq(Saved().sound, "warning")
    eq(warning.checked, true)
    eq(client.ns.SoundButtons.family.checked, false)
end)

test("older clients: check button label as text, slider labels as globals", function()
    local client = refresh(NewClient({ oldCheckButton = true, oldSlider = true }):login())
    eq(client.ns.KiteBox.text.text, "Kite mode")
    eq(PetAutocastCheckDurationSliderText.text, "Toast stays for 6 seconds")
    eq(PetAutocastCheckDurationSliderLow.text, "1")
end)

test("the button runs /pac test", function()
    local client = NewClient():login()
    client.ns.TestButton.scripts.OnClick(client.ns.TestButton)
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("/pac config opens the panel, or waits for the end of combat", function()
    local client = NewClient():login():slash("config")
    eq(client.opened[1], "Pet Autocast Check")
    client.inCombat = true
    client:slash("config")
    eq(#client.opened, 1)
    ok(client:printedContains("when combat ends"))
    client.inCombat = false
    client:fire("PLAYER_REGEN_ENABLED")
    eq(#client.opened, 2)
    client:fire("PLAYER_REGEN_ENABLED")
    eq(#client.opened, 2, "only once")
end)
