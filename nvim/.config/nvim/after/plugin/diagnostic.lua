local x = vim.diagnostic.severity
vim.diagnostic.config({
  virtual_text = false, -- { prefix = "" },
  signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  underline = true, -- include HINT/INFO; some "unused" diagnostics arrive
  -- below WARN severity. Tagged-Unnecessary unused code also grays out via
  -- the DiagnosticUnnecessary highlight (links to Comment) regardless of
  -- severity, once the LSP advertises publishDiagnostics tagSupport.
  float = {
    --   focus = false,
    --   focusable = false,
    style = "minimal",
    border = "none",
    source = "if_many",
    header = "",
    prefix = "",
  },
  -- update_in_insert = true,
  -- severity_sort = true,
  -- signs = {
  --   active = signs,
  -- },
})

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ wrap = true, count = 1, on_jump = vim.diagnostic.open_float })
end, { desc = "Next [D]iagnostic" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ wrap = true, count = -1, on_jump = vim.diagnostic.open_float })
end, { desc = "Previous [D]iagnostic" })
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float({ scope = "line" })
end)
