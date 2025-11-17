return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function() return vim.fn.executable("make") == 1 end,
    },
    { "ThePrimeagen/harpoon" },
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    local telescope = require("telescope")
    local previewers = require("telescope.previewers")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { ".git/", ".bloop/", ".metals/", ".yarn/", "target/", "samples/" },
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

    local builtin = require("telescope.builtin")

    vim.keymap.set(
      "n",
      "<leader>sf",
      function() builtin.find_files({ hidden = true }) end,
      { desc = "[S]earch [F]iles" }
    )

    vim.keymap.set(
      "n",
      "<leader>mc",
      function() telescope.extensions.metals.commands() end,
      { desc = "Preview [M]etals [C]ommands" }
    )

    require("fjellyvim.telescope.gh").setup()
    require("fjellyvim.telescope.dirgrep").setup()
  end,
}
