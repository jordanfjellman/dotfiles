return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "1.*", -- release tag pulls the prebuilt fuzzy binary (no Rust toolchain needed)
    dependencies = { "rafamadriz/friendly-snippets" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' preset keeps the nvim-cmp muscle memory: C-n/C-p select,
      -- C-y accept, C-e cancel, C-b/C-f scroll docs, Tab/S-Tab snippet jump.
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        -- <Tab> is blink's snippet-jump key, so accept inline suggestions elsewhere.
        keymaps = { accept_suggestion = "<C-l>" },
      })
    end,
  },
}
