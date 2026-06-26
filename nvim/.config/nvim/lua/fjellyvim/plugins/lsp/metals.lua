return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "saghen/blink.cmp",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap",
        config = function()
          local dap = require("dap")

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
        end,
      },
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()

      local java_home = vim.trim(vim.fn.system({ "mise", "where", "java@corretto-17" }))
      if vim.v.shell_error ~= 0 or java_home == "" then
        java_home = vim.fn.expand("~/.local/share/mise/installs/java/corretto-17")
      end
      metals_config.cmd_env = { JAVA_HOME = java_home }

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        -- Surface Scalafix lint rules as diagnostics in the editor. Combined
        -- with the compiler's -Wunused flag (set in the build), this gives
        -- snappy unused-variable / unused-import warnings via the normal
        -- compile cycle (no extra process per keystroke). Metals auto-discovers
        -- .scalafix.conf at the workspace root, so no path is hardcoded here.
        scalafixLintEnabled = true,
      }

      -- Merge blink's completion capabilities INTO Neovim's defaults rather than
      -- replacing them (get_lsp_capabilities' second arg includes nvim defaults).
      -- Neovim's defaults advertise
      -- publishDiagnostics.tagSupport.valueSet = { 1 (Deprecated), 2 (Unnecessary) },
      -- which is what tells Metals it can tag unused code as Unnecessary so it
      -- renders grayed-out via the DiagnosticUnnecessary highlight. Dropping the
      -- nvim defaults (as a bare capabilities table would) loses that, so unused
      -- vars never gray out.
      metals_config.capabilities = require("blink.cmp").get_lsp_capabilities(nil, true)

      -- Setup fidget progress handler for LSP updates
      metals_config.init_options.statusBarProvider = "on"

      -- Finish setup after attaching to the LSP server
      metals_config.on_attach = function(_, bufnr)
        local metals = require("metals")
        metals.setup_dap()

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- LSP mappings
        map("n", "<leader>ws", function() metals.hover_worksheet() end, "Hover worksheet")
        map("v", "K", function() metals.type_of_range() end, "Show type on hover")

        -- Scalafix / imports (on-demand; these never run on the hot path)
        map("n", "<leader>oi", function() metals.organize_imports() end, "[O]rganize [I]mports")
        map("n", "<leader>sf", function() metals.run_scalafix() end, "[S]calafix: run all rules")
        map("n", "<leader>sF", function()
          vim.ui.input({ prompt = "Scalafix rule (e.g. RemoveUnused, DisableSyntax): " }, function(rule)
            if rule and rule ~= "" then
              metals.run_single_scalafix({ rule })
            end
          end)
        end, "[S]calafix: run a single rule")

        -- Organize imports on save is OFF by default: it mutates the buffer on
        -- every :w and would strip the very unused imports you want to SEE
        -- grayed out. Use <leader>oi to organize on demand. Opt in to on-save
        -- per-session (or in your config) with :let g:scala_organize_on_save = 1
        if vim.g.scala_organize_on_save == nil then
          vim.g.scala_organize_on_save = false
        end
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          group = vim.api.nvim_create_augroup("metals-organize-imports-" .. bufnr, { clear = true }),
          callback = function()
            if vim.g.scala_organize_on_save then
              metals.organize_imports()
            end
          end,
        })
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function() require("metals").initialize_or_attach(metals_config) end,
        group = nvim_metals_group,
      })
    end,
  },
}
