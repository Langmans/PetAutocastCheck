-- The three macros: made once by themselves, by hand with /pac macros, and where they go.

local function fill(list, count)
    for i = 1, count do
        list[i] = { name = "M" .. i }
    end
end

test("the first time the macros load, the three are made for this character", function()
    local client = NewClient():login():fire("UPDATE_MACROS")
    eq(#client.charMacros, 3)
    eq(#client.macros, 0)
    local kite = client:macro("PACKite")
    eq(kite.body, "#showtooltip Distracting Shot\n/pac kite on\n/cast Distracting Shot")
    eq(kite.icon, 134400, "#showtooltip picks the spell's icon")
    eq(client:macro("PACKiteOff").body, "/pac kite off")
    eq(client:macro("PACKiteOff").icon, 132118, "Cower's icon")
    eq(client:macro("PACTank").body, "/pac tank")
    eq(client:macro("PACTank").icon, 132270, "Growl's icon")
    ok(client:printedContains("Made the macros PACKite, PACKiteOff, PACTank for this character"))
    eq(SavedChar().macrosMade, true)
end)

test("the macros run what they say", function()
    local client = NewClient():login():fire("UPDATE_MACROS")
    client:slash(client:macro("PACKite").body:match("/pac (kite on)"))
    eq(Saved().mode, "kite")
    client:slash(client:macro("PACKiteOff").body:match("/pac (.*)"))
    eq(Saved().mode, "auto")
    client:slash(client:macro("PACTank").body:match("/pac (.*)"))
    eq(Saved().mode, "tank")
end)

test("once made, they are not made again, not even after being deleted", function()
    local client = NewClient():login():fire("UPDATE_MACROS")
    client.charMacros = {}
    client:fire("UPDATE_MACROS")
    eq(#client.charMacros, 0, "this session")
    client = NewClient({ savedChar = SavedChar() }):login():fire("UPDATE_MACROS")
    eq(#client.charMacros, 0, "after a relog")
end)

test("a macro of the same name is left alone; the rest are made, and nothing more is said", function()
    local client = NewClient():login()
    client.charMacros[1] = { name = "PACTank", body = "mine" }
    client:fire("UPDATE_MACROS")
    eq(client:macro("PACTank").body, "mine")
    eq(#client.charMacros, 3)
    client = NewClient():login()
    client.macros = { { name = "PACKite" }, { name = "PACKiteOff" }, { name = "PACTank" } }
    client:fire("UPDATE_MACROS")
    eq(#client.printed, 0, "all there: silent the first time")
    eq(SavedChar().macrosMade, true)
end)

test("with the character macros full they go among the account ones", function()
    local client = NewClient():login()
    fill(client.charMacros, 29)
    client:fire("UPDATE_MACROS")
    eq(client.charMacros[30].name, "PACKite")
    eq(client.macros[1].name, "PACKiteOff")
    eq(client.macros[2].name, "PACTank")
    ok(client:printedContains("Made the macros PACKite for this character"))
    ok(client:printedContains("Made PACKiteOff, PACTank among the account-wide macros"))
end)

test("without the client's limits the addon's own (18 character macros) apply", function()
    local client = NewClient({ noMacroConsts = true }):login()
    fill(client.charMacros, 18)
    client:fire("UPDATE_MACROS")
    eq(client.macros[1].name, "PACKite")
end)

test("with both full it says which found no room", function()
    local client = NewClient():login()
    fill(client.charMacros, 30)
    fill(client.macros, 120)
    client:fire("UPDATE_MACROS")
    ok(client:printedContains("No room for PACKite, PACKiteOff, PACTank"))
    eq(SavedChar().macrosMade, true, "offered once")
end)

test("in combat it waits for the end of combat", function()
    local client = NewClient():login()
    client.inCombat = true
    client:fire("UPDATE_MACROS")
    eq(#client.charMacros, 0)
    client.inCombat = false
    client:fire("PLAYER_REGEN_ENABLED")
    eq(#client.charMacros, 3)
    client:fire("PLAYER_REGEN_ENABLED")
    eq(#client.charMacros, 3, "once")
end)

test("/pac macros makes the missing ones, says when all are there, and not in combat", function()
    local client = NewClient({ savedChar = { macrosMade = true } }):login()
    client:slash("macros")
    eq(#client.charMacros, 3)
    client:slash("macro")
    ok(client:printedContains("The macros PACKite, PACKiteOff and PACTank are there already."))
    client.inCombat = true
    client:slash("macros")
    ok(client:printedContains("Macros cannot be made in combat"))
end)

test("the panel's button runs /pac macros", function()
    local client = NewClient():login()
    client.ns.MacrosButton.scripts.OnClick(client.ns.MacrosButton)
    eq(#client.charMacros, 3)
end)

test("spell names come from the client's language, or English without them", function()
    local client = NewClient({ locale = "deDE" }):login():fire("UPDATE_MACROS")
    eq(client:macro("PACKite").body, "#showtooltip Ablenkender Schuss\n/pac kite on\n/cast Ablenkender Schuss")
    client = NewClient({ noSpellAPI = true }):login():fire("UPDATE_MACROS")
    eq(client:macro("PACKite").body, "#showtooltip Distracting Shot\n/pac kite on\n/cast Distracting Shot")
    eq(client:macro("PACTank").icon, 134400)
end)

test("another class never makes them", function()
    local client = NewClient({ class = "MAGE" }):login():fire("UPDATE_MACROS")
    eq(#client.charMacros, 0)
end)

test("a broken saved character table is replaced", function()
    NewClient({ savedChar = "broken" }):login()
    eq(SavedChar().macrosMade, false)
end)
