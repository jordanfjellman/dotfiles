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
  },
  config = function()
    local telescope = require("telescope")
    local previewers = require("telescope.previewers")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { ".git/", ".bloop/", ".metals/", ".yarn/", "target/" },
        file_previewer = previewers.vim_buffer_cat.new,
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        layout_strategy = "vertical",
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

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>sf", function()
      builtin.find_files({ hidden = true })
    end, { desc = "[S]earch [F]iles" })

    vim.keymap.set("n", "<leader>sw", function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end, { desc = "[S]earch [W]ord" })

    vim.keymap.set("n", "<leader>sW", function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = "[S]earch Entire [W]ord" })

    vim.keymap.set("n", "<leader>sg", function()
      builtin.live_grep({
        additional_args = function()
          return { "--hidden" }
        end,
      })
    end, { desc = "[S]earch by [G]rep" })

    vim.keymap.set("n", "<leader>sh", function()
      builtin.help_tags()
    end, { desc = "[S]earch [H]elp" })

    vim.keymap.set("n", "<leader>sk", function()
      builtin.keymaps()
    end, { desc = "[S]earch [K]eymaps" })

    vim.keymap.set("n", "<leader>se", "<CMD>Telescope emoji<CR>", { desc = "[S]earch [E]mojis" })

    vim.keymap.set("n", "<leader>sd", function()
      builtin.git_status()
    end, { desc = "[S]earch Git [D]iffs" })

    vim.keymap.set("n", "<leader>mc", function()
      telescope.extensions.metals.commands()
    end, { desc = "Preview [M]etals [C]ommands" })
  end,
}
