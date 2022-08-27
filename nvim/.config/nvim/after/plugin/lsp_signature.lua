local has_lsp_signature, lsp_signature = pcall(require, "lsp_signature")
if not has_lsp_signature then
  return
end

lsp_signature.setup {
  debug = false,
  log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- default is  ~/.cache/nvim/lsp_signature.log

  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
  -- set to 0 if you DO NOT want any API comments be shown
  -- This setting only take effect in insert mode, it does not affect signature help in normal
  -- mode, 10 by default

  floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
  floating_window_above_cur_line = true, -- set to false will use whichever side has more space
  floating_window_off_x = 1, -- adjust float windows x position.
  floating_window_off_y = 1, -- adjust float windows y position.
  fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
  hint_prefix = "🐼 ",
}
