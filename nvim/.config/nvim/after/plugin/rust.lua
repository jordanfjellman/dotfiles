vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },
      diagnostics = {
        enable = true,
      },
      procMacro = {
        enable = true,
        attributes = {
          enable = true,
        },
      },
    },
  },
})
