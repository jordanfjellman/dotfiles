return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    {
      "<leader>tt",
      function()
        require("trouble").toggle()
      end,
    },
    {
      "<leader>tn",
      function()
        require("trouble").next({ skip_groups = true, jump = true })
      end,
    },
    {
      "<leader>tp",
      function()
        require("trouble").previous({ skip_groups = true, jump = true })
      end,
    },
    {
      "gR",
      function()
        require("trouble").toggle("lsp_references")
      end,
    },
  },
}
