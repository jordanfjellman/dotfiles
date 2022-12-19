local M = {}

M.setup = function()
  vim.keymap.set("n", "<SPACE>", "<NOP>")
  vim.keymap.set("i", "jk", "<ESC>")
  vim.keymap.set("n", "<leader>h", ":noh<CR>")

  vim.keymap.set("n", "<leader><leader>e", [[:luafile %<CR>]])

  -- window navigation
  vim.keymap.set("n", "<C-h>", "<C-w>h")
  vim.keymap.set("n", "<C-j>", "<C-w>j")
  vim.keymap.set("n", "<C-k>", "<C-w>k")
  vim.keymap.set("n", "<C-l>", "<C-w>l")

  -- resizing splits
  vim.keymap.set("n", "<leader>[", ":vertical resize -3<CR>")
  vim.keymap.set("n", "<leader>]", ":vertical resize +3<CR>")

  -- indenting
  vim.keymap.set("v", ">", ">gv")
  vim.keymap.set("v", "<", "<gv")

  -- clipboard
  vim.keymap.set("v", "<leader>y", '"+y')
  vim.keymap.set("n", "<leader>Y", '"+yg_')
  vim.keymap.set("n", "<leader>y", '"+y')
  vim.keymap.set("n", "<leader>yy", '"+yy')
  vim.keymap.set("n", "<leader>p", '"+p')
  vim.keymap.set("n", "<leader>p", '"+p')
  vim.keymap.set("v", "<leader>p", '"+p')
  vim.keymap.set("v", "<leader>p", '"+p')

  -- quickfix lists
  vim.keymap.set("n", "<leader>lo", ":copen<CR>")
  vim.keymap.set("n", "<leader>lc", ":cclose<CR>")
  vim.keymap.set("n", "<leader>ln", ":cnext<CR>")
  vim.keymap.set("n", "<leader>lp", ":cprevious<CR>")

  -- center after navigation
  vim.keymap.set("n", "<C-d>", "<C-d>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")
  vim.keymap.set("n", "n", "nzzzu")
  vim.keymap.set("n", "N", "Nzzzu")
end

return M
