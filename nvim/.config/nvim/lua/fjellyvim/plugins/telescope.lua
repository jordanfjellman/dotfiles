return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  -- Only load for Scala/Java files (for Metals integration)
  ft = { "scala", "sbt", "java" },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        prompt_prefix = "❯",
      },
    })

    -- Load Metals extension for Scala LSP commands
    -- Note: This extension is loaded by nvim-metals plugin
    vim.keymap.set(
      "n",
      "<leader>mc",
      function() telescope.extensions.metals.commands() end,
      { desc = "Preview [M]etals [C]ommands" }
    )
  end,
}
