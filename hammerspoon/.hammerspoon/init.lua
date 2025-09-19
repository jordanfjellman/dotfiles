local meh = { "shift", "alt", "ctrl" }
local hyper = { "shift", "alt", "ctrl", "cmd" }

-- Pre-downloaded via external script
hs.loadSpoon("SpoonInstall")

-- Pre-downloaded via external script
hs.spoons.use("WindowManager", {
  config = {
    modifiers = meh,
  },
  hotkeys = {
    Right = "right",
    Left = "left",
    Up = "fullscreen",
    Down = "center",
  },
})

spoon.SpoonInstall:andUse("AppLauncher", {
  config = {
    modifiers = hyper,
  },
  hotkeys = {
    a = "Android Studio",
    b = "Brave Browser",
    c = "Claude", -- ai [c]hat
    e = "Zed", -- code [e]ditor
    f = "Firefox Developer Edition",
    g = "Google Chrome Canary",
    i = "IntelliJ IDEA",
    k = "ghostty",
    m = "Microsoft Outlook", -- [m]ail
    n = "Obsidian", -- [n]otes
    p = "Postman",
    r = "Reader",
    s = "Slack",
    t = "Microsoft Teams",
    v = "zoom.us", -- [v]ideo calls
    x = "Xcode", -- [x]code
    y = "YouTube Music",
  },
})

hs.hotkey.bind(meh, "g", function()
  hs.execute("open https://github.com/notifications")
end)

hs.hotkey.bind(meh, "j", function()
  hs.execute("open https://lifeway.atlassian.net/jira/software/c/projects/DCD/boards/489")
end)

hs.hotkey.bind(meh, "m", function()
  hs.execute("open https://mail.google.com")
end)

hs.hotkey.bind(meh, "n", function()
  hs.execute("open https://keep.google.com")
end)

hs.hotkey.bind(meh, "c", function()
  hs.execute("open https://chat.openai.com")
end)

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  hotkeys = { reloadConfiguration = { meh, "R" } },
  start = true,
})
