local wezterm = require("wezterm")
---@types wezterm.Config
local config = wezterm.config_builder()
local act = wezterm.action
local workspacer = require("utils.workspacer")

local keys = {}

config.default_prog = { "/opt/homebrew/bin/fish" }

-- smart-splits.nvim integration: seamless Neovim/WezTerm pane navigation
local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				win:perform_action(
					{ SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" } },
					pane
				)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

-- Pane navigation (Ctrl+hjkl) with Neovim awareness
table.insert(keys, split_nav("move", "h"))
table.insert(keys, split_nav("move", "j"))
table.insert(keys, split_nav("move", "k"))
table.insert(keys, split_nav("move", "l"))

-- Pane resizing (Meta+hjkl) with Neovim awareness
table.insert(keys, split_nav("resize", "h"))
table.insert(keys, split_nav("resize", "j"))
table.insert(keys, split_nav("resize", "k"))
table.insert(keys, split_nav("resize", "l"))

-- Pane splitting (matches tmux: Leader+s vertical, Leader+v horizontal)
table.insert(keys, { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) })
table.insert(keys, { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) })

-- Pane zoom toggle (Leader+z)
table.insert(keys, { key = "z", mods = "LEADER", action = act.TogglePaneZoomState })

-- Close pane (Leader+x)
table.insert(keys, { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) })

-- Enter copy/vim mode (Leader+[, matches tmux)
table.insert(keys, { key = "[", mods = "LEADER", action = act.ActivateCopyMode })

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
-- local last_workspace = ""
-- wezterm.on("update-right-status", function(window, pane)
-- 	local ws = window:active_workspace()
-- 	if ws ~= last_workspace then
-- 		last_workspace = ws
-- 		window:set_right_status(ws)
-- 	end
-- end)
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
			cmd = "$HOME/.local/share/mise/shims/fd -t d --max-depth 3 . $HOME/notes",
		})
	end),
})

table.insert(keys, {
	key = "u",
	mods = "LEADER",
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
