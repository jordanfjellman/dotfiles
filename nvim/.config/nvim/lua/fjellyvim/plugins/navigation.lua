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
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}
