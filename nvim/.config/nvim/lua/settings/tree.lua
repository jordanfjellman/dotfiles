local M = {}

M.setup = function()
  vim.g["nvim_tree_quit_on_open"] = 1

  require("nvim-tree").setup()
end

return M

