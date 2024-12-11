local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local make_entry = require("telescope.make_entry")
local sorters = require("telescope.sorters")

local log = require("plenary.log"):new()
log.level = "debug"

local M = {}

M.live_dirgrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end
      local parts = vim.split(prompt, "  ") -- two spaces for quick typing
      local args = { "rg" }

      if parts[1] then
        table.insert(args, "--glob")
        table.insert(args, "**/" .. parts[1] .. "/**")
      end

      if parts[2] then
        table.insert(args, "--regexp")
        table.insert(args, parts[2])
      end

      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten({
        args,
        {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      })
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Grep in Directory",
      finder = finder,
      previewer = config.grep_previewer(opts),
      sorter = sorters.empty(), -- sorted automatically by rg
    })
    :find()
end

M.setup = function()
  vim.keymap.set("n", "<leader>sd", M.live_dirgrep, { desc = "[S]earch within [D]irectory Glob" })
end

return M
