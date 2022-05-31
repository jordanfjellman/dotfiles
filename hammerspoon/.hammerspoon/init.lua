local meh = {"shift", "alt", "ctrl"}

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
    g = "Github Desktop",
    i = "IntelliJ IDEA",
    k = "kitty",
    o = "Microsoft Outlook",
    p = "Postman",
    t = "Microsoft Teams",
    s = "Slack",
    y = "YouTube Music",
    z = "zoom.us"
  }
})

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  hotkeys = { reloadConfiguration = { meh, "R" } },
  start = true
})

