-- System-wide text transforms.
--
-- Mechanism: copy the current selection, transform the string, paste it back.
-- Because it works on the system clipboard + OS keystrokes it is app-agnostic —
-- VS Code / Electron, Chromium browsers and native AppKit apps behave the same.
-- This replaces the ~/Library/KeyBindings/DefaultKeyBinding.dict bindings, which
-- only the native AppKit text system reads.
--
-- Requires Accessibility permission (System Settings → Privacy & Security →
-- Accessibility → Hammerspoon). Without it, hs.eventtap keystrokes are ignored.

print("Loading text transforms (case + fencing)")

local mods = { "ctrl", "alt" }

-- UTF-8-aware case maps. Lua's string.upper/lower are ASCII-only, so Nordic
-- letters (å ä ö ...) would otherwise pass through unchanged. These maps cover
-- the Latin-1 letters a Finnish/Nordic user actually types.
local upperMap = {
    ["å"] = "Å", ["ä"] = "Ä", ["ö"] = "Ö", ["æ"] = "Æ", ["ø"] = "Ø",
    ["é"] = "É", ["è"] = "È", ["ê"] = "Ê", ["ë"] = "Ë",
    ["á"] = "Á", ["à"] = "À", ["â"] = "Â", ["ã"] = "Ã",
    ["ó"] = "Ó", ["ò"] = "Ò", ["ô"] = "Ô", ["õ"] = "Õ",
    ["ú"] = "Ú", ["ù"] = "Ù", ["û"] = "Û", ["ü"] = "Ü",
    ["í"] = "Í", ["ì"] = "Ì", ["î"] = "Î", ["ï"] = "Ï",
    ["ñ"] = "Ñ", ["ç"] = "Ç", ["ß"] = "SS",
}

local lowerMap = {}
for lower, upper in pairs(upperMap) do
    if upper ~= "SS" then lowerMap[upper] = lower end
end

-- Apply an ASCII case function per UTF-8 character, falling back to the
-- accented-letter map. string.upper/lower leave multibyte bytes untouched,
-- so the map handles everything outside ASCII.
local function mapCase(str, map, asciiFn)
    return (str:gsub(utf8.charpattern, function(ch)
        return map[ch] or asciiFn(ch)
    end))
end

local function toUpper(str) return mapCase(str, upperMap, string.upper) end
local function toLower(str) return mapCase(str, lowerMap, string.lower) end

-- Title Case: lowercase everything, then capitalise the first letter of each word.
local function toTitle(str)
    local out, atWordStart = {}, true
    for _, cp in utf8.codes(str) do
        local ch = utf8.char(cp)
        if ch:match("%s") then
            atWordStart = true
            out[#out + 1] = ch
        else
            out[#out + 1] = atWordStart and toUpper(ch) or toLower(ch)
            atWordStart = false
        end
    end
    return table.concat(out)
end

-- Copy the selection, run `transform` on it, and paste the result.
-- The system clipboard is saved and restored so the round-trip is invisible.
local function transformSelection(transform)
    local savedContents = hs.pasteboard.getContents()
    local savedChangeCount = hs.pasteboard.changeCount()

    hs.eventtap.keyStroke({ "cmd" }, "c")

    -- Poll changeCount (~0.5s max) so we react as soon as the copy lands.
    -- Tune the deadline if copy fails to register on a very slow app.
    local selection
    local deadline = hs.timer.secondsSinceEpoch() + 0.5
    while hs.timer.secondsSinceEpoch() < deadline do
        if hs.pasteboard.changeCount() ~= savedChangeCount then
            selection = hs.pasteboard.getContents()
            break
        end
        hs.timer.usleep(10000) -- 10ms
    end

    if not selection or selection == "" then
        -- Nothing was selected: leave the clipboard as we found it.
        if savedContents then hs.pasteboard.setContents(savedContents) end
        return
    end

    hs.pasteboard.setContents(transform(selection))
    hs.eventtap.keyStroke({ "cmd" }, "v")

    -- Restore the clipboard once the paste has had time to read it.
    hs.timer.doAfter(0.2, function()
        if savedContents then
            hs.pasteboard.setContents(savedContents)
        else
            hs.pasteboard.clearContents()
        end
    end)
end

-- Case
hs.hotkey.bind(mods, "u", function() transformSelection(toUpper) end)
hs.hotkey.bind(mods, "l", function() transformSelection(toLower) end)
hs.hotkey.bind(mods, "t", function() transformSelection(toTitle) end)

-- Fencing. Delimiters are literal strings so this is layout-independent:
-- it does not matter which character the physical key produces.
local function wrap(open, close)
    return function()
        transformSelection(function(s) return open .. s .. close end)
    end
end

hs.hotkey.bind(mods, "8", wrap("(", ")"))
hs.hotkey.bind(mods, "9", wrap("[", "]"))
hs.hotkey.bind(mods, "0", wrap("{", "}"))
hs.hotkey.bind(mods, "2", wrap('"', '"'))
hs.hotkey.bind(mods, "'", wrap("'", "'"))

-- Backtick wrap lives on the ´ key on a Finnish ISO keyboard.
-- That physical key sits at the US "=" position, keycode 24.
hs.hotkey.bind(mods, 24, wrap("`", "`"))

-- Triple-backtick wrap lives on the ¨ key on a Finnish ISO keyboard.
-- That physical key sits at the US "]" position, keycode 30.
hs.hotkey.bind(mods, 30, wrap("```\n", "\n```"))
