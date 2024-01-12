return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- todo: ensure make is installed
    -- info: had to run make manually after switching from fzy
    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/47#issuecomment-988353015
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "ThePrimeagen/harpoon" },
    { "xiyaowong/telescope-emoji.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    { "kyazdani42/nvim-web-devicons" },
    { "ThePrimeagen/git-worktree.nvim" },
  },
  config = function()
    local telescope = require("telescope")
    local previewers = require("telescope.previewers")
    -- local previewers = require("telescope.previewers")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { ".git/", ".bloop/", ".metals/", ".yarn/", "target/" },
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
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("harpoon")
    telescope.load_extension("emoji")
    telescope.load_extension("git_worktree")

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<C-p>", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find files with Telescope" })

    vim.keymap.set("n", "<leader>ff", function()
      builtin.git_files({ show_untracked = true })
    end, { desc = "Find tracked files with Telescope" })

    vim.keymap.set("n", "<leader>fw", function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end, { desc = "Grep word under cursor with Telescope" })

    vim.keymap.set("n", "<leader>fW", function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = "Grep entire word under cursor with Telescope" })

    vim.keymap.set("n", "<leader>fs", function()
      builtin.live_grep({
        additional_args = function()
          return { "--hidden" }
        end,
      })
    end, { desc = "Grep search with Telescope" })

    vim.keymap.set("n", "<leader>fh", function()
      builtin.help_tags()
    end, { desc = "List help tags with Telescope" })

    vim.keymap.set("n", "<leader>fk", function()
      builtin.keymaps()
    end, { desc = "List keymaps with Telescope" })

    vim.keymap.set("n", "<leader>fe", "<CMD>Telescope emoji<CR>")

    vim.keymap.set("n", "<leader>fg", function()
      telescope.extensions.git_worktree.git_worktrees()
    end)

    vim.keymap.set("n", "<leader>gs", function()
      builtin.git_status()
    end, { desc = "List files with changes" })

    vim.keymap.set("n", "<leader>mc", function()
      telescope.extensions.metals.commands()
    end, { desc = "List Metals commands" })
  end,
}
