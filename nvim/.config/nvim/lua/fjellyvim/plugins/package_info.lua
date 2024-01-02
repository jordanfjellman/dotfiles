return {
  "vuki656/package-info.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  config = function()
    require("package-info").setup()

    vim.api.nvim_set_keymap(
      "n",
      "<leader>vt",
      "<cmd>lua require('package-info').toggle()<cr>",
      { silent = true, noremap = true }
    )

    vim.api.nvim_set_keymap(
      "n",
      "<leader>vc",
      "<cmd>lua require('package-info').change_version()<cr>",
      { silent = true, noremap = true }
    )
  end,
}
