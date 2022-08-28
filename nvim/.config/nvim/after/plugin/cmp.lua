local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then
  return
end

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup {
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
    end
  end,
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        buffer = "[Buffer]",
        latex_symbols = "[LaTeX]",
        luasnip = "[LuaSnip]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        vsnip = "[VSnip]",
      })[entry.source.name]
      return vim_item
    end
  },
  mapping = {
    -- WARNING:
    -- You can't have select = true here _unless_ you are also using snippets.
    -- Keep in mind that if you remove snippets you need to remove this select.
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = require("cmp").config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "nvim_lsp_signature_help" },
  }, {
    { name = "buffer", keyword_length = 5 }
  }),
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  view = {
    entries = "custom" -- can be "custom", "wildmenu" or "native"
  }
}
