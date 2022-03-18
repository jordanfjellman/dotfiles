local M = {}

M.setup = function()
  local null_ls = require("null-ls")
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup({
    disabled_filetypes = { "sbt", "scala" },
    debug = true,
    sources = {
      diagnostics.eslint,
      formatting.prettier,
    },
    on_attach = function(client)
      if client.resolved_capabilities.document_formatting then
          vim.cmd([[
            augroup LspFormatting
              autocmd! * <buffer>
              autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()
            augroup END
          ]])
      end
    end,
  })
end

return M

