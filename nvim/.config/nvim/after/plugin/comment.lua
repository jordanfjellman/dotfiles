local has_comment, comment = pcall(require, "Comment")
if not has_comment then
  return
end

local has_comment_ts_context, comment_ts_context = pcall(
  require,
  "ts_context_commentstring.integrations.comment_nvim"
)
if not has_comment_ts_context then
  return
end

comment.setup {
  pre_hook = comment_ts_context.create_pre_hook(),
}
