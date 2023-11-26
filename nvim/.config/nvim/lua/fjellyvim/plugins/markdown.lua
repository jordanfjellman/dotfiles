return {
  {
    "preservim/vim-markdown",
    dependencies = {
      "godlygeek/tabular",
    }
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}