-- The modes, what counts as wrong in each, when it toasts, and when the toast goes away.
-- The simulated pet starts as solo wants it: Growl on, Cower off.

local HINT_OFF = "Right-click it on the pet bar or in your pet's spellbook to turn autocast off."
local HINT_ON = "Right-click it on the pet bar or in your pet's spellbook to turn autocast on."

---A client logged in with the pet set as dungeon mode wants it: Growl off, Cower on.
local function dungeonReady(opts)
    return NewClient(opts):setAutocast(GROWL, false):setAutocast(COWER, true)
end

test("the mode: solo, dungeon in a dungeon or raid group, kite or tank when chosen", function()
    local client = NewClient():login()
    eq(client.ns.Mode(), "solo")
    client.inGroup = true
    eq(client.ns.Mode(), "dungeon")
    client.instance = "none"
    eq(client.ns.Mode(), "solo", "a group outside")
    client.inGroup, client.instance = false, "party"
    eq(client.ns.Mode(), "solo", "alone in a dungeon")
    for kind, mode in pairs({ raid = "dungeon", pvp = "solo", arena = "solo" }) do
        client.inGroup, client.instance = true, kind
        eq(client.ns.Mode(), mode, kind)
    end
    client:slash("kite")
    eq(client.ns.Mode(), "kite")
    client:slash("tank")
    eq(client.ns.Mode(), "tank")
end)

test("solo, Growl on and Cower off is right and nothing toasts", function()
    local client = NewClient():login()
    eq(client:toastTitle(), nil)
end)

test("solo, Growl off toasts, and so does Cower on", function()
    local client = NewClient():login():autocast(GROWL, false)
    eq(client:toastTitle(), "Growl is not on autocast")
    eq(client.toast.Reason.text, "Solo your pet holds the mobs: Growl on, Cower off.")
    eq(client.toast.Hint.text, HINT_ON)
    client:autocast(GROWL, true):animate(1)
    eq(client.toast.shown, false)
    client:autocast(COWER, true)
    eq(client:toastTitle(), "Cower is on autocast")
    eq(client.toast.Hint.text, HINT_OFF)
end)

test("a dungeon group wants Growl off and Cower on; both toast, Growl first", function()
    local client = NewClient():login():group(true)
    eq(client:toastTitle(), "Growl is on autocast")
    eq(client.toast.Name.text, "Growl")
    eq(client.toast.Icon.texture, 132270)
    eq(client.toast.Reason.text, "In a dungeon group the tank holds the mobs: Growl off, Cower on.")
    client:animate(8)
    eq(client:toastTitle(), "Cower is not on autocast")
    eq(client.toast.Icon.texture, 132118, "Cower is only in the book; the icon comes from the spell")
end)

test("leaving the group takes the toasts away", function()
    local client = NewClient():login():group(true)
    client:group(false):animate(1)
    eq(client.toast.shown, false, "faded out at once, and the waiting one dropped")
end)

test("set right for the dungeon, nothing toasts; Growl back on toasts", function()
    -- Solo at login, so Growl off toasts first; the group makes it right and it fades.
    local client = dungeonReady():login():group(true):animate(1)
    eq(client.toast.shown, false)
    client:autocast(GROWL, true)
    eq(client:toastTitle(), "Growl is on autocast")
end)

test("a group outside a dungeon is solo", function()
    local client = NewClient()
    client.instance = "none"
    client:login():group(true)
    eq(client.toast.shown, false)
end)

test("entering a dungeon with the group toasts; leaving it takes the toast away", function()
    local client = NewClient():setAutocast(COWER, true)
    client.instance = "none"
    client:login():group(true)
    eq(client:toastTitle(), "Cower is on autocast", "solo still")
    client.ns.HideToast()
    client.instance = "party"
    client:fire("PLAYER_ENTERING_WORLD"):advance(0.2)
    eq(client:toastTitle(), "Growl is on autocast")
    client.instance = "none"
    client:fire("PLAYER_ENTERING_WORLD"):advance(0.2)
    client:animate(1)
    eq(client:toastTitle(), "Cower is on autocast", "solo again: Cower on is wrong again")
end)

