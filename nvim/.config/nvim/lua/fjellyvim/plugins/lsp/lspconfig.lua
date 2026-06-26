return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function() require("mason").setup() end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "ansiblels",
        "bashls",
        "biome",
        "cmake",
        "cssls",
        "diagnosticls",
        "dockerls",
        "eslint",
        "gopls",
        "graphql",
        "html",
        "marksman",
        "jsonls",
        "lua_ls",
        "rust_analyzer",
        "taplo",
        "ts_ls",
        "yamlls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Formatting is delegated to conform.nvim (see plugins/formatting.lua), so
      -- disable these servers' builtin formatter to avoid double-formatting.
      local disable_lsp_format = {
        ansiblels = true,
        gopls = true,
        graphql = true,
        jsonls = true,
        marksman = true,
      }
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("fjellyvim-lsp-format", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and disable_lsp_format[client.name] then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end,
      })

      -- LSP keymaps covered by Neovim 0.12 defaults:
      --   K       -> hover
      --   grn     -> rename          (was <leader>rn)
      --   gra     -> code_action     (was <leader>ca)
      --   grr     -> references      (was gr)
      --   gri     -> implementation  (was gi)
      --   grt     -> type_definition (was <leader>D)
      --   grx     -> codelens.run    (was <leader>cl)
      --   gO      -> document_symbol (was gds)
      --   <C-s>   -> signature_help  (insert mode, was <C-h>)
      --
      -- LSP keymaps covered by Snacks pickers (snacks.lua):
      --   gd      -> lsp_definitions
      --   gD      -> lsp_declarations
      --   gr      -> lsp_references
      --   gI      -> lsp_implementations
      --   gy      -> lsp_type_definitions
      --   <leader>ss  -> lsp_symbols
      --   <leader>sS  -> lsp_workspace_symbols

      -- mason-lspconfig auto-enables every mason-installed server. sourcekit
      -- ships with the Swift toolchain (not a mason package), so enable it here.
      vim.lsp.enable("sourcekit")
    end,
    keys = {
      {
        "<leader>o",
        function() vim.lsp.buf.format({ async = true }) end,
        desc = "F[o]rmat buffer",
      },
      {
        "<leader>th",
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
        desc = "[T]oggle Inlay [H]ints",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "prettierd", -- prettier formatter (daemon mode)
        "stylua", -- lua formatter
        "pylint", -- python linter
        "gofumpt", -- more strict than gofmt
        "goimports-reviser", -- organizes imports
        "golines", -- cleans up long lines

        -- scalafmt cannot be ensured to be installed, install via Coursier
        -- https://github.com/mason-org/mason-registry/pull/2019
        -- "scalafmt", -- scala formatter
      },
    },
  },
}
