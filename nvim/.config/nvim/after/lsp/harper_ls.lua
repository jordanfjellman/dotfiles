-- Harper: offline grammar and spelling for prose. Installed via mise.
--
-- Harper owns grammar, spelling, and mechanics. Vale (see plugins/linting.lua)
-- owns style and readability. Keeping the split clean means a flagged span has
-- one owner and one place to silence it.
return {
  -- lspconfig ships a much wider list that includes rust, lua, python and more,
  -- so Harper checks comments in source files too. Narrowed to prose while I'm
  -- trialling it; delete this key to get the full list back.
  filetypes = { "markdown", "text", "asciidoc", "gitcommit" },
  settings = {
    ["harper-ls"] = {
      linters = {
        -- Vale's Jordan.SentenceLength and Jordan.VeryLongSentence already flag
        -- these, with Hemingway's two thresholds instead of one.
        LongSentences = false,
      },
    },
  },
}
