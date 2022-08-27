local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name,
      {
        texthl = sign.name,
        text = sign.text,
        numhl = "",
      }
    )
  end

  vim.diagnostic.config {
    float = {
      focus = false,
      focusable = false,
      style = "minimal",
      border = "none",
      source = "always",
      header = "",
      prefix = "",
    },
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    signs = {
      active = signs,
    },
    virtual_text = false,
  }
end

M.setup_keymaps = function()
  vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.goto_next({ wrap = true, float = true }) end)
  vim.keymap.set("n", "<leader>dp", function() vim.diagnostic.goto_prev({ wrap = true, float = true }) end)
  vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float(0, { scope = "line" }) end)
end

return M
