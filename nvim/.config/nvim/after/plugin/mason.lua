-------------------------------------------------------------
-- Mason
-- Installs language servers, debuggers, linters, etc.
-- https://github.com/williamboman/mason-lspconfig.nvim#setup
-------------------------------------------------------------
local has_mason, mason = pcall(require, "mason")
if not has_mason then
  return
end
mason.setup()

local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not has_mason_lspconfig then
  return
end
mason_lspconfig.setup({
  automatic_installation = false,
  ensure_installed = {
    "bashls",
    "cmake",
    "cssls",
    "diagnosticls",
    "dockerls",
    "graphql",
    "eslint",
    "html",
    "jsonls",
    "lua_ls",
    "tsserver",
    "yamlls"
  },
})

-- setup servers after installation
require("fjellyvim.lsp").setup_servers()
