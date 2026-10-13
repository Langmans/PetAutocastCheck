# Pet Autocast Check

Shows a toast in the middle of the screen when your hunter pet's Growl or
Cower autocast does not fit what you are doing:

> **Growl is on autocast**
> Growl
> In a dungeon group the tank holds the mobs: Growl off, Cower on.
> Right-click it on the pet bar or in your pet's spellbook to turn autocast off.

Solo your pet holds the mobs: Growl on keeps them, Cower off keeps it from
throwing that threat away. In a dungeon the tank holds them, and it is the
other way round. Both are one right-click on the pet bar or in the pet's
spellbook, and both are easy to forget when you zone in or out. This addon
tells you the moment it matters.

The toast looks like
[Pet Ability Learned](https://github.com/Langmans/PetAbilityLearned)'s
splash: a dark panel that fades out at the edges, the ability's icon in a
ring, glowing text. It plays your pet's call, the sound it makes when you send
it to attack.

## Modes

What fits depends on the mode: exactly one of Growl and Cower belongs on.

| Mode | Growl | Cower | When |
| --- | --- | --- | --- |
| **Solo** | on | off | by itself, anywhere but a dungeon group |
| **Dungeon** | off | on | by itself, in a dungeon or raid instance while in a group |
| **Kite** | off | on | chosen by you (`/pac kite`): the mob is on you, not on your pet |
| **Tank** | on | off | chosen by you (`/pac tank`): your pet tanks for a group without a tank |

Kite and tank win over what the addon picks itself, and exclude each other;
switch them off to go back to solo or dungeon. A group questing in the open
world counts as solo, and so does a dungeon on your own.

A toast shows when something stops fitting: you zone into a dungeon with
Growl on, summon a pet with Cower on, switch to kite mode. It goes away by
itself once you fix it. When combat starts, whatever is still wrong toasts
again (switch that off with `/pac remind off`). `/pac growl off` or
`/pac cower off` stops watching one of the two.

- The toast stays for 6 seconds, then fades. Hover over it to keep it up,
  right-click to close it, drag it to move it. Two problems at once show one
  after the other.
- Growl and Cower are seen whether they are on the pet bar or only in the
  pet's spellbook (Cower often is not on the bar).
- It only watches on hunters. On other characters the addon stays loaded but
  idle; `/pac` and the panel still work there.

### Kite and tank mode in a macro

`/pac kite` toggles kite mode; `/pac kite on` and `/pac kite off` set it.
`/pac tank` works the same way. Put it in the macro you kite with, so the
mode follows what you are doing:

```
#showtooltip Distracting Shot
/pac kite on
/cast Distracting Shot
```

Pressing it again while the mode is already on says nothing, so a macro you
press over and over does not fill your chat. Both have a key binding, under
Esc > Options > Keybindings > AddOns > Pet Autocast Check.

## Install

By hand:

1. Download the zip from
   [GitHub](https://github.com/Langmans/PetAutocastCheck) (Code > Download
   ZIP).
2. Unzip it into your WoW client's `Interface\AddOns` and rename the folder
   to `PetAutocastCheck`, so that you get
   `Interface\AddOns\PetAutocastCheck\PetAutocastCheck.toc`.
3. Restart the game, or `/reload` if it was running, and check that
   "PetAutocastCheck" is enabled in the AddOns list on the character screen.

Made for WoW: Forever (1.60).

## Settings

Open the panel with `/pac config`, or through Esc > Options > AddOns > Pet
Autocast Check. It shows the version and website, and has:

- **Mode**: automatic (solo or dungeon), kite, or tank.
- **Watch Growl**, **Watch Cower** and **Remind me when combat starts**.
- **Toast stays for** and **Toast size**: sliders for how long the toast
  stays and how big it is.
- **Sound**: your pet's call, the raid warning, or none.
- **Debug trace**: print in chat every problem found and solved.
- **Show a toast**: the same as `/pac test`.

The settings are saved for the whole account. The same settings are chat
commands too (`/petautocastcheck` works as well):

- `/pac` shows the mode in force and the current settings, plus the list of
  commands.
- `/pac config` (or `/pac options`) opens the panel.
- `/pac kite` and `/pac tank` toggle that mode; add `on` or `off` to set it.
- `/pac growl on|off` and `/pac cower on|off` switch watching each one.
- `/pac remind on|off` switches the reminder when combat starts.
- `/pac test [growl|cower|kite|tank]` shows a toast (Growl on in a dungeon,
  Cower on solo, Cower off in kite mode, Growl off in tank mode), whatever
  your pet says. Nothing else happens.
- `/pac duration <seconds>` sets how long the toast stays (default 6).
- `/pac scale <0.3-3>` sets its size (default 1).
- `/pac sound family` plays your pet's call (the default; `/pac sound on` does
  the same), `/pac sound warning` the raid warning, and `/pac sound off`
  nothing. Crocolisks, scorpids and bats have no call the addon knows, and
  get the raid warning.
