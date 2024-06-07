return {
	"petertriho/nvim-scrollbar",
	event = { "VeryLazy" },
	dependencies = {
		"kevinhwang91/nvim-hlslens", -- required to display search highlights
	},
	config = function()
		require("scrollbar").setup({
			marks = {
				Search = {
					color = "orange",
				},
			},
		})
		require("scrollbar.handlers.search").setup()
		require("scrollbar.handlers.gitsigns").setup()
	end,
}
