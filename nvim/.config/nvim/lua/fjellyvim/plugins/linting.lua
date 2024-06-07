return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    local biome_with_fallback = { "biomejs" }

    lint.linters_by_ft = {
      json = { "biomejs" },
      jsonc = { "biomejs" },
      javascript = biome_with_fallback,
      typescript = biome_with_fallback,
      javascriptreact = biome_with_fallback,
      typescriptreact = biome_with_fallback,
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- local lint = require "lint"
    --
    -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    --
    -- lint.linters_by_ft = {
    -- typescript = { "biomejs", "eslint_d", "eslint" },
    -- javascript = { "biomejs", "eslint_d", "eslint" },
    -- typescriptreact = { "biomejs", "eslint_d", "eslint" },
    -- javascriptreact = { "biomejs", "eslint_d", "eslint" },
    -- }
    --
    -- local eslint = lint.linters.eslint_d
    --
    -- eslint.args = {
    -- "--no-warn-ignored", -- <-- this is the key argument
    -- "--format",
    -- "json",
    -- "--stdin",
    -- "--stdin-filename",
    -- function()
    -- return vim.api.nvim_buf_get_name(0)
    -- end,
    -- }
    --
    -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    -- group = lint_augroup,
    -- callback = function()
    -- lint.try_lint()
    -- end,
    -- })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
