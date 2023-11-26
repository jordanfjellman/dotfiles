return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = {
    -- use a dynamic width for the popup menu
      width = vim.api.nvim_win_get_width(0) - 4,
    }
  },
  config = function ()
    local ui = require("harpoon.ui")
    vim.keymap.set("n", "<leader>ma", function() require("harpoon.mark").add_file() end)
    vim.keymap.set("n", "<leader>mv", function() ui.toggle_quick_menu() end)
    vim.keymap.set("n", "<leader>m1", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<leader>m2", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<leader>m3", function() ui.nav_file(3) end)
    vim.keymap.set("n", "<leader>m4", function() ui.nav_file(4) end)
    vim.keymap.set("n", "<leader>mn", function() ui.nav_next() end)
    vim.keymap.set("n", "<leader>mp", function() ui.nav_next() end)
  end
}

