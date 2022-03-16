local M = {}

M.setup = function()
  require("nvim-tree").setup({
     disable_netrw = true,
     actions = {
       open_file = {
         quit_on_open = true,
       },
     },
  })
end

return M