test("kite mode wants Growl off and Cower on, anywhere", function()
    local client = NewClient({ savedDB = { mode = "kite" } })
    client.instance = "none"
    client:login()
    eq(client:toastTitle(), "Growl is on autocast")
    eq(client.toast.Reason.text, "Kite mode: the mob is on you, not on your pet: Growl off, Cower on.")
    client:autocast(GROWL, false):autocast(COWER, true):animate(1)
    eq(client.toast.shown, false)
end)

test("tank mode wants Growl on and Cower off, in a dungeon group too", function()
    local client = NewClient({ savedDB = { mode = "tank" } }):login():group(true)
    eq(client.toast.shown, false)
    client:autocast(COWER, true)
    eq(client:toastTitle(), "Cower is on autocast")
    eq(client.toast.Reason.text, "Tank mode: your pet tanks for the group: Growl on, Cower off.")
end)

test("a higher rank of Growl counts too", function()
    local client = NewClient()
    client.petBar[3] = { 14916, false }
    client.petBook[6] = { 14916, false }
    client:login()
    eq(client:toastTitle(), "Growl is not on autocast")
end)

test("a problem that stays is not toasted again on every pet bar update", function()
    local client = NewClient():login():autocast(GROWL, false)
    client:animate(8)
    eq(client.toast.shown, false)
    client:petBarUpdate()
    eq(client.toast.shown, false)
end)

test("many pet bar updates at once give one check", function()
    local client = NewClient():login():setAutocast(GROWL, false)
    client:fire("PET_BAR_UPDATE"):fire("PET_BAR_UPDATE")
    eq(#client.timers, 1)
    client:advance(0.2)
    eq(client:toastTitle(), "Growl is not on autocast")
end)

test("the reminder toasts what is still wrong when combat starts", function()
    local client = NewClient():login():autocast(GROWL, false)
    client:animate(8)
    client:fire("PLAYER_REGEN_DISABLED")
    eq(client:toastTitle(), "Growl is not on autocast")
end)

test("without the reminder, combat starting only toasts what is new", function()
    local client = NewClient({ savedDB = { remind = false } }):login():autocast(GROWL, false)
    client:animate(8)
    client:fire("PLAYER_REGEN_DISABLED")
    eq(client.toast.shown, false)
end)

test("the Growl and Cower settings switch their warnings off", function()
    local client = NewClient({ savedDB = { growl = false, cower = false } }):login():group(true)
    eq(client.toast.shown, false)
end)

test("a pet summoned or dismissed is checked; another unit's pet is not", function()
    local client = NewClient()
    client.petBar = nil
    client:login()
    eq(client.toast.shown, false, "no pet, nothing wrong")
    client.petBar = { { 2649, false } }
    client.petBook = {}
    client:fire("UNIT_PET", "party1")
    eq(#client.timers, 0)
    client:fire("UNIT_PET", "player"):advance(0.2)
    eq(client:toastTitle(), "Growl is not on autocast")
end)

test("on the pet bar, an ability that cannot autocast, a token or an empty slot is skipped", function()
    local client = NewClient()
    client.petBar = { { token = "PET_ACTION_ATTACK" }, { 2649 } }
    client.petBook = {}
    client:login()
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
    local client = NewClient():setAutocast(COWER, true):login()
    eq(client:toastTitle(), "Cower is on autocast")
end)

test("a client with only the old spellbook globals reads the pet bar alone", function()
    local client = NewClient({ oldSpellBookAPI = true }):setAutocast(COWER, true):login()
    eq(client.toast.shown, false, "Cower is only in the book")
    client:autocast(GROWL, false)
    eq(client:toastTitle(), "Growl is not on autocast")
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
    local client = NewClient({ noPetSpellCount = true }):setAutocast(COWER, true):login()
    eq(client.toast.shown, false, "Cower is only in the book")
    client:autocast(GROWL, false)
    eq(client:toastTitle(), "Growl is not on autocast", "Growl is on the bar")
end)

test("an autocast state the client hides is skipped", function()
    -- In a dungeon group both on is wrong for Growl; hidden, neither is judged.
    local client = NewClient():setAutocast(COWER, true)
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
    local info = NewClient({ noSpellAPI = true }).ns.ProblemToast("cowerOn", "solo")
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
    ok(client:printedContains("problem: growlOn"))
    client:group(false)
    ok(client:printedContains("solved: growlOn"))
end)
