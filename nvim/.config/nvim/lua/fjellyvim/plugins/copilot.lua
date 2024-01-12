return {
  "github/copilot.vim",
  lazy = false,
  config = function()
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', {
      desc = "Copilot: Accept",
      expr = true,
      replace_keycodes = false,
    })
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
  end,
}
