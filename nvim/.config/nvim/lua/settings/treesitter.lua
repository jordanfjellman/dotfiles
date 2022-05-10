local M = {}

M.setup = function ()
  require("nvim-treesitter.configs").setup({
    playground = { enable = true },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    ensure_installed = "all",
    ignore_install = { "phpdoc" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/2886#issuecomment-1120015543
    highlight = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    }
  })
end

return M
