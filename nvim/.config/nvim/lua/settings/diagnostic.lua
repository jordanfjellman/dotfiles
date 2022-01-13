local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config {
    update_in_insert = true,
    severity_sort = true,
  }
end

return M

-- styling ref: https://github.com/lucax88x/configs/blob/master/dotfiles/.config/nvim/lua/lt/lsp/init.lua

