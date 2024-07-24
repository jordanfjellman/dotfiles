return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        events = { "VeryLazy" },
        config = function()
          local dap, dapui = require("dap"), require("dapui")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }

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
        end,
      },
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup fidget progress handler for LSP updates
      metals_config.init_options.statusBarProvider = "on"

      local function metals_status_handler(_, status, ctx)
        -- https://github.com/scalameta/nvim-metals/blob/main/lua/metals/status.lua#L36-L50
        local val = {}
        if status.hide then
          val = { kind = "end" }
        elseif status.show then
          val = { kind = "begin", message = status.text }
        elseif status.text then
          val = { kind = "report", message = status.text }
        else
          return
        end
        local info = { client_id = ctx.client_id }
        local msg = { token = "metals", value = val }
        -- call fidget progress handler
        vim.lsp.handlers["$/progress"](nil, msg, info)
      end

      local handlers = {}
      handlers["metals/status"] = metals_status_handler
      metals_config.handlers = handlers

      -- Finish setup after attaching to the LSP server
      metals_config.on_attach = function(_, bufnr)
        local metals = require("metals")
        metals.setup_dap()
        -- setup dapui after dap via metals to avoid issues
        require("dapui").setup()

        -- LSP mappings
        vim.keymap.set("n", "<leader>ws", function()
          metals.hover_worksheet()
        end)
        vim.keymap.set("v", "K", function()
          metals.type_of_range()
        end, { desc = "Show type on hover" })

        -- Autocommands
        local metals_lsp_group = vim.api.nvim_create_augroup("fjellyvim-metals-lsp", { clear = true })
        vim.api.nvim_create_autocmd("CursorMoved", {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
          group = metals_lsp_group,
          desc = "[METALS] Clear references on cursor moved",
        })
        -- disable after upgrade to neovim 0.10
        -- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        --   buffer = bufnr,
        --   callback = vim.lsp.codelens.refresh,
        --   group = metals_lsp_group,
        --   desc = "[METALS] Refresh code lens on bufenter, cursorhold, insertleave",
        -- })
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
