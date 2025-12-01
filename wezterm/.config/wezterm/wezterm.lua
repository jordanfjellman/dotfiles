local wezterm = require("wezterm")
---@types wezterm.Config
local config = wezterm.config_builder()
local act = wezterm.action

local keys = {}

config.default_prog = { "/opt/homebrew/bin/fish", "--login" }

config.font_size = 19
config.font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Medium" })

-- config.color_scheme = "GitHub Dark"
config.colors = require("colors.github_dimmed").colors()

config.window_decorations = "RESIZE"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

-- print the workspace name at the upper right
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)
table.insert(keys, { key = "t", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) })
table.insert(keys, { key = "[", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(1) })
table.insert(keys, { key = "]", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(-1) })

table.insert(keys, {
	key = "d",
	mods = "CTRL|SHIFT",
	action = wezterm.action_callback(function(window, pane)
		local code_dir = os.getenv("HOME") .. "/code"
		wezterm.log_info("code_dir:", code_dir)
		local success, stdout, stderr = wezterm.run_child_process({
			"sh",
			"-c",
			"/opt/homebrew/bin/fd -H -t d -d 3 '^(.git|worktrees)$' $HOME/code --exec dirname",
		})
		if success then
			wezterm.log_info("stdout:", stdout)
			-- Convert stdout to table of lines
			local lines = {}
			for line in stdout:gmatch("([^\n]*)\n?") do
				if line ~= "" then
					table.insert(lines, line)
				end
			end
			wezterm.log_info("lines", lines)

			local choices = {}
			for _, repo in ipairs(lines) do
				table.insert(choices, { label = repo })
			end

			window:perform_action(
				act.InputSelector({
					title = "Choose repo",
					fuzzy = true,
					choices = choices,
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not label then
							return
						end

						window:perform_action(
							act.SwitchToWorkspace({
								name = label,
								spawn = {
									label = "Workspace: " .. label,
									cwd = wezterm.cwd,
								},
							}),
							pane
						)
					end),
				}),
				pane
			)
		end
	end),
})
config.keys = {
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

config.keys = keys

return config
