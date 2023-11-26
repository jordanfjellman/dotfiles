return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>e", "<CMD>NvimTreeToggle<CR>", desc = "Toggle Nvim Tree" },
  },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      disable_netrw = true,
      git = {
        ignore = false,
      },
      view = {
        adaptive_size = true,
      },
    })
  end,
}
