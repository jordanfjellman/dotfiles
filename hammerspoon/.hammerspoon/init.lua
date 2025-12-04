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
		c = "Claude", -- ai [c]hat
		e = "Zed", -- code [e]ditor
		f = "Firefox Developer Edition",
		g = "Google Chrome Canary",
		i = "IntelliJ IDEA",
		m = "Microsoft Outlook", -- [m]ail
		o = "Obsidian",
		r = "Reader",
		s = "Slack",
		t = "wezterm", -- [t]erminal
		v = "zoom.us", -- [v]ideo calls
		x = "Xcode", -- [x]code
		y = "YouTube Music",
	},
})

for _, pair in ipairs({
	{ "c", "https://grok.com" },
	{ "d", "https://discord.com/channels/@me" },
	{ "g", "https://github.com/notifications" },
	{ "m", "https://mail.google.com" },
	{ "w", "https://lifeway.atlassian.net/jira/software/c/projects/DCD/boards/489" }, -- [w]orkboard
	{ "x", "https://x.com" },
	{ "z", "https://lifeway.zoom.us/j/91553605678?pwd=6wNOo8UETFaLahW83mnZSKdVDnw8BF.1" },
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
