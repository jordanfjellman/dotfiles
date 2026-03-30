-- Neovim 0.12+ ships a built-in :Undotree command
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Toggle [U]ndotree" })
return {}