- `/pac reset` puts the toast back in its standard spot.
- `/pac debug` switches the debug trace on or off.

## Languages

The toast, the panel and the chat messages follow your game's language:
English, German, French, Spanish, Korean and Russian. Other languages get
English. Ability names always come from the game itself. Commands and the
debug trace are English.

## Reporting a problem

If a toast does not appear when it should, or appears when it should not:

1. Type `/pac debug`.
2. Do what should have made the toast appear (or not).
3. Copy the chat lines into an
   [issue on GitHub](https://github.com/Langmans/PetAutocastCheck/issues).

## License

MIT, see [LICENSE](https://github.com/Langmans/PetAutocastCheck/blob/main/LICENSE).

---

## Technical documentation

The rest of this file is for people who want to change the addon.

### Files

In `.toc` order; all share the addon namespace `ns`.

- `Locales\*.lua` — one file per locale with its `strings`. `enUS.lua` loads
  first and creates `ns.Locales`.
- `Locale.lua` — picks the client's locale; `ns.L`, `ns.Format`.
- `Core.lua` — the saved settings (`ns.DEFAULTS`, `ns.db`,
  `ns.LoadSettings`, `ns.StripDefaults`), `ns.Print`, `ns.Debug`, and the
  lookups that differ between clients: `ns.SpellInfo` (name and icon by spell
  ID) and `ns.PetFamilyID`.
- `Toast.lua` — the toast frame (`ns.ShowToast`, `ns.DropToast`,
  `ns.HideToast`): its background, the glowing texts, the animation on one
  `OnUpdate` clock, the queue, and the sound (`FAMILY_SOUNDS`).
- `Check.lua` — reading the pet's spellbook and pet bar (`ns.PetAutocasts`), the rules
  (`PROBLEMS`, `ns.ProblemToast`, `ns.Check`) and the event frame (one method
  per event).
- `Commands.lua` — `/pac`: one function per subcommand in a `Commands` table,
  looked up by the slash handler like the event frame looks up its event
  methods; anything unknown shows the status line. Also the key bindings'
  functions and names.
- `Options.lua` — the panel in the game's settings (`ns.OpenOptions`): the
  version, author, license and website from the .toc (`GetAddOnMetadata`),
  the mode and sound radio buttons, the checkboxes, sliders and the test
  button.
- `Bindings.xml` — the kite and tank mode key bindings. The client loads it
  from the addon folder by itself; it is not in the `.toc`.
- `annotations\` — editor-only types (`---@meta`) for the addon's own tables.
  Not in the `.toc`, so the game never loads them; `.wowluarc.json` gives the
  folder to WoW Lua LS as a library, and `.pkgmeta` leaves it out of the zip.

The settings are saved account-wide in `PetAutocastCheckDB`: `duration`
(whole seconds, from 1), `scale` (0.3 to 3), `sound` (`"family"`,
`"warning"` or `"off"`), `mode` (`"auto"`, `"kite"` or `"tank"`), `growl`,
`cower`, `remind` and `debug` (booleans), and `pos`, the dragged spot as
`{ point, relativePoint, x, y }`.
Only values that differ from their default are kept: `ns.db` reads the rest
from the defaults through a metatable, a broken value is dropped on load so
its default shows through, numbers are put back in range, and
`ns.StripDefaults` removes values equal to their default on `PLAYER_LOGOUT`.

### How it works

- The autocast state comes from two places, read in this order:
  - the pet's spellbook, which holds every ability whether it is on the bar
    or not: `C_SpellBook.HasPetSpells` for the count, then per entry
    `GetSpellBookItemInfo` (the name) and `GetSpellBookItemAutoCast`
    (allowed, enabled), with `Enum.SpellBookSpellBank.Pet`. Commands (Attack,
    Follow) return neither value. A client without these (Classic Era has
    only the old `GetSpellAutocast`) is left to the pet bar.
  - `GetPetActionInfo(slot)` for the ten pet bar slots: its fifth and sixth
    returns, `autoCastAllowed` and `autoCastEnabled`. It also gives the
    ability's icon. Tokens (Attack, Follow, the stances; `isToken` is `1`)
    are skipped.

  Only abilities that can autocast count, and a value the client hides
  (`issecretvalue`) is skipped. Measured on Forever: the values are not
  hidden in combat, and a right-click on the pet bar fires `PET_BAR_UPDATE`
  (Blizzard's spellbook redraws its pet autocast on that event as well).
- Growl and Cower are recognised by name: the names of spells 2649 and 1742
  are looked up in the client, and every rank carries the same name, so
  nothing compares English text.
- The mode in force (`ns.Mode`) is the saved `mode` when that is `kite` or
  `tank`; otherwise `dungeon` while `IsInGroup()` and `IsInInstance()` is of
  type `party` or `raid`, and `solo` anywhere else. `GROWL_WANTED` in
  `Check.lua` says per mode whether Growl belongs on; Cower belongs the other
  way. An ability in the other state is a problem, keyed by ability and
  state: `growlOn`, `growlOff`, `cowerOn`, `cowerOff`. Its toast's reason
  line is the mode's (`REASON_SOLO`, ...). The `growl` and `cower` settings
  stop watching one of the two.
- `ns.Check` compares what is wrong now with the previous check: a new
  problem toasts, a solved one calls `ns.DropToast`, which fades its toast
  out if it is up and drops it if it is waiting. On
  `PLAYER_REGEN_DISABLED` with `remind` on, every problem toasts, new or not.
- `PET_BAR_UPDATE`, `GROUP_ROSTER_UPDATE`, `PLAYER_ENTERING_WORLD` (the end
  of every loading screen, so entering or leaving an instance) and `UNIT_PET`
  for the player schedule one check 0.2 s later, so the burst of updates a
  summon gives counts once. A change of setting (command, key binding or panel) checks at
  once.
- One problem has at most one toast, up or waiting. `/pac test` gives its
  toasts their own key (`test:growlOn`), so they never stand in for a real
  one.
- The sound is the aggro sound of the pet's family, by CreatureFamily ID from
  `UnitCreatureFamily`, as a FileDataID for `PlaySoundFile`: the same table
  as Pet Ability Learned's, from the wago.tools community listfile. Families
  without one, and no pet, get the raid warning (SoundKit 8959).
- On any class but hunter, `ADDON_LOADED` registers only `PLAYER_LOGOUT`; the
  addon list is account-wide, so disabling the addon there would disable it
  for the hunters too.

### Localization

One file per locale in `Locales\`: enUS, deDE, esES (also used for esMX),
frFR, koKR and ruRU, each with that locale's `strings`.

- `Locale.lua` loads after the locale files and picks the client's locale.
  `ns.L` falls back to enUS through a metatable; a key missing from enUS as
  well returns the key itself.
- Tests check that every locale only uses enUS keys, with the same format
  directives (`%s`, `%d`, `%.2f`) in the same order, and that every locale
  translates every string but the addon's name.

### Development

Needs Node.js. `npm install` once, then:

- `npm test` — runs `tests/*.test.lua` against a simulated WoW client
  (`tests/wow.lua`) in fengari, a Lua VM in JavaScript, and prints line
  coverage per file; `coverage/lcov.info` is written for editor plugins.
  `npm test check` runs only the files whose name contains `check`.
- `npm run lint` — StyLua formatting check, then WoW Lua LS diagnostics
  (taken from its VS Code extension; skipped if that is not installed).
- `npm run format` — formats all Lua with StyLua.
- `npm run check` — lint, then tests.

Both coverages are held at 100%: a full `npm test` fails below 100% line
coverage, and `npm run lint` fails below 100% WoW Lua LS type coverage.

Releases: pushing a tag runs `.github/workflows/release.yml`, which runs
`npm run check` and then BigWigsMods/packager. The packager builds the zip
(leaving out what `.pkgmeta` lists) and attaches it to a GitHub release; it
uploads to CurseForge as well once the `.toc` has an `## X-Curse-Project-ID`
and the repository a `CF_API_KEY` secret. The release notes are the
`CHANGELOG.md` in the repository, so add a section there (and set
`## Version:` in the `.toc`) before tagging.

To play with it while working on it, give the client's AddOns folder a git
worktree of its own on a local branch, so the game loads a clean checkout
instead of whatever is half done in the repository:

```bash
git branch live main
```

```bash
git worktree add "<WoW>/Interface/AddOns/PetAutocastCheck" live
```

`live` stays local. To give the game a newer version, fast-forward it to
`main`, then `/reload` in the game:

```bash
git -C "<WoW>/Interface/AddOns/PetAutocastCheck" merge --ff-only main
```

fengari is Lua 5.3 and WoW runs 5.1; the addon sticks to the shared subset and
WoW Lua LS flags WoW-incompatible API use. The simulated pet bar and spellbook
return what Forever was measured to return (see How it works); whether a
right-click in the spellbook fires `PET_BAR_UPDATE` too is what the debug
trace is for.
