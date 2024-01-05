return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = {
      -- use a dynamic width for the popup menu
      width = vim.api.nvim_win_get_width(0) - 4,
    },
  },
  config = function()
    local ui = require("harpoon.ui")
    vim.keymap.set("n", "<leader>a", function()
      require("harpoon.mark").add_file()
    end)
    vim.keymap.set("n", "<C-E>", function()
      ui.toggle_quick_menu()
    end)
    vim.keymap.set("n", "<C-G>", function()
      ui.nav_file(1)
    end)
    vim.keymap.set("n", "<C-H>", function()
      ui.nav_file(2)
    end)
    vim.keymap.set("n", "<C-T>", function()
      ui.nav_file(3)
    end)
    vim.keymap.set("n", "<C-Y>", function()
      ui.nav_file(4)
    end)
  end,
}
