local has_tree, tree = pcall(require, "nvim-tree")
if not has_tree then
  return
end

tree.setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  disable_netrw = true,
  git = {
    ignore = false,
  },
  view = {
    adaptive_size = true,
  },
})

vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>")
