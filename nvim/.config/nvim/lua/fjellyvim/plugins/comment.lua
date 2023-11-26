return {
  "numToStr/Comment.nvim",
  dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      -- Comment.nvim already supports treesitter out-of-the-box for all the languages except tsx/jsx.
      { "JoosepAlviste/nvim-ts-context-commentstring" },
  },
  lazy = false,
  config = function ()
    require("Comment").setup {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }

    vim.g.skip_ts_context_commentstring_module = true

    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }
  end
}
