local wezterm = require("wezterm")
---@types wezterm.Config
local config = wezterm.config_builder()
local act = wezterm.action
local workspacer = require("utils.workspacer")

local keys = {}

config.default_prog = { "/opt/homebrew/bin/fish" }

config.font_size = 18
config.font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Regular" })
config.line_height = 1.2
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

table.insert(keys, {
	key = "n",
	mods = "LEADER",
	action = act.SwitchWorkspaceRelative(1),
})
table.insert(keys, {
	key = "p",
	mods = "LEADER",
	action = act.SwitchWorkspaceRelative(-1),
})

-- config.color_scheme = "GitHub Dark"
config.colors = require("colors.github_dimmed").colors()

config.window_padding = {
	left = 1,
	right = 1,
	top = 1,
	bottom = 1,
}

config.window_decorations = "MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR|TITLE|RESIZE"

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- print the workspace name at the upper right
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)
-- table.insert(keys, { key = "t", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) })
table.insert(keys, { key = "[", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(1) })
table.insert(keys, { key = "]", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(-1) })

table.insert(keys, {
	key = "t",
	mods = "LEADER",
	action = wezterm.action_callback(function(window, pane)
		workspacer.open(window, pane, {
			title = "Choose repo",
			cmd = "$HOME/.local/share/mise/shims/fd -H -t d -d 3 '^(.git|worktrees)$' $HOME/code --exec dirname",
		})
	end),
})

table.insert(keys, {
	key = "t",
	mods = "LEADER|SHIFT",
	action = wezterm.action_callback(function(window, pane)
		workspacer.open(window, pane, {
			title = "Choose note",
			cmd = "$HOME/.local/share/mise/shims/fd -t d --max-depth 3 . $HOME/code/personal/notes",
		})
	end),
})

table.insert(keys, {
	key = "U",
	mods = "CTRL|SHIFT",
	action = wezterm.action.QuickSelectArgs({
		label = "open url",
		patterns = {
			"https?://\\S+",
		},
		action = wezterm.action_callback(function(window, pane)
			local url = window:get_selection_text_for_pane(pane)
			wezterm.open_with(url)
		end),
	}),
})

table.insert(keys, {
	key = "d",
	mods = "CTRL|SHIFT",
	action = wezterm.action.ShowDebugOverlay,
})

config.keys = keys

return config
