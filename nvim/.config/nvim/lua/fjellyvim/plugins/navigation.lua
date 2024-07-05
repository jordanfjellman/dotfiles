return {
  {
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
      end, { desc = "[A]dd File to Harpoon", silent = true })
      vim.keymap.set("n", "<C-E>", function()
        ui.toggle_quick_menu()
      end, { desc = "Toggle Harpoon Menu", silent = true })
      vim.keymap.set("n", "<C-f>", function()
        ui.nav_file(1)
      end, { desc = "View Harpoon File at Position 1", silent = true })
      vim.keymap.set("n", "<C-g>", function()
        ui.nav_file(2)
      end, { desc = "View Harpoon File at Position 2", silent = true })
      vim.keymap.set("n", "<leader>f", function()
        ui.nav_file(3)
      end, { desc = "View Harpoon File at Position 3", silent = true })
      vim.keymap.set("n", "<leader>g", function()
        ui.nav_file(4)
      end, { desc = "View Harpoon File at Position 4", silent = true })
    end,
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
