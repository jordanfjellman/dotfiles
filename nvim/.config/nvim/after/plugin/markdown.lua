-- expand all folds on open
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function() vim.opt_local.foldlevel = 99 end
})
