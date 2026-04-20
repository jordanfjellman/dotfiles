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
    keys = {
      -- Navigation (Ctrl+hjkl)
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right pane" },
      -- Resizing (Meta+hjkl)
      { "<M-h>", function() require("smart-splits").resize_left() end, desc = "Resize pane left" },
      { "<M-j>", function() require("smart-splits").resize_down() end, desc = "Resize pane down" },
      { "<M-k>", function() require("smart-splits").resize_up() end, desc = "Resize pane up" },
      { "<M-l>", function() require("smart-splits").resize_right() end, desc = "Resize pane right" },
    },
  },
}
