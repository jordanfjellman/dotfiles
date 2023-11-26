local M = {}

local set_filetype_for_conf_files = function()
  -- define '*.conf' files as the hocon filetype
  local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
  vim.api.nvim_create_autocmd(
    { "BufNewFile", "BufRead" },
    { group = hocon_group, pattern = "*.conf", command = "set ft=hocon" }
  )
end

M.setup = function()
  set_filetype_for_conf_files()
end

return M

