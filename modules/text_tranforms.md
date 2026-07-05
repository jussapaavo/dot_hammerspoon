## Text transforms

System-wide case and fencing shortcuts. They work by copying the selection,
transforming the string, and pasting it back — so the same shortcut works in
**every** app (VS Code / Electron, Chromium browsers, native AppKit apps),
unlike `~/Library/KeyBindings/DefaultKeyBinding.dict`, which only the native
AppKit text system reads.

> [!IMPORTANT]
> **Accessibility permission is mandatory.** Enable it under
> System Settings → Privacy & Security → Accessibility → **Hammerspoon**.
> Without it, keystrokes are silently ignored and nothing happens.

Leader is `⌃⌥` (`{"ctrl","alt"}`).

| Action      | Shortcut | Result          |
| ----------- | -------- | --------------- |
| UPPERCASE   | ⌃⌥U      | `foo` → `FOO`   |
| lowercase   | ⌃⌥L      | `FOO` → `foo`   |
| Title Case  | ⌃⌥T      | `foo bar` → `Foo Bar` |
| Wrap `( )`  | ⌃⌥9      | `foo` → `(foo)` |
| Wrap `[ ]`  | ⌃⌥8      | `foo` → `[foo]` |
| Wrap `{ }`  | ⌃⌥0      | `foo` → `{foo}` |
| Wrap `" "`  | ⌃⌥2      | `foo` → `"foo"` |
| Wrap `' '`  | ⌃⌥'      | `foo` → `'foo'` |
| Wrap `` ` ` `` | ⌃⌥§   | `` foo `` → `` `foo` `` |

Notes and limitations:

- **Backtick key:** the `` ` `` wrap is bound to keycode `10` (the `§` key, left
  of `1`, on a Finnish ISO keyboard). If it does not fire, check
  `hs.keycodes.map` in the Hammerspoon console and adjust the keycode.
- **Casing is UTF-8-aware:** Nordic characters (å ä ö …) are cased correctly via
  an explicit map, since Lua's built-in `upper`/`lower` are ASCII-only.
- **Clipboard round-trip:** transforms briefly use and restore the system
  clipboard. A clipboard-history tool may record the transient value.
- **Timing:** the copy step polls the clipboard for up to ~0.5s. On a very slow
  app, increase the deadline in `transformSelection`.
- **Commenting is intentionally not included** — real commenting is language- and
  line-aware, so keep it in the editor (VS Code `Cmd+/`).
