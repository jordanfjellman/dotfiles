return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("harpoon"):setup({}) end,
    keys = {
      {
        "<leader>a",
        function() require("harpoon"):list():add() end,
        desc = "[A]dd File to Harpoon",
      },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Toggle Harpoon Menu",
      },
      { "<C-f>", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<C-g>", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<leader>f", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<leader>g", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      local smart_splits = require("smart-splits")
      -- Navigation (Ctrl+hjkl)
      vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move to left pane" })
      vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move to below pane" })
      vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move to above pane" })
      vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move to right pane" })
      -- Resizing (Meta+hjkl)
      vim.keymap.set("n", "<M-h>", smart_splits.resize_left, { desc = "Resize pane left" })
      vim.keymap.set("n", "<M-j>", smart_splits.resize_down, { desc = "Resize pane down" })
      vim.keymap.set("n", "<M-k>", smart_splits.resize_up, { desc = "Resize pane up" })
      vim.keymap.set("n", "<M-l>", smart_splits.resize_right, { desc = "Resize pane right" })
    end,
  },
}
