return {
  {
    "mfussenegger/nvim-dap",
    keys = {},
    config = function()
      local dap = require("dap")
      vim.keymap.set("n", "<leader>tr", function()
        dap.repl.toggle()
      end, { desc = "[T]oggle [R]EPL" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.run_last()
      end, { desc = "[D]ebug [L]atest" })
      vim.keymap.set("n", "<leader>dp", function()
        dap.toggle_breakpoint()
      end, { desc = "[D]ebug [P]oint" })
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, { desc = "[D]ebug [C]ontinue" })
      vim.keymap.set("n", "<leader>do", function()
        dap.step_over()
      end, { desc = "[D]ebug [O]ver" })
      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, { desc = "[D]ebug [I]nto" })
      vim.keymap.set("n", "<leader>de", function()
        dap.terminate()
      end, { desc = "[D]ebug [E]xit" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    events = { "VeryLazy" },
    keys = {
      {
        "<leader>ou",
        function()
          require("dapui").open()
        end,
        { desc = "[O]pen Debugger [U]I" },
      },
      {
        "<leader>cu",
        function()
          require("dapui").close()
        end,
        { desc = "[C]lose Debugger [U]I" },
      },
      {
        "<leader>td",
        function()
          require("dap").terminate()
          require("dap").repl.close()
        end,
        { desc = "[T]erminate [D]ebugger" },
      },
    },
  },
  -- config = function()
  -- local dap, dapui = require("dap"), require("dapui")
  -- dap.listeners.before.attach.dapui_config = function()
  --   dapui.open()
  -- end
  -- dap.listeners.before.launch.dapui_config = function()
  --   dapui.open()
  -- end
  -- dap.listeners.before.event_terminated.dapui_config = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited.dapui_config = function()
  --   dapui.close()
  -- end
  --   end,
  -- },
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
