local has_treesitter = pcall(require, "nvim-treesitter")
if not has_treesitter then
  return
end

require("nvim-treesitter.configs").setup({
  context_commentstring = {
    enable = true,
    enable_autocmd = false, -- disable for comment ts context
  },
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "gitignore",
    "graphql",
    "hocon",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "scala",
    "tsx",
    "typescript",
    "yaml",
  },
  highlight = {
    enable = true,
  },
})

local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
vim.api.nvim_create_autocmd(
  { 'BufNewFile', 'BufRead' },
  { group = hocon_group, pattern = '*.conf', command = 'set ft=hocon' }
)
