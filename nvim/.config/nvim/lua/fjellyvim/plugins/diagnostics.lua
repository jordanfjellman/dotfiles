return {
  {
    "mfussenegger/nvim-dap",
    keys = {},
    config = function()
      local dap = require("dap")
      vim.keymap.set("n", "<Leader>dr", function()
        dap.repl.toggle()
      end)
      vim.keymap.set("n", "<Leader>dl", function()
        dap.run_last()
      end)
      vim.keymap.set("n", "<leader>dt", function()
        dap.toggle_breakpoint()
      end)
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end)
      vim.keymap.set("n", "<leader>do", function()
        dap.step_over()
      end)
      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end)
      vim.keymap.set("n", "<leader>dx", function()
        dap.terminate()
      end)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    events = { "VeryLazy" },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      {
        "<leader>od",
        function()
          require("trouble").toggle("document_diagnostics")
        end,
        { desc = "[O]pen [D]ocument Diagnostics" },
      },

      {
        "<leader>ow",
        function()
          require("trouble").toggle("workspace_diagnostics")
        end,
        { desc = "[O]pen [W]orkspace Diagnostics" },
      },
      {
        "gR",
        function()
          require("trouble").toggle("lsp_references")
        end,
      },
    },
  },
}
