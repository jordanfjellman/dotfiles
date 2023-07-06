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
if has_mason_lspconfig then
  mason_lspconfig.setup({
    automatic_installation = false,
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
      "yamlls"
    },
  })
end


local has_mason_null_ls, mason_null_ls = pcall(require, "mason-null-ls")
if has_mason_null_ls then
  mason_null_ls.setup({
    ensure_installed = {
      "codelldb",
      "eslint_d",
      "prettierd",
      "stylua",
    },
    automatic_installation = false,
    automatic_setup = true,
  })
end


-- setup servers after installation
require("fjellyvim.lsp").setup_servers()
