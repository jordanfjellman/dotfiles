return {
  {
    -- Highlight todo, notes, warnings, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      -- Comment.nvim already supports treesitter out-of-the-box for all the languages except tsx/jsx.
      { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    lazy = false,
    config = function()
      -- skip backwards compatibity checks to speed up loading
      vim.g.skip_ts_context_commentstring_module = true

      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })

      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
}
