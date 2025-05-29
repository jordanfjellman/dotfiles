local M = {}

M.setup = function()
  local indent = 2

  -- global
  vim.opt_global.backup = false
  vim.opt_global.cmdheight = 1
  vim.opt_global.completeopt = { "menu", "menuone", "noselect" } -- Completion options (for deoplete)
  vim.opt_global.hidden = true -- Enable background buffers
  vim.opt_global.ignorecase = true -- Ignore case
  vim.opt_global.mouse = "n"
  vim.opt_global.list = false -- Show some invisible characters
  vim.opt_global.listchars = "tab:!·,trail:·,eol:¬"
  vim.opt_global.scrolloff = 8 -- Lines of context
  vim.opt_global.shiftround = true -- Round indent
  vim.opt_global.shortmess:remove("F") -- needed for nvim-metals
  vim.opt_global.shortmess:append("c") -- added after removing noinsert from completeopt
  vim.opt_global.sidescrolloff = 8 -- Columns of context
  vim.opt_global.smartcase = true -- Do not ignore case with capitals
  vim.opt_global.splitbelow = true -- Put new windows below current
  vim.opt_global.splitright = true -- Put new windows right of current
  vim.opt_global.termguicolors = true -- True color support
  vim.opt_global.updatetime = 300
  vim.opt_global.wildignore = {
    ".git",
    "*/node_modules/*",
    "*/target/*",
    "*/.metals/*",
    "*/.bloop/*",
    "*/.ammonite/*",
  }
  vim.opt_global.wildmode = { "list", "longest" } -- Command-line completion mode

  -- window-scoped
  vim.opt.colorcolumn = "80"
  vim.opt.number = true -- Show line numbers
  vim.opt.relativenumber = true -- Relative line numbers
  vim.opt.signcolumn = "yes"
  vim.opt.wrap = false -- Disable line wrap

  -- buffer-scoped
  vim.opt.expandtab = true -- Use spaces instead of tabs
  vim.opt.fileformat = "unix"
  vim.opt.shiftwidth = indent -- Size of an indent
  vim.opt.smartindent = true -- Insert indents automatically
  vim.opt.softtabstop = indent
  vim.opt.swapfile = false
  vim.opt.tabstop = indent -- Number of spaces tabs count for
end

return M
