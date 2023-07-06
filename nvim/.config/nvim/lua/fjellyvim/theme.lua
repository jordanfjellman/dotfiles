local M = {}

M.setup = function()
  local has_theme, theme = pcall(require, "github-theme")
  if not has_theme then
    return
  end
  theme.setup({
    darken = {
      floats = true,
    }
  })

  vim.cmd('colorscheme github_dark_dimmed')

  local has_lualine, lualine = pcall(require, "lualine")
  if has_lualine then
    lualine.setup({
      options = {
        theme = "auto"
      }
    })
  end
end

M.colors = function()
  local has_github_palette, github_palette = pcall(require, "github-theme.palette")
  if not has_github_palette then
    return
  end
  -- https://github.com/projekt0n/github-nvim-theme/blob/main/lua/github-theme/palette/dimmed.lua
  return github_palette.load("github_dark_dimmed")
end

return M
