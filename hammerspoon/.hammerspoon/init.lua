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
		c = "Claude",
		e = "Visual Studio Code", -- code [e]ditor
		f = "Firefox Developer Edition",
		g = "Google Chrome Canary",
		i = "IntelliJ IDEA",
		m = "Microsoft Outlook", -- [m]ail
		o = "Obsidian",
		s = "Slack",
		t = "Ghostty", -- [t]erminal
		v = "zoom.us", -- [v]ideo calls
		x = "Xcode", -- [x]code
	},
})

function openURLReuseDomain(theURL)
	local browser = "Brave Browser"

	-- Parse domain from URL
	local domain = theURL:match("^https?://([^/]+)")
	if not domain then
		hs.alert.show("Invalid URL: " .. theURL, 4)
		return
	end

	local jxa = string.format(
		[[
		var app = Application("%s");
		app.activate();

		var dominated = "%s";
		var theURL = "%s";
		var found = false;

		var wins = app.windows();
		for (var i = 0; i < wins.length; i++) {
			var tabs = wins[i].tabs();
			for (var j = 0; j < tabs.length; j++) {
				var tabURL = tabs[j].url();
				if (tabURL && tabURL.indexOf(dominated) !== -1) {
					wins[i].activeTabIndex = j + 1;
					wins[i].index = 1;
					found = true;
					break;
				}
			}
			if (found) break;
		}

		if (!found) {
			if (wins.length === 0) app.Window().make();
			var w = app.windows[0];
			var t = app.Tab({url: theURL});
			w.tabs.push(t);
		}
	]],
		browser,
		domain,
		theURL
	)

	local ok, result, raw = hs.osascript.javascript(jxa)

	if not ok then
		hs.alert.show("JXA ERROR: " .. tostring(result), 8)
	end
end

for _, pair in ipairs({
	{ "c", "https://claude.ai" },
	{ "d", "https://discord.com/channels/@me" },
	{ "e", "https://esv.org" },
	{ "g", "https://github.com/notifications" },
	{ "m", "https://mail.google.com" },
	{ "r", "https://read.readwise.io" },
	{ "s", "https://web.telegram.org/a/" }, -- "s" is similar to "slack" (local messaging app)
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
