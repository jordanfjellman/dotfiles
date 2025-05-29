return {
  -- {
  --   "folke/lazydev.nvim",
  --   ft = "lua", -- only load on lua files
  --   opts = {
  --     library = {
  --       -- See the configuration section for more details
  --       -- Load luvit types when the `vim.uv` word is found
  --       { path = "luvit-meta/library", words = { "vim%.uv" } },
  --       "nvim-dap",
  --       "nvim-dap-ui",
  --     },
  --   },
  -- },

  -- { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  { "j-hui/fidget.nvim", opts = {} }, -- lsp notifications

  -- A Neovim port of Matt Pocock's ts-error-translator for VSCode for turning
  -- messy and confusing TypeScript errors into plain English.
  { "dmmulroy/ts-error-translator.nvim", opts = {} },
}
