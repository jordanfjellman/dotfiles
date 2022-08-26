local has_github_palette, github_palette = pcall(require, "github-theme.palette.dimmed")
if not has_github_palette then
  return
end

local M = {}

M.colors = function()
  -- https://github.com/projekt0n/github-nvim-theme/blob/main/lua/github-theme/palette/dimmed.lua
  return github_palette()
end

return M
