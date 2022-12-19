local M = {}

---------------------------------------------------------
-- Configure LSPs
-- Server configuration should be done after installation
---------------------------------------------------------
M.setup_servers = function()
  local has_lspconfig, lspconfig = pcall(require, "lspconfig")
  if not has_lspconfig then
    return
  end

  local disable_builtin_lsp_formatter = function(client)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end

  -- info: recommended lua confiuration for neovim
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
  lspconfig.sumneko_lua.setup {
    settings = {
      Lua = {
        format = {
          enable = true
        },
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  lspconfig.jsonls.setup {
    on_attach = disable_builtin_lsp_formatter,
  }

  lspconfig.tsserver.setup {
    on_attach = disable_builtin_lsp_formatter,
  }

  lspconfig.yamlls.setup {
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
          "!Join sequence"
        },
        format = {
          enable = true,
        },
        hover = true,
        validate = true,
      },
    },
  }
end

M.setup_keymaps = function()
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end)
  vim.keymap.set("n", "gds", function() vim.lsp.buf.document_symbol() end)
  vim.keymap.set("n", "gws", function() vim.lsp.buf.workspace_symbol() end)
  vim.keymap.set("n", "<leader>D", function() vim.lsp.buf.type_definition() end)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end)
  vim.keymap.set("n", "<leader>sh", function() vim.lsp.buf.signature_help() end)
  vim.keymap.set("n", "<leader>o", function() vim.lsp.buf.format({ async = true}) end)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end)
  vim.keymap.set("n", "<leader>cl", function() vim.lsp.codelens.run() end)
end

return M
