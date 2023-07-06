local has_scrollbar, scrollbar = pcall(require, "scrollbar")
if not has_scrollbar then
  return
end

local has_theme, theme = pcall(require, "fjellyvim.theme")
if not has_theme then
  return
end

local colors = theme.colors()
if not colors then
  return
end

-- warn: The plugin documentation shows setup parameters
-- todo: Why is there a diagnostic error
---@diagnostic disable-next-line: redundant-parameter
scrollbar.setup {
  handle = {
    color = colors.fg_dark,
  },
}

require("scrollbar.handlers.search").setup()
