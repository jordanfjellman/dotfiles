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
cmd([[packadd packer.nvim]])

require("plugins")
require("globals")

require("settings.cmp").setup()
require("settings.diagnostic").setup()
require("settings.lsp").setup()
require("settings.telescope").setup()
require("settings.theme").setup()
require("settings.tree").setup()
require("settings.treesitter").setup()

require("Comment").setup()
require("gitsigns").setup()
require("lualine").setup()
require("nvim-autopairs").setup()

----------------------------------
-- Variables ---------------------
----------------------------------
g["mapleader"] = " "
g["netrw_gx"] = "<cWORD>"

-- markdown plugin?
g["markdown_folding"] = 1

-- nvim-metals
g["metals_server_version"] = "0.10.9"

----------------------------------
-- Options -----------------------
----------------------------------
local indent = 2

-- global
global_opt.backup = false
global_opt.cmdheight = 2
global_opt.completeopt = {"menu", "menuone", "noinsert", "noselect"} -- Completion options (for deoplete)
global_opt.hidden = true -- Enable background buffers
global_opt.ignorecase = true -- Ignore case
global_opt.mouse = "n"
global_opt.list = true -- Show some invisible characters
global_opt.listchars = "trail:·"
global_opt.scrolloff = 4 -- Lines of context
global_opt.shiftround = true -- Round indent
global_opt.shortmess:remove("F"):append("c") -- needed for nvim-metals
global_opt.sidescrolloff = 8 -- Columns of context
global_opt.smartcase = true -- Do not ignore case with capitals
global_opt.splitbelow = true -- Put new windows below current
global_opt.splitright = true -- Put new windows right of current
global_opt.termguicolors = true -- True color support
global_opt.updatetime = 300
global_opt.wildmode = {"list", "longest"} -- Command-line completion mode

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

-- lsp
map("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]])
map("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
map("n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
map("v", "K", [[<cmd>lua require"metals".type_of_range()<CR>]])
map("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
map("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
map("n", "gds", [[<cmd>lua vim.lsp.buf.document_symbol()<CR>]])
map("n", "gws", [[<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]])
map("n", "<leader>D", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]])
map("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>o", [[<cmd>lua vim.lsp.buf.formatting()<CR>]])
map("n", "<leader>ca", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>ws", [[<cmd>lua require"metals".worksheet_hover()<CR>]])

-- diagnostic
map("n", "<leader>dn", [[<cmd>lua vim.diagnostic.goto_next({wrap = true, float = true})<CR>]])
map("n", "<leader>dp", [[<cmd>lua vim.diagnostic.goto_prev({wrap = true, float = true})<CR>]])
map("n", "<leader>d", [[<cmd>lua vim.diagnostic.open_float(0, {scope = "line"})<CR>]])

-- telescope
map("n", "<leader>ff", [[<cmd>lua require"telescope.builtin".find_files()<CR>]])
map("n", "<leader>lg", [[<cmd>lua require"telescope.builtin".live_grep()<CR>]])
map("n", "<leader>fb", [[<cmd>lua require"telescope.builtin".file_browser()<CR>]])
map("n", "<leader>mc", [[<cmd>lua require("telescope").extensions.metals.commands()<CR>]])
map("n", "<leader>gc", [[<cmd>lua require"telescope.builtin".git_commits()<CR>]])
map("n", "<leader>gs", [[<cmd>lua require"telescope.builtin".git_status()<CR>]])
map("n", "<leader>fm", [[<cmd>lua require"telescope".extensions.harpoon.marks()<CR>]])

-- harpoon
map("n", "<leader>ha", [[<cmd>lua require"harpoon.mark".add_file()<CR>]])
map("n", "<leader>hv", [[<cmd>lua require"harpoon.ui".toggle_quick_menu()<CR>]])
map("n", "<leader>h1", [[<cmd>lua require"harpoon.ui".nav_file(1)<CR>]])
map("n", "<leader>h2", [[<cmd>lua require"harpoon.ui".nav_file(2)<CR>]])
map("n", "<leader>h3", [[<cmd>lua require"harpoon.ui".nav_file(3)<CR>]])
map("n", "<leader>h4", [[<cmd>lua require"harpoon.ui".nav_file(4)<CR>]])
map("n", "<leader>hn", [[<cmd>lua require"harpoon.ui".nav_next()<CR>]])

----------------------------------
-- Commands ----------------------
----------------------------------
cmd("colorscheme github_dimmed")

-- markdown plugin?
cmd([[au FileType markdown setlocal foldlevel=99]]) -- expand all folds on open

-- lsp
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
cmd([[augroup end]])

cmd([[hi! link LspCodeLens CursorColumn]])
cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])
cmd([[command! Format lua vim.lsp.buf.formatting()]])

