local M = {}

M.setup = function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  require("settings.lsp.lsp-installer").setup()
  require("settings.lsp.lsp-signature").setup()
  require("settings.lsp.null-ls-nvim").setup()
end

return M
