activate application "SystemUIServer"

tell application "System Events"
  tell process "SystemUIServer"
    set btMenue to (menu bar item 1 of menu bar 1 whose description contains
"bluetooth")
    tell btMenue
      click
      tell (menu item "Blaed’s AirPods" of menu 1)
        click
        if exists menu item "Connect" of menu 1 then
          click menu item "Connect" of menu 1
          return "connecting..."
        else
          click btMenue
          return "Connect menu was not found, are you already connected?"
        end if
      end tell
    end tell
  end tell
end tell
