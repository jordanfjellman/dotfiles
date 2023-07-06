---------------------------------------------------------------------------
-- Null-LS
-- Middleman between Neovim's builtin LSP and formatters, linters, or other
-- utilities.
---------------------------------------------------------------------------
local has_null_ls, null_ls = pcall(require, "null-ls")
if not has_null_ls then
  return
end

local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup({
  disabled_filetypes = { "sbt", "scala" },
  debug = false,
  sources = {
    code_actions.eslint,
    code_actions.gitsigns,
    completion.spell,
    diagnostics.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file(".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs")
      end,
    }),
    formatting.prettierd,
  },
  on_attach = function(client)
    if client.server_capabilities.document_formatting then
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
        pattern = { "*" },
        callback = vim.lsp.buf.format,
      })
    end
  end,
})
