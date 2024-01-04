return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamoman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "bashls",
        "cmake",
        "cssls",
        "diagnosticls",
        "dockerls",
        "graphql",
        "html",
        "jsonls",
        "lua_ls",
        "rust_analyzer",
        "taplo",
        "tsserver",
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
      local disable_builtin_lsp_formatter = function(client)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
      end

      local lspconfig = require("lspconfig")
      local capabilties = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.lua_ls.setup({
        capabilities = capabilties,
        on_attach = disable_builtin_lsp_formatter,
        settings = {
          Lua = {
            format = {
              enable = true,
            },
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lspconfig.ansiblels.setup({
        capabilities = capabilties,
        on_attach = disable_builtin_lsp_formatter,
      })

      lspconfig.graphql.setup({
        capabilities = capabilties,
        on_attach = disable_builtin_lsp_formatter,
      })

      lspconfig.jsonls.setup({
        capabilities = capabilties,
        on_attach = disable_builtin_lsp_formatter,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      lspconfig.yamlls.setup({
        capabilities = capabilties,
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
    end,
    keys = {
      {
        "gD",
        function()
          vim.lsp.buf.declaration()
        end,
      },
      {
        "gd",
        function()
          vim.lsp.buf.definition()
        end,
      },
      {
        "K",
        function()
          vim.lsp.buf.hover()
        end,
      },
      {
        "gi",
        function()
          vim.lsp.buf.implementation()
        end,
      },
      {
        "gr",
        function()
          vim.lsp.buf.references()
        end,
      },
      {
        "gds",
        function()
          vim.lsp.buf.document_symbol()
        end,
      },
      {
        "gws",
        function()
          vim.lsp.buf.workspace_symbol()
        end,
      },
      {
        "<leader>D",
        function()
          vim.lsp.buf.type_definition()
        end,
      },
      {
        "<leader>rn",
        function()
          vim.lsp.buf.rename()
        end,
      },
      {
        "<leader>sh",
        function()
          vim.lsp.buf.signature_help()
        end,
      },
      {
        "<leader>o",
        function()
          vim.lsp.buf.format({ async = true })
        end,
      },
      {
        "<leader>ca",
        function()
          vim.lsp.buf.code_action()
        end,
      },
      {
        "<leader>cl",
        function()
          vim.lsp.codelens.run()
        end,
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

        -- scalafmt cannot be ensured to be installed, install via Coursier
        -- https://github.com/mason-org/mason-registry/pull/2019
        -- "scalafmt", -- scala formatter
      },
    },
  },
}
