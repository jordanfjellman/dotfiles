local M = {}

local bootstrap_lazy = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local plugins = {
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP and LSP Related Plugins
  "williamboman/mason.nvim",
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = { "neovim/nvim-lspconfig" },
  },
  "j-hui/fidget.nvim", -- display status updates for LSP

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
    },
  },

  -- Comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "numToStr/Comment.nvim",
    }
  },

  -- Theme and UI
  {
    "projekt0n/github-nvim-theme"
  },
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true }
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "kyazdani42/nvim-web-devicons", opt = true },
      { "projekt0n/github-nvim-theme",  opt = true }
    },
  },
  {
    "petertriho/nvim-scrollbar",
    dependencies = "kevinhwang91/nvim-hlslens"
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Telescope
  -- todo: ensure ripgrep is installed (required for live_grep)
  -- todo: ensure fd is installed (finder)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- todo: ensure make is installed
      -- info: had to run make manually after switching from fzy
      -- https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/47#issuecomment-988353015
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "ThePrimeagen/harpoon" },
      { "xiyaowong/telescope-emoji.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "kyazdani42/nvim-web-devicons" },
    }
  },

  -- Misc Plugins
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "preservim/vim-markdown",
    dependencies = {
      "godlygeek/tabular",
    }
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf"
  },
  "kylechui/nvim-surround",
  "windwp/nvim-autopairs",
  "lewis6991/impatient.nvim",
  "b0o/schemastore.nvim",
}

local opts = {

}

M.setup = function()
  bootstrap_lazy()
  require("lazy").setup(plugins, opts)
end

return M
