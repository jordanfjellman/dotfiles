-- Aliases
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

cmd 'colorscheme github_dimmed'            -- Put your favorite colorscheme here

g.mapleader = ' '

g.markdown_folding = 1
cmd 'au FileType markdown setlocal foldlevel=99' -- Expand all folds on open

opt.backup = false
opt.colorcolumn = '80'
opt.cmdheight = 2
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options (for deoplete)
opt.expandtab = true                -- Use spaces instead of tabs
-- opt.guicursor =
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.listchars = 'trail:·'
opt.swapfile = false
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 2                  -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.signcolumn = 'yes'
opt.softtabstop = 2
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = 2                     -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.updatetime = 50
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap


-- Auto Formatting
-- vim.o.formatoptions = vim.o.formatoptions .. 'a'
vim.api.nvim_exec(
  [[
    augroup MyFormatter
      autocmd!
      autocmd InsertLeave * normal gw<CR>
    augroup end
  ]],
  false
)

