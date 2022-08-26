local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
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
