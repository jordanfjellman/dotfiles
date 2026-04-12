local module = {}

function module.colors()
	return {
		foreground = "#adbac7",
		background = "#22272e",
		cursor_bg = "#adbac7",
		cursor_fg = "#22272e",
		cursor_border = "#adbac7",
		selection_fg = "#c6d0f5",
		selection_bg = "#626880",
		scrollbar_thumb = "#3d444d",
		split = "#444c56",
		ansi = {
			"#545d68",
			"#f47067",
			"#57ab5a",
			"#c69026",
			"#539bf5",
			"#b083f0",
			"#39c5cf",
			"#909dab",
		},
		brights = {
			"#636e7b",
			"#ff938a",
			"#6bc46d",
			"#daaa3f",
			"#6cb6ff",
			"#dcbdfb",
			"#56d4dd",
			"#cdd9e5",
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
