local has_scrollbar, scrollbar = pcall(require, "scrollbar")
if not has_scrollbar then
  return
end

local colors = require("fjellyvim.theme").colors()

-- warn: The plugin documentation shows setup parameters
-- todo: Why is there a diagnostic error
---@diagnostic disable-next-line: redundant-parameter
scrollbar.setup {
  handle = {
    color = colors.fg_dark,
  },
}

require("scrollbar.handlers.search").setup()
