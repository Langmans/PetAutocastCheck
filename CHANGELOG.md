# Changelog

## 1.0.0 - not released yet

- A toast in the middle of the screen when your hunter pet's Growl or Cower
  autocast does not fit the mode: solo Growl on and Cower off, in a dungeon or
  raid group Growl off and Cower on. The addon picks between those two by
  itself, and the toast goes away once you fix it. Growl and Cower are seen
  on the pet bar and in the pet's spellbook.
- Kite mode (Growl off, Cower on) and tank mode (Growl on, Cower off, for a
  group without a tank): toggle with `/pac kite` and `/pac tank`, set with
  `on|off` (quiet when nothing changes, so it fits a Distracting Shot macro),
  with a key binding each or in the panel.
- Three macros made once per character the first time you log in: PACKite
  (Distracting Shot with kite mode on), PACKiteOff and PACTank. `/pac macros`
  makes missing ones again.
- Whatever is still wrong toasts again when combat starts
  (`/pac remind on|off`).
- The toast plays your pet's call, the sound it makes when you send it to
  attack (`/pac sound family|warning|off`).
- Options panel under Esc > Options > AddOns with all settings; `/pac` lists
  the commands.
- English, German, French, Spanish, Korean and Russian.
