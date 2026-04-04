vim.lsp.config("brightscript-lsp", {
  cmd = { "/Users/jordan/.local/bin/bright-lsp" },
  filetypes = { "brightscript" },
  root_markers = { "bsconfig.json", "makefile", "Makefile", ".git" },
  on_attach = function()
    vim.notify("attached to brightscript-lsp")
  end,
})

vim.lsp.enable("brightscript-lsp")
