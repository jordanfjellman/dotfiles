local meh = {"shift", "alt", "ctrl"}
local hyper = {"shift", "alt", "ctrl", "cmd"}

-- Pre-downloaded via external script
hs.loadSpoon("SpoonInstall")

-- Pre-downloaded via external script
hs.spoons.use("WindowManager", {
  hotkeys = {
    Right = "right",
    Left = "left",
    Up = "fullscreen",
    Down = "center",
  }
})

spoon.SpoonInstall:andUse("AppLauncher", {
  config = {
    modifiers = meh
  },
  hotkeys = {
    b = "Brave Browser",
    c = "Visual Studio Code",
    g = "Github Desktop", -- git
    i = "IntelliJ IDEA",
    k = "kitty",
    m = "Microsoft Outlook", -- mail
    n = "Obsidian", -- notes
    p = "Postman",
    r = "Reader",
    s = "Slack",
    t = "Microsoft Teams",
    y = "YouTube Music",
    z = "zoom.us"
  }
})

hs.hotkey.bind(hyper, "g", function ()
  hs.execute("open https://github.com/notifications")
end)

hs.hotkey.bind(hyper, "j", function ()
  hs.execute("open https://lifeway.atlassian.net/jira/software/c/projects/DCD/boards/416?quickFilter=1142&quickFilter=1141")
end)

hs.hotkey.bind(hyper, "m", function ()
  hs.execute("open https://mail.google.com")
end)

hs.hotkey.bind(hyper, "n", function ()
  hs.execute("open https://keep.google.com")
end)

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  hotkeys = { reloadConfiguration = { hyper, "R" } },
  start = true
})


