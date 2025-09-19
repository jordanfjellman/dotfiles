return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>og", vim.cmd.Git, { desc = "[O]pen [G]it" })

      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("fjellyvim-fugitive", {}),
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git("push")
          end, { buffer = true, desc = "Git [P]ush" })

          -- rebase always
          vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({ "pull", "--rebase" })
          end, { buffer = true, desc = "Git [P]ull" })

          -- NOTE: It allows me to easily set the branch i am pushing and any tracking
          -- needed if i did not set the branch up correctly
          vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { buffer = true, desc = "Git [T]rack" })
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- 'signs.topdelete.linehl' is now deprecated, please define highlight 'GitSignsTopdeleteLn' e.g:
      --   vim.api.nvim_set_hl(0, 'GitSignsTopdeleteLn', { link = 'GitSignsDeleteLn' })
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
        },
        preview_config = {
          -- Options passed to nvim_open_win
          border = "none",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, { desc = "Next [C]hange" })

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, { desc = "Previous [C]hange" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "[H]unk [S]tage" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "[H]unk [R]eset" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "[H]unk [S]tage" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "[H]unk [R]eset" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "[H]unk [S]tage Entire Buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[H]unk [U]ndo" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "[H]unk [R]eset Entire Buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "[H]unk [P]review" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "[H]unk [B]lame" })
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted, { desc = "[T]oggle [D]eleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
}
