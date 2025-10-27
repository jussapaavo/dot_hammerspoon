-- Custom hotkey for Finder to open files in VSCode
print("Set hotkey for opening files in VS Code")

local script_to_open_path = [[set output to ""
tell application "Finder" to set the_selection to selection
set item_count to count the_selection
repeat with item_index from 1 to count the_selection
  if item_index is less than item_count then set the_delimiter to "\n"
  if item_index is item_count then set the_delimiter to ""
  set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
end repeat
tell application id "com.microsoft.VSCode"
    open output
    activate
end tell]]

function if_finder_then_open_file_in_vscode()
    local app = hs.application.get("com.apple.finder")

    if app:isFrontmost() then
        hs.osascript.applescript(script_to_open_path)
    end
end
hs.hotkey.bind({"cmd", "alt"}, "down", if_finder_then_open_file_in_vscode)
