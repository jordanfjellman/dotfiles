return {
  -- Automatically configure Lua Language Server for Neovim development
  {
    "folke/neodev.nvim",
    opts = {
      library = {
        plugins = { "nvim-dap", "nvim-dap-ui" },
        types = true,
      },
    },
  },

  -- A Neovim port of Matt Pocock's ts-error-translator for VSCode for turning
  -- messy and confusing TypeScript errors into plain English.
  { "dmmulroy/ts-error-translator.nvim", opts = {} },
}
