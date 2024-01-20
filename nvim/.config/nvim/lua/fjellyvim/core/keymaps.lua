local M = {}

M.setup = function()
  vim.keymap.set("n", "<SPACE>", "<NOP>")
  vim.keymap.set("i", "jk", "<ESC>")
  vim.keymap.set("n", "<leader>h", ":noh<CR>") -- not needed, duplicate of <C-L>

  vim.keymap.set("n", "<leader><leader>e", [[:luafile %<CR>]])

  -- resizing splits
  vim.keymap.set("n", "<leader>[", ":vertical resize -3<CR>")
  vim.keymap.set("n", "<leader>]", ":vertical resize +3<CR>")

  -- indenting
  vim.keymap.set("v", ">", ">gv", { desc = "indent right" })
  vim.keymap.set("v", "<", "<gv", { desc = "indent left" })

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
  vim.keymap.set("n", "<leader>xo", ":copen<CR>", { desc = "open quickfix list" })
  vim.keymap.set("n", "<leader>xc", ":cclose<CR>", { desc = "close quickfix list" })
  vim.keymap.set("n", "<C-K>", "<cmd>cnext<CR>zz", { desc = "next quickfix item" })
  vim.keymap.set("n", "<C-J>", "<cmd>cprevious<CR>zz", { desc = "previous quickfix item" })

  -- move lines
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up" })
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down" })

  -- center after navigation
  vim.keymap.set("n", "<C-d>", "<C-d>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")
  vim.keymap.set("n", "n", "nzzzu")
  vim.keymap.set("n", "N", "Nzzzu")
end

return M
