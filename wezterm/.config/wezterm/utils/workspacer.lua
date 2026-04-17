local wezterm = require("wezterm")
local module = {}

module.workspacer = function(window, pane, code_dir)
	local code_dir = os.getenv("HOME") .. "/code"
	wezterm.log_debug("code_dir:", code_dir)
	local success, stdout, stderr = wezterm.run_child_process({
		"sh",
		"-c",
		"/Users/jordan/.local/share/mise/shims/fd -H -t d -d 3 '^(.git|worktrees)$' $HOME/code --exec dirname",
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
					local name = label:match("([^/]+)$")

					window:perform_action(
						act.SwitchToWorkspace({
							name = name,
							spawn = {
								label = name,
								cwd = label,
							},
						}),
						pane
					)
				end),
			}),
			pane
		)
	else
		wezterm.log_error("error:", stderr)
	end
end

return module
