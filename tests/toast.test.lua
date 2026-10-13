-- The toast: its animation, hold on hover, closing, moving, the queue and the sound.

local function showGrowl(client)
    client.ns.ShowToast(client.ns.ProblemToast("growlOn", "dungeon"))
    return client
end

local function showCower(client)
    client.ns.ShowToast(client.ns.ProblemToast("cowerOn", "solo"))
    return client
end

test("the toast fades in, stays for the duration, then fades out and hides", function()
    local client = showGrowl(NewClient():login())
    eq(client.toast.alpha, 1)
    client:animate(5.9)
    ok(client.toast.shown, "still up just before the duration")
    client:animate(0.3)
    ok(client.toast.alpha < 1, "fading")
    client:animate(1)
    eq(client.toast.shown, false)
end)

test("hovering holds the toast; leaving lets it fade", function()
    local client = showGrowl(NewClient():login())
    client.mouseOver = true
    client:animate(20)
    ok(client.toast.shown)
    eq(client.toast.alpha, 1)
    client.mouseOver = false
    client:animate(2)
    eq(client.toast.shown, false)
end)

test("right-click closes it and shows the next; other clicks do not", function()
    local client = showCower(showGrowl(NewClient():login()))
    client.toast.scripts.OnMouseUp(client.toast, "LeftButton")
    eq(client:toastTitle(), "Growl is on autocast")
    client.toast.scripts.OnMouseUp(client.toast, "RightButton")
    eq(client:toastTitle(), "Cower is on autocast")
    client.toast.scripts.OnMouseUp(client.toast, "RightButton")
    eq(client.toast.shown, false)
    eq(client.toast.scripts.OnUpdate, nil)
end)

test("one problem gets one toast, up or waiting", function()
    local client = showGrowl(NewClient():login())
    showCower(showCower(showGrowl(client)))
    client.ns.HideToast()
    eq(client:toastTitle(), "Cower is on autocast")
    client.ns.HideToast()
    eq(client.toast.shown, false)
end)

test("a solved problem's waiting toast is dropped", function()
    local client = showCower(showGrowl(NewClient():login()))
    client.ns.DropToast("cowerOn")
    client.ns.HideToast()
    eq(client.toast.shown, false)
end)

test("dropping a toast that is already fading does not restart the fade", function()
    local client = showGrowl(NewClient():login())
    client:animate(6.3)
    local alpha = client.toast.alpha
    client.ns.DropToast("growlOn")
    client:animate(0.05)
    ok(client.toast.alpha < alpha)
end)

test("dragging moves it and the spot is remembered", function()
    local client = showGrowl(NewClient():login())
    eq(client.toast.points[1][1], "CENTER", "default spot")
    client.toast.scripts.OnDragStart(client.toast)
    client.toast.scripts.OnDragStop(client.toast)
    eq(Saved().pos[1], "TOPLEFT")
    eq(Saved().pos[3], 300)
    client.ns.HideToast()
    showGrowl(client)
    eq(client.toast.points[1][1], "TOPLEFT", "the next toast opens at the saved spot")
end)

test("scale, and a toast without a name, icon or lines", function()
    local client = NewClient({ savedDB = { scale = 1.5 } }):login()
    client.ns.ShowToast({ key = "x", title = "T" })
    eq(client.toast.scale, 1.5)
    eq(client.toast.Name.text, "?")
    eq(client.toast.Icon.texture, "Interface\\Icons\\Ability_Physical_Taunt")
    eq(client.toast.Reason.text, "")
    eq(client.toast.Hint.text, "")
end)

test("the sound is the pet's call, as when it is sent to attack", function()
    local client = showGrowl(NewClient():login())
    eq(client.sounds[1].file, 562387, "a cat's aggro sound")
    eq(client.sounds[1].channel, "Master")
end)

test("a family without a call, or no pet, plays the raid warning", function()
    local client = NewClient():login()
    client.familyID = 24
    showGrowl(client)
    eq(client.sounds[1].id, 8959)
    client.ns.HideToast()
    client.petBar = nil
    showGrowl(client)
    eq(client.sounds[2].id, 8959)
end)

test("sound warning always plays the raid warning, sound off nothing", function()
    local client = showGrowl(NewClient({ savedDB = { sound = "warning" } }):login())
    eq(client.sounds[1].id, 8959)
    client = showGrowl(NewClient({ savedDB = { sound = "off" } }):login())
    eq(#client.sounds, 0)
end)

test("a client without mask textures still shows the toast", function()
    local client = showGrowl(NewClient({ noMasks = true }):login())
    ok(client.toast.shown)
end)
