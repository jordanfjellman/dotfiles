local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

-- opts: { title, cmd }
-- cmd: shell command that outputs one directory path per line
module.open = function(window, pane, opts)
	local success, stdout, stderr = wezterm.run_child_process({ "sh", "-c", opts.cmd })
	if not success then
		wezterm.log_error("workspacer error:", stderr)
		return
	end

	local choices = {}
	for line in stdout:gmatch("([^\n]+)") do
		table.insert(choices, { label = line })
	end

	window:perform_action(
		act.InputSelector({
			title = opts.title or "Choose workspace",
			fuzzy = true,
			choices = choices,
		action = wezterm.action_callback(function(_, _, _, label)
			if not label then
				return
			end
			local cwd = label:gsub("/$", "")
			local name = cwd:match("([^/]+)$"):gsub("[%s%p]", "_")
			window:perform_action(
				act.SwitchToWorkspace({ name = name, spawn = { label = name, cwd = cwd } }),
				pane
			)
			end),
		}),
		pane
	)
end

return module
