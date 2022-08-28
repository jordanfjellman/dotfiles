local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path
  })
end

vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })

  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  -- LSP and LSP Related Plugins
  use({
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  })
  use({
    "scalameta/nvim-metals",
    requires = { "nvim-lua/plenary.nvim" },
  })
  use({ "jose-elias-alvarez/null-ls.nvim" })
  use({ "ray-x/lsp_signature.nvim" })

  -- Autocompletion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })

  -- Comments
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = {
      "nvim-treesitter/nvim-treesitter",
      "numToStr/Comment.nvim",
    }
  })

  -- Theme and UI
  use({ "projekt0n/github-nvim-theme" })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons"
  })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  })
  use({
    "petertriho/nvim-scrollbar",
    requires = "kevinhwang91/nvim-hlslens"
  })

  -- Git
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })
  use({
    "tpope/vim-fugitive",
    requires = { "tpope/vim-rhubarb" },
  })

  -- Telescope
  -- todo: ensure ripgrep is installed (required for live_grep)
  -- todo: ensure fd is installed (finder)
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.x",
    requires = {
      { "nvim-lua/plenary.nvim" },
      -- todo: ensure make is installed
      -- info: had to run make manually after switching from fzy
      -- https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/47#issuecomment-988353015
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "ThePrimeagen/harpoon" },
      { "xiyaowong/telescope-emoji.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "kyazdani42/nvim-web-devicons" },
    }
  })

  -- Misc Plugins
  use({
    "iamcco/markdown-preview.nvim",
    run = function() fn["mkdp#util#install"]() end,
  })
  use({
    "preservim/vim-markdown",
    requires = {
      "godlygeek/tabular",
    }
  })
  use({ "kevinhwang91/nvim-bqf", ft = "qf" })
  use({ "kylechui/nvim-surround" })
  use({ "windwp/nvim-autopairs" })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)