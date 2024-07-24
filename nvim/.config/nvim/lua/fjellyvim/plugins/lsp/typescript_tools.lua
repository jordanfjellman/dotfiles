return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
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
