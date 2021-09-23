local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')

-- Align Github-flavored markdown tables
cmd 'au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>'

