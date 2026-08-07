return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters = {
        scalafmt = {
          command = vim.fn.expand("~/Library/Application Support/Coursier/bin/scalafmt"),
          -- Pass the buffer's path so scalafmt can locate the project's
          -- .scalafmt.conf (without it, config discovery is unreliable).
          args = { "--stdin", "--stdin-file-path", "$FILENAME" },
          -- Run from the dir containing .scalafmt.conf so version pinning
          -- and config resolution work.
          cwd = require("conform.util").root_file({ ".scalafmt.conf" }),
          require_cwd = false,
        },
      },
      formatters_by_ft = {
        css = { "prettierd" },
        graphql = { "prettierd" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        go = {
          "goimports-reviser",
          "golines",
          "gofumpt",
        },
        lua = { "stylua" },
        markdown = { "prettierd" },
        rust = { "rustfmt" },
        scala = { "scalafmt" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        yaml = { "prettierd" },
      },
      format_on_save = function(bufnr)
        -- scalafmt (JVM) is much slower than prettierd/stylua, so give
        -- Scala buffers a longer timeout. Fast formatters finish well
        -- before their limit regardless.
        local timeout_ms = vim.bo[bufnr].filetype == "scala" and 10000 or 500
        return {
          lsp_format = "fallback",
          async = false,
          timeout_ms = timeout_ms,
        }
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      local timeout_ms = vim.bo.filetype == "scala" and 10000 or 500
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = timeout_ms,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
