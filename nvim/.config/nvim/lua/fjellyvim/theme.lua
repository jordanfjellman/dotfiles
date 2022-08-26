local M = {}

M.setup = function()
  local has_theme, theme = pcall(require, "github-theme")
  if not has_theme then
    return
  end
  theme.setup({
    theme_style = 'dimmed',
    dark_float = true,
  })
end

M.colors = function()
  local has_github_palette, github_palette = pcall(require, "github-theme.palette.dimmed")
  if not has_github_palette then
    return
  end
  -- https://github.com/projekt0n/github-nvim-theme/blob/main/lua/github-theme/palette/dimmed.lua
  return github_palette()
end

return M
