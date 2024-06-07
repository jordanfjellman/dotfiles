return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- local biome_with_fallback = { "biome", "prettier" }
    local biome_with_fallback = { "prettier" }

    conform.setup({
      formatters_by_ft = {
        css = { "prettier" },
        graphql = { "prettier" },
        html = { "prettier" },
        javascript = biome_with_fallback,
        javascriptreact = biome_with_fallback,
        json = biome_with_fallback,
        go = {
          "goimports-reviser",
          "golines",
          "gofumpt",
        },
        lua = { "stylua" },
        markdown = { "prettier" },
        typescript = biome_with_fallback,
        typescriptreact = biome_with_fallback,
        scala = { "scalafmt" },
        yaml = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
      -- formatters = {
      --   biome = {
      --     command = "biome",
      --     args = { "--stdin" },
      --     rootPatterns = { ".biome" },
      --   },
      -- },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
