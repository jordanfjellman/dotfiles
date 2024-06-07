return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    -- on_attach = function(_, bufnr)
    --   local ts_lsp_group = vim.api.nvim_create_augroup("fjellyvim-ts-lsp", { clear = true })
    --   vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    --     buffer = bufnr,
    --     callback = function()
    --       local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    --       local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = r - 1 })
    --       if line_diagnostics and #line_diagnostics == 0 then
    --         vim.lsp.buf.hover()
    --       else
    --         vim.diagnostic.open_float(bufnr, { scope = "line" })
    --       end
    --     end,
    --     group = ts_lsp_group,
    --     desc = "[TYPESCRIPT_TOOLS] Show hover on cursor hold",
    --   })
    -- end,
    settings = {
      tsserver_file_preferences = {
        -- quotePreference = "auto",
        -- importModuleSpecifierEnding = "auto",
        -- jsxAttributeCompletionStyle = "auto",
        -- allowTextChangesInNewFiles = true,
        -- providePrefixAndSuffixTextForRename = true,
        -- allowRenameOfImportPath = true,
        -- includeAutomaticOptionalChainCompletions = true,
        -- provideRefactorNotApplicableReason = true,
        -- generateReturnInDocTemplate = true,
        -- includeCompletionsForImportStatements = true,
        -- includeCompletionsWithSnippetText = true,
        -- includeCompletionsWithClassMemberSnippets = true,
        -- includeCompletionsWithObjectLiteralMethodSnippets = true,
        -- useLabelDetailsInCompletionEntries = true,
        -- allowIncompleteCompletions = true,
        -- displayPartsForJSDoc = true,
        -- disableLineTextInReferences = true,
        includeInlayParameterNameHints = "all",
        -- includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        -- includeInlayFunctionParameterTypeHints = false,
        -- includeInlayVariableTypeHints = false,
        -- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        -- includeInlayPropertyDeclarationTypeHints = false,
        -- includeInlayFunctionLikeReturnTypeHints = false,
        -- includeInlayEnumMemberValueHints = false,
      },
    },
  },
}
