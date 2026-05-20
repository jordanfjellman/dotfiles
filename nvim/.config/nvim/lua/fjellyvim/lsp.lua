vim.lsp.config("brightscript-lsp", {
  cmd = { vim.fn.expand("~/.local/bin/bright-lsp") },
  filetypes = { "brightscript" },
  root_markers = { "bsconfig.json", "makefile", "Makefile", ".git" },
  on_attach = function()
    vim.notify("attached to brightscript-lsp")
  end,
})

vim.lsp.enable("brightscript-lsp")
