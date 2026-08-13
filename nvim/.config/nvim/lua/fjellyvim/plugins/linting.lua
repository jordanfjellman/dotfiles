return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      json = { "biomejs" },
      jsonc = { "biomejs" },
      javascript = { "biomejs" },
      typescript = { "biomejs" },
      javascriptreact = { "biomejs" },
      typescriptreact = { "biomejs" },
      -- Prose style and readability. Grammar and spelling are harper_ls's job
      -- (see after/lsp/harper_ls.lua), so the two don't report the same span.
      markdown = { "vale" },
      text = { "vale" },
    }

    -- nvim-lint pipes the buffer to vale over stdin, so vale sees the file as
    -- "stdin.md" and skips every filename-scoped section in .vale.ini (the
    -- [README.md] override, for one). --path restores them.
    local vale = lint.linters.vale
    table.insert(vale.args, "--path")
    table.insert(vale.args, function()
      return vim.api.nvim_buf_get_name(0)
    end)

    -- --path also changes the shape of the output: vale keys its JSON by the
    -- path it was given instead of by "stdin.<ext>", which is the literal key
    -- nvim-lint's parser looks under. Without this the parse silently finds
    -- nothing and vale looks like it's passing every file. Re-key, then hand
    -- off to the shipped parser so its span and severity handling still apply.
    local parse = vale.parser
    vale.parser = function(output, bufnr, ...)
      if vim.trim(output) == "" then
        return parse(output, bufnr, ...)
      end
      local ok, decoded = pcall(vim.json.decode, output)
      if ok and type(decoded) == "table" then
        local ext = "." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e")
        for key, alerts in pairs(decoded) do
          if key ~= "stdin" .. ext then
            output = vim.json.encode({ ["stdin" .. ext] = alerts })
          end
          break
        end
      end
      return parse(output, bufnr, ...)
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

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
