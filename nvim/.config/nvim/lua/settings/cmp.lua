local M = {}

M.setup = function()
    local cmp = require("cmp")
    cmp.setup({
        sources = {{
            name = "nvim_lsp"
        }, {
            name = "vsnip"
        }},
        snippet = {
            expand = function(args)
                fn["vsnip#anonymous"](args.body)
            end
        },
        mapping = {
            -- WARNING:
            -- You can't have select = true here _unless_ you are also using snippets.
            -- Keep in mind that if you remove snippets you need to remove this select.
            ["<CR>"] = cmp.mapping.confirm({
                select = true
            }),
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
            end
        }
    })
end

return M
