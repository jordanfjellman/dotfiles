local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })

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
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require"nvim-tree".setup {} end
  })
  use({ "kyazdani42/nvim-web-devicons"})
  use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
  use({ "neovim/nvim-lspconfig" })
  use({ "numToStr/Comment.nvim" })
  use({
    "nvim-lualine/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true }
  })
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/popup.nvim"},
      { "nvim-lua/plenary.nvim"},
      { "nvim-telescope/telescope-fzy-native.nvim"},
    }})
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use({ "projekt0n/github-nvim-theme" })
  use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })
  use({ 'tami5/lspsaga.nvim' }) 
  use({
    "tpope/vim-fugitive",
    requires = { "tpope/vim-rhubarb" },
  })
  use({ "windwp/nvim-autopairs"})

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
