return {
  {
    "hrsh7th/cmp-nvim-lsp", -- you also need to setup the completions for the lsp servers
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    run = "make install_jsregexp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function() end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-path" },
    },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      }

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        enabled = function()
          -- disable completion in comments
          local context = require("cmp.config.context")
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
              buffer = "[Buffer]",
              latex_symbols = "[LaTeX]",
              luasnip = "[LuaSnip]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              vsnip = "[VSnip]",
            })[entry.source.name]
            return vim_item
          end,
        },
        mapping = {
          -- WARNING:
          -- You can't have select = true here _unless_ you are also using snippets.
          -- Keep in mind that if you remove snippets you need to remove this select.
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            local copilot_keys = vim.fn["copilot#Accept"]()
            if cmp.visible() then
              cmp.select_next_item()
            elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
              vim.api.nvim_feedkeys(copilot_keys, "n", true)
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-E>"] = cmp.mapping.abort(),
        },
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            entry_filter = function(entry)
              return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
          },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
        }, {
          { name = "buffer", keyword_length = 5 },
        }),
        view = {
          entries = "custom", -- can be "custom", "wildmenu" or "native"
        },
      })

      local ls = require("luasnip")

      vim.keymap.set({ "i" }, "<C-K>", function()
        ls.expand()
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-L>", function()
        ls.jump(1)
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-J>", function()
        ls.jump(-1)
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline", keyword_length = 2 }, -- prevent cmp for single character commands like :w
        }),
      })
    end,
  },
}
