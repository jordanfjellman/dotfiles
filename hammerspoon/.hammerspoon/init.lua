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

for _, pair in ipairs({
  { "c", "https://chat.openai.com" },
  { "d", "https://discord.com/channels/@me" },
  { "g", "https://github.com/notifications" },
  { "j", "https://lifeway.atlassian.net/jira/software/c/projects/DCD/boards/489" },
  { "m", "https://mail.google.com" },
  { "n", "https://keep.google.com" },
}) do
  local hotkey, link = table.unpack(pair)
  hs.hotkey.bind(meh, hotkey, function()
    hs.execute("open " .. link)
  end)
end

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  hotkeys = { reloadConfiguration = { meh, "R" } },
  start = true,
})
