local wezterm = require("wezterm")
---@types wezterm.Config
local config = wezterm.config_builder()

config.font_size = 19
config.font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Medium" })

-- config.color_scheme = "GitHub Dark"
config.colors = require("colors.github_dimmed").colors()

config.window_decorations = "RESIZE"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

return config
