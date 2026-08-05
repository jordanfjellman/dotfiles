return {
  { "j-hui/fidget.nvim", opts = {} }, -- lsp notifications

  -- A Neovim port of Matt Pocock's ts-error-translator for VSCode for turning
  -- messy and confusing TypeScript errors into plain English.
  {
    "dmmulroy/ts-error-translator.nvim",
    config = function()
      -- The plugin filters by LSP client name and its default list predates tsgo.
      require("ts-error-translator").setup({ servers = { "tsgo" } })

      -- The plugin only wraps textDocument/publishDiagnostics, but tsgo advertises
      -- diagnosticProvider, so Neovim pulls diagnostics instead and no translation
      -- ever runs. Wrap the pull handler the same way. Drop this once the plugin
      -- handles pull diagnostics itself.
      local function translate(message, code)
        local with_code = code and ("TS" .. tostring(code) .. ": " .. message) or message
        local parsed = require("ts-error-translator").parse_errors(with_code)
        if #parsed > 0 and parsed[1].improvedError then
          return parsed[1].improvedError.body
        end
        return message
      end

      local pull_diagnostics = vim.lsp.handlers["textDocument/diagnostic"]
      vim.lsp.handlers["textDocument/diagnostic"] = function(err, result, ctx, config)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == "tsgo" and result and result.items then
          for _, diag in ipairs(result.items) do
            if diag.message then
              diag.message = translate(diag.message, diag.code)
            end
          end
        end
        return pull_diagnostics(err, result, ctx, config)
      end
    end,
  },
}
