local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  return
end

local previewers = require("telescope.previewers")
telescope.setup({
  defaults = {
    file_ignore_patterns = { "^.git/" },
    file_previewer = previewers.vim_buffer_cat.new,
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    layout_strategy = "vertical",
    mappings = {
      n = {
        ["f"] = require("telescope.actions").send_to_qflist,
      },
    },
    prompt_prefix = "❯",
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

telescope.load_extension("fzf")
telescope.load_extension("harpoon")
telescope.load_extension("emoji")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function() builtin.find_files({ hidden = true }) end)
vim.keymap.set("n", "<leader>lg", function() builtin.live_grep({ additional_args = function() return { "--hidden" } end }) end)
vim.keymap.set("n", "<leader>fh", function() builtin.help_tags() end)
vim.keymap.set("n", "<leader>fk", function() builtin.keymaps() end)
vim.keymap.set("n", "<leader>gs", function() builtin.git_status() end)
vim.keymap.set("n", "<leader>gs", function() builtin.git_status() end)

vim.keymap.set("n", "<leader>mf", function() telescope.extensions.harpoon.marks() end)
vim.keymap.set("n", "<leader>mc", function() telescope.extensions.metals.commands() end)
vim.keymap.set("n", "<leader>fe", '<CMD>Telescope emoji<CR>')
