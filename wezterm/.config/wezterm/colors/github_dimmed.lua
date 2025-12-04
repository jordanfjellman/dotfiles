local module = {}

function module.colors()
	return {
		foreground = "#adbac7",
		background = "#22272e",
		cursor_bg = "#539bf5",
		cursor_fg = "#1c2028",
		cursor_border = "#539bf5",
		selection_fg = "#c6d0f5",
		selection_bg = "#626880",
		scrollbar_thumb = "#3d444d",
		split = "#444c56",
		ansi = {
			"#565e6a",
			"#e38970",
			"#6ab56c",
			"#be9244",
			"#6599ee",
			"#a973e7",
			"#66c0da",
			"#93a0ab",
		},
		brights = {
			"#656d7a",
			"#f0877f",
			"#82c381",
			"#d3ad54",
			"#7fb3f9",
			"#d6bef7",
			"#7acfdb",
			"#d0d9e4",
		},
		tab_bar = {
			background = "#1c2128",
			active_tab = { bg_color = "#22272e", fg_color = "#adbac7" },
			inactive_tab = { bg_color = "#1c2128", fg_color = "#768390" },
			inactive_tab_hover = { bg_color = "#2d333b", fg_color = "#adbac7" },
			new_tab = { bg_color = "#1c2128", fg_color = "#768390" },
			new_tab_hover = { bg_color = "#2d333b", fg_color = "#adbac7" },
		},
	}
end

return module
