local M = {}

M.setup = function()
  require("scrollbar").setup({
    handle = {
      color = "#636e7b" -- from github_dimmed theme
    }
  })
  require("scrollbar.handlers.search").setup()
end

return M

