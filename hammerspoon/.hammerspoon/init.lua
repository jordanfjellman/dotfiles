local meh = { "shift", "alt", "ctrl" }
local hyper = { "shift", "alt", "ctrl", "cmd" }

-- Pre-downloaded via external script
hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("AppLauncher", {
  config = {
    modifiers = hyper,
  },
  hotkeys = {
    a = "Android Studio",
    b = "Brave Browser",
    e = "Visual Studio Code", -- code [e]ditor
    f = "Firefox Developer Edition",
    g = "Google Chrome Canary",
    i = "IntelliJ IDEA",
    m = "Microsoft Outlook", -- [m]ail
    o = "Obsidian",
    s = "Slack",
    t = "ghostty", -- [t]erminal
    v = "zoom.us", -- [v]ideo calls
    x = "Xcode", -- [x]code
  },
})

function openURLReuseDomain(theURL)
  local asa = [[
      on run argv
          set theURL to "%URL%"

          -- Parse domain (simple: after // and before next / or end)
          try
              set AppleScript's text item delimiters to "//"
              set parts to text items of theURL
              set hostPart to item 2 of parts
              set AppleScript's text item delimiters to "/"
              set domain to text item 1 of hostPart
          on error
              set domain to ""
          end try

          if domain is "" then
              display dialog "Invalid URL"
              return
          end if

          tell application "%BROWSER%"
              activate

              set found to false

              repeat with w in every window
                  set tabIndex to 0
                  repeat with t in every tab of w
                      set tabIndex to tabIndex + 1
                      try
                          set tabURL to URL of t
                          if tabURL contains domain then
                              set active tab index of w to tabIndex
                              set index of w to 1 -- bring window to front
                              -- tell t to reload -- optional: reload with new page
                              -- set URL of t to theURL -- navigate to exact URL
                              set found to true
                              exit repeat
                          end if
                      end try
                  end repeat
                  if found then exit repeat
              end repeat

              if not found then
                  -- No matching domain tab: open in new tab in front window
                  if (count of windows) = 0 then make new window
                  tell front window
                      make new tab with properties {URL:theURL}
                  end tell
              end if
          end tell
      end run
    ]]

  asa = asa:gsub("%%BROWSER%%", "Brave Browser")
  asa = asa:gsub("%%URL%%", theURL)

  local ok, result = hs.osascript.applescript(asa, theURL)

  if ok then
    hs.alert.show("Success: " .. result, 4)
  else
    hs.alert.show("AppleScript ERROR: " .. tostring(result), 8)
  end
end

for _, pair in ipairs({
  { "c", "https://claude.ai" },
  { "d", "https://discord.com/channels/@me" },
  { "g", "https://github.com/notifications" },
  { "m", "https://mail.google.com" },
  { "r", "https://read.readwise.io" },
  { "s", "https://web.telegram.org/a/" },               -- "s" is similar to "slack" (local messaging app)
  { "t", "https://teams.cloud.microsoft/" },
  { "w", "https://lifeway.atlassian.net/jira/for-you" }, -- [w]orkboard
  { "x", "https://x.com" },
  { "y", "https://music.youtube.com" },
  { "z", "https://lifeway.zoom.us/j/91553605678?pwd=6wNOo8UETFaLahW83mnZSKdVDnw8BF.1" }, -- zoom room
}) do
  local hotkey, link = table.unpack(pair)
  hs.hotkey.bind(meh, hotkey, function()
    openURLReuseDomain(link)
  end)
end

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  hotkeys = { reloadConfiguration = { meh, "H" } },
  start = true,
})
