----------------------------------
-- Aliases -----------------------
----------------------------------
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local f = require("functions")
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local map = f.map
local opt = vim.opt -- to set options
local global_opt = vim.opt_global

----------------------------------
-- Setup Plugins -----------------
----------------------------------
require("plugins")
require("globals")

require("fjellyvim")

require("lualine").setup()
require("nvim-autopairs").setup()
require("nvim-surround").setup({})

----------------------------------
-- Variables ---------------------
----------------------------------
g["mapleader"] = " "
g["netrw_gx"] = "<cWORD>"

-- markdown plugin?
g["markdown_folding"] = 1

----------------------------------
-- Options -----------------------
----------------------------------
local indent = 2

-- global
global_opt.backup = false
global_opt.cmdheight = 2
global_opt.completeopt = { "menu", "menuone", "noinsert", "noselect" } -- Completion options (for deoplete)
global_opt.hidden = true -- Enable background buffers
global_opt.ignorecase = true -- Ignore case
global_opt.mouse = "n"
global_opt.list = true -- Show some invisible characters
global_opt.listchars = "trail:·"
global_opt.scrolloff = 8 -- Lines of context
global_opt.shiftround = true -- Round indent
global_opt.shortmess:remove("F"):append("c") -- needed for nvim-metals
global_opt.sidescrolloff = 8 -- Columns of context
global_opt.smartcase = true -- Do not ignore case with capitals
global_opt.splitbelow = true -- Put new windows below current
global_opt.splitright = true -- Put new windows right of current
global_opt.termguicolors = true -- True color support
global_opt.updatetime = 300
global_opt.wildignore = { ".git", "*/node_modules/*", "*/target/*", ".metals", ".bloop", ".ammonite" }
global_opt.wildmode = { "list", "longest" } -- Command-line completion mode

-- window-scoped
opt.colorcolumn = "120"
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.signcolumn = "yes"
opt.wrap = false -- Disable line wrap

-- buffer-scoped
opt.expandtab = true -- Use spaces instead of tabs
opt.fileformat = "unix"
opt.shiftwidth = indent -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.softtabstop = indent
opt.swapfile = false
opt.tabstop = indent -- Number of spaces tabs count for

----------------------------------
-- Mappings ----------------------
----------------------------------
map("n", "<SPACE>", "<NOP>")
map("i", "jk", "<ESC>")
map("n", "<leader>h", ":noh<CR>")
map("n", "<leader>e", ":NvimTreeToggle<CR>")

map("n", "<leader><leader>e", [[:luafile %<CR>]])

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- resizing splits
map("n", "<leader>[", ":vertical resize -3<CR>")
map("n", "<leader>]", ":vertical resize +3<CR>")

-- indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

-- clipboard
map("v", "<leader>y", '"+y')
map("n", "<leader>Y", '"+yg_')
map("n", "<leader>y", '"+y')
map("n", "<leader>yy", '"+yy')
map("n", "<leader>p", '"+p')
map("n", "<leader>p", '"+p')
map("v", "<leader>p", '"+p')
map("v", "<leader>p", '"+p')

-- harpoon
map("n", "<leader>ma", [[<cmd>lua require"harpoon.mark".add_file()<CR>]])
map("n", "<leader>mv", [[<cmd>lua require"harpoon.ui".toggle_quick_menu()<CR>]])
map("n", "<leader>m1", [[<cmd>lua require"harpoon.ui".nav_file(1)<CR>]])
map("n", "<leader>m2", [[<cmd>lua require"harpoon.ui".nav_file(2)<CR>]])
map("n", "<leader>m3", [[<cmd>lua require"harpoon.ui".nav_file(3)<CR>]])
map("n", "<leader>m4", [[<cmd>lua require"harpoon.ui".nav_file(4)<CR>]])
map("n", "<leader>mn", [[<cmd>lua require"harpoon.ui".nav_next()<CR>]])
map("n", "<leader>mp", [[<cmd>lua require"harpoon.ui".nav_next()<CR>]])

----------------------------------
-- Commands ----------------------
----------------------------------
-- markdown plugin?
cmd([[au FileType markdown setlocal foldlevel=99]]) -- expand all folds on open

cmd([[hi! link LspCodeLens CursorColumn]])
cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])
cmd([[command! Format lua vim.lsp.buf.formatting()]])
