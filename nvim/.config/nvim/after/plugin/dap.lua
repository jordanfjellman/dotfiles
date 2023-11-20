local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end

vim.keymap.set("n", "<Leader>dr", function() dap.repl.toggle() end)
vim.keymap.set("n", "<Leader>dl", function() dap.run_last() end)
vim.keymap.set("n", "<leader>dt", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<leader>dc", function() dap.continue() end)
vim.keymap.set("n", "<leader>do", function() dap.step_over() end)
vim.keymap.set("n", "<leader>di", function() dap.step_into() end)
vim.keymap.set("n", "<leader>dx", function() dap.terminate() end)

