-- What counts as wrong, when it toasts, and when the toast goes away.

test("solo, Growl on autocast is fine and nothing toasts", function()
    local client = NewClient():login()
    eq(client:toastTitle(), nil)
end)

test("joining a group with Growl on toasts; leaving takes the toast away", function()
    local client = NewClient():login():group(true)
    eq(client:toastTitle(), "Growl is on autocast")
    eq(client.toast.Name.text, "Growl")
    eq(client.toast.Icon.texture, 132270)
    eq(client.toast.Reason.text, "You are in a group: your pet taunts mobs off the tank.")
    eq(client.toast.Hint.text, "Right-click it on the pet bar or in your pet's spellbook to turn autocast off.")
    client:group(false)
    client:animate(1)
    eq(client.toast.shown, false, "faded out at once")
end)

test("turning Growl off in the group takes the toast away; on again toasts again", function()
    local client = NewClient():login():group(true)
    client:autocast(GROWL, false):animate(1)
    eq(client.toast.shown, false)
    client:autocast(GROWL, true)
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("a higher rank of Growl counts too", function()
    local client = NewClient()
    client.petBar[3] = { 14916, true }
    client.petBook[6] = { 14916, true }
    client:login():group(true)
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("Cower on autocast toasts outside kite mode", function()
    local client = NewClient():login():autocast(COWER, true)
    eq(client:toastTitle(), "Cower is on autocast")
    eq(client.toast.Reason.text, "Your pet throws away its threat. Kite mode is off.")
end)

test("in kite mode Cower off toasts and Cower on is right", function()
    local client = NewClient({ savedDB = { kite = true } }):login()
    eq(client:toastTitle(), "Cower is not on autocast")
    eq(client.toast.Hint.text, "Right-click it on the pet bar or in your pet's spellbook to turn autocast on.")
    client:autocast(COWER, true):animate(1)
    eq(client.toast.shown, false)
end)

test("Growl and Cower at once show one after the other, Growl first", function()
    local client = NewClient():setAutocast(COWER, true)
    client.inGroup = true
    client:login()
    eq(client:toastTitle(), "Growl is on autocast")
    client:animate(8)
    eq(client:toastTitle(), "Cower is on autocast")
end)

test("a problem that stays is not toasted again on every pet bar update", function()
    local client = NewClient():login():group(true)
    client:animate(8)
    eq(client.toast.shown, false)
    client:petBarUpdate()
    eq(client.toast.shown, false)
end)

test("many pet bar updates at once give one check", function()
    local client = NewClient():login()
    client.inGroup = true
    client:fire("PET_BAR_UPDATE"):fire("PET_BAR_UPDATE")
    eq(#client.timers, 1)
    client:advance(0.2)
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("the reminder toasts what is still wrong when combat starts", function()
    local client = NewClient():login():group(true)
    client:animate(8)
    client:fire("PLAYER_REGEN_DISABLED")
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("without the reminder, combat starting only toasts what is new", function()
    local client = NewClient({ savedDB = { remind = false } }):login():group(true)
    client:animate(8)
    client:fire("PLAYER_REGEN_DISABLED")
    eq(client.toast.shown, false)
end)

test("the Growl and Cower settings switch their warnings off", function()
    local client = NewClient({ savedDB = { growl = false, cower = false } }):setAutocast(COWER, true)
    client.inGroup = true
    client:login()
    eq(client.toast.shown, false)
end)

test("a pet summoned or dismissed is checked; another unit's pet is not", function()
    local client = NewClient()
    client.petBar = nil
    client.inGroup = true
    client:login()
    eq(client.toast.shown, false, "no pet, nothing wrong")
    client.petBar = { { 2649, true } }
    client:fire("UNIT_PET", "party1")
    eq(#client.timers, 0)
    client:fire("UNIT_PET", "player"):advance(0.2)
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("on the pet bar, an ability that cannot autocast, a token or an empty slot is skipped", function()
    local client = NewClient()
    client.petBar = { { token = "PET_ACTION_ATTACK" }, { 2649 } }
    client.petBook = {}
    client:login():group(true)
    eq(client.toast.shown, false)
    eq(client.ns.PetAutocasts()["Growl"], nil)
end)

test("in the spellbook, a command or an ability that cannot autocast is skipped", function()
    local states = NewClient({ noPetBarAPI = true }).ns.PetAutocasts()
    eq(states["Attack"], nil)
    eq(states["Great Stamina"], nil)
    eq(states["Cower"].on, false)
    eq(states["Growl"].on, true)
end)

test("Cower is seen in the spellbook though it is not on the pet bar", function()
    local client = NewClient({ savedDB = { kite = true } }):login()
    eq(client:toastTitle(), "Cower is not on autocast")
    eq(client.toast.Icon.texture, 132118, "the icon comes from the spell itself")
end)

test("a client with only the old spellbook globals reads the pet bar alone", function()
    local client = NewClient({ oldSpellBookAPI = true, savedDB = { kite = true } }):login()
    eq(client.toast.shown, false, "Cower is only in the book")
    client:group(true)
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("a spellbook entry that cannot be read is skipped; the rest is read", function()
    local client = NewClient({ noPetBarAPI = true })
    client.petBook[1] = { broken = true }
    client.petBook[2] = { 17253, true, noInfo = true }
    local states = client.ns.PetAutocasts()
    eq(states["Bite"], nil, "no name, no entry")
    eq(states["Cower"].on, false)
end)

test("without the pet spell count, only the pet bar is read", function()
    local client = NewClient({ noPetSpellCount = true, savedDB = { kite = true } }):login()
    eq(client.toast.shown, false, "Cower is only in the book")
    client:group(true)
    eq(client:toastTitle(), "Growl is on autocast", "Growl is on the bar")
end)

test("an autocast state the client hides is skipped", function()
    local client = NewClient()
    client.secret = true
    client:login():group(true)
    eq(client.toast.shown, false)
end)

test("without the pet bar API the spellbook still sees it all", function()
    local client = NewClient({ noPetBarAPI = true }):login():group(true)
    eq(client:toastTitle(), "Growl is on autocast")
    eq(client.toast.Icon.texture, 132270)
end)

test("without the pet bar and the spellbook nothing is seen", function()
    local client = NewClient({ noPetBarAPI = true, noSpellBookAPI = true }):login():group(true)
    eq(client.toast.shown, false)
end)

test("ability names come from the client's language", function()
    local client = NewClient({ locale = "deDE" }):login():group(true)
    eq(client.toast.Name.text, "Knurren")
    eq(client:toastTitle(), "Knurren wird automatisch gewirkt")
end)

test("a client that cannot name the spells sees nothing wrong", function()
    local client = NewClient({ noSpellAPI = true }):login():group(true)
    eq(client.toast.shown, false)
end)

test("a problem toast without names from the client uses the English one", function()
    local info = NewClient({ noSpellAPI = true }).ns.ProblemToast("cower")
    eq(info.name, "Cower")
    eq(info.icon, nil)
end)

test("on another class nothing but logout is watched", function()
    local client = NewClient({ class = "WARRIOR" }):login()
    local events = {}
    for _, frame in ipairs(client.frames) do
        for event in pairs(frame.events) do
            events[#events + 1] = event
        end
    end
    eq(#events, 1)
    eq(events[1], "PLAYER_LOGOUT")
end)

test("the debug trace names each problem found and solved", function()
    local client = NewClient({ savedDB = { debug = true } }):login():group(true)
    ok(client:printedContains("problem: growl"))
    client:group(false)
    ok(client:printedContains("solved: growl"))
end)
