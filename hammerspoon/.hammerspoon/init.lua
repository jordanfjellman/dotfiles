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
    t = "Microsoft Teams",
    s = "Slack",
    y = "YouTube Music",
    z = "zoom.us"
  }
})

hs.hotkey.bind(hyper, "g", function ()
  hs.execute("open https://github.com/notifications")
end)

hs.hotkey.bind(hyper, "m", function ()
  hs.execute("open https://mail.google.com")
end)

hs.hotkey.bind(hyper, "n", function ()
  hs.execute("open https://keep.google.com")
end)

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  hotkeys = { reloadConfiguration = { meh, "R" } },
  start = true
})


