return {
  "ThePrimeagen/vim-apm",
  lazy = false,
  config = function()
    local apm = require("vim-apm")
    apm:setup({})
    vim.keymap.set("n", "<leader>tm", function()
      apm:toggle_monitor()
    end, { desc = "Toggle APM Monitor" })
  end,
}
