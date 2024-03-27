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
    end, { desc = "Toggle Harpoon Menu" })
    vim.keymap.set("n", "<C-F>", function()
      ui.nav_file(1)
    end, { desc = "View Harpoon File at Position 1" })
    vim.keymap.set("n", "<C-J>", function()
      ui.nav_file(2)
    end, { desc = "View Harpoon File at Position 2" })
    vim.keymap.set("n", "<C-G>", function()
      ui.nav_file(3)
    end, { desc = "View Harpoon File at Position 3" })
    vim.keymap.set("n", "<C-H>", function()
      ui.nav_file(4)
    end, { desc = "View Harpoon File at Position 4" })
  end,
}
