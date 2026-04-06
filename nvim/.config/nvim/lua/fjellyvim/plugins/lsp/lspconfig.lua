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
        "bashls",
        "biome",
        "bright_script",
        "cmake",
        "cssls",
        "diagnosticls",
        "dockerls",
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
      "b0o/schemastore.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

      local disable_builtin_lsp_formatter = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

      vim.lsp.config("dockerls", {})

      vim.lsp.config("cssls", { capabilities = capabilities })

      vim.lsp.config("ansiblels", {
        capabilities = capabilities,
        on_attach = disable_builtin_lsp_formatter,
      })

      vim.lsp.config("gopls", {
        capabilities = capabilities,
        on_attach = disable_builtin_lsp_formatter,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        project_root = { "go.work", "go.mod", ".git" },
      })

      vim.lsp.config("graphql", {
        capabilities = capabilities,
        on_attach = disable_builtin_lsp_formatter,
      })

      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        on_attach = disable_builtin_lsp_formatter,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config("marksman", {
        capabilities = capabilities,
        on_attach = disable_builtin_lsp_formatter,
      })

      vim.lsp.config("bright_script", {
        capabilities = capabilities,
        on_attach = disable_builtin_lsp_formatter,
        cmd = { "bsc", "--lsp", "--stdio" },
        filetypes = { "bs", "brs" },
        root_markers = { "bsconfig.json", "makefile", "Makefile", ".git" },
      })
      -- local swift_capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- swift_capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
      vim.lsp.config("sourcekit", {
        capabilities = capabilities,
      })

      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        filetypes = { "yaml", "yml" },
        settings = {
          yaml = {
            completion = true,
            customTags = {
              "!And",
              "!If",
              "!Not",
              "!Equals",
              "!Equals sequence",
              "!Or",
              "!FindInMap sequence",
              "!Base64",
              "!Cidr",
              "!Ref",
              "!Sub",
              "!GetAtt",
              "!GetAZs",
              "!ImportValue",
              "!Select",
              "!Select sequence",
              "!Split",
              "!Join sequence",
            },
            format = {
              enable = true,
            },
            hover = true,
            validate = true,
          },
        },
      })

      -- Enable all configured LSP servers
      vim.lsp.enable({
        "dockerls",
        "cssls",
        "ansiblels",
        "gopls",
        "graphql",
        "jsonls",
        "marksman",
        "bright_script",
        "sourcekit",
        "yamlls",
        "lua_ls",
        "rust_analyzer",
      })

      -- Define and enable remaining mason-lspconfig servers
      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.enable("bashls")

      vim.lsp.config("biome", { capabilities = capabilities })
      vim.lsp.enable("biome")

      vim.lsp.config("cmake", { capabilities = capabilities })
      vim.lsp.enable("cmake")

      vim.lsp.config("diagnosticls", { capabilities = capabilities })
      vim.lsp.enable("diagnosticls")

      vim.lsp.config("eslint", { capabilities = capabilities })
      vim.lsp.enable("eslint")

      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.enable("html")

      vim.lsp.config("taplo", { capabilities = capabilities })
      vim.lsp.enable("taplo")

      vim.lsp.config("ts_ls", { capabilities = capabilities })
      vim.lsp.enable("ts_ls")
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
        "prettierd", -- prettier formatter
        "stylua", -- lua formatter
        "pylint", -- python linter
        "eslint_d", -- js linter
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
