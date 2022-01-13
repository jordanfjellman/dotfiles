local M = {}

M.setup = function ()
  local actions = require("telescope.actions")
  require("telescope").setup({
    defaults = {
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      layout_strategy = "vertical",
      mappings = {
        n = {
          ["f"] = actions.send_to_qflist,
        },
      },
      prompt_prefix = "❯",
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    }
  })

  require("telescope").load_extension("fzy_native")
  require("telescope").load_extension("harpoon")
end

-- This is mainly for Metals since we don't respond to "" as a query to get all
-- the symbols. This will first get the input form the user and then execute
-- the query.
M.lsp_workspace_symbols = function()
  local input = vim.fn.input("Query: ")
  vim.api.nvim_command("normal :esc<CR>")
  if not input or #input == 0 then
    return
  end
  require("telescope.builtin").lsp_workspace_symbols({ query = input })
end

return M
