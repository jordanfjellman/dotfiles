local has_comment, comment = pcall(require, "Comment")
if not has_comment then
  return
end

local has_ts_context, ts_context = pcall(
  require,
  "ts_context_commentstring"
)
if not has_ts_context then
  return
end

local has_comment_integration, comment_integration = pcall(
  require,
  "ts_context_commentstring.integrations.comment_nvim"
)
if not has_comment_integration then
  return
end

vim.g.skip_ts_context_commentstring_module = true

comment.setup {
  pre_hook = comment_integration.create_pre_hook(),
}

ts_context.setup {
  enable_autocmd = false,
}

