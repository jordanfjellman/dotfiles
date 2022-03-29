local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })

  use({ "akinsho/toggleterm.nvim" })
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
  use({ "kevinhwang91/nvim-bqf", ft = "qf" })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons"
  })
  use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
  use({ "jose-elias-alvarez/null-ls.nvim" })
  use({
      "neovim/nvim-lspconfig",
      "williamboman/nvim-lsp-installer",
  })
  use({ "numToStr/Comment.nvim" })
  use({
    "nvim-lualine/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true }
  })
  use({
    "petertriho/nvim-scrollbar",
    requires = "kevinhwang91/nvim-hlslens"
  })
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/popup.nvim"},
      { "nvim-lua/plenary.nvim"},
      { "nvim-telescope/telescope-fzy-native.nvim"},
      { "ThePrimeagen/harpoon"},
      { "xiyaowong/telescope-emoji.nvim" },
    }})
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    commit = "668de0951a36ef17016074f1120b6aacbe6c4515"
  })
  use({ "projekt0n/github-nvim-theme" })
  use({ "rebelot/kanagawa.nvim" })
  use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })
  use({
    "tpope/vim-fugitive",
    requires = { "tpope/vim-rhubarb" },
  })
  use({
    "ray-x/lsp_signature.nvim",
  })
  use({ "windwp/nvim-autopairs"})

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
