local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("telescope.previewers.utils")
local config = require("telescope.config").values

local log = require("plenary.log"):new()
log.level = "debug"

local M = {}

M.show_pull_requests = function(opts)
  pickers
    .new(opts, {
      finder = finders.new_async_job({
        command_generator = function()
          return { "gh", "pr", "list", "--json", "number,title,body", "--jq", ".[]" }
        end,

        entry_maker = function(entry)
          log.debug(entry)
          local parsed = vim.json.decode(entry)
          log.debug(parsed)
          if parsed then
            return {
              value = parsed,
              display = parsed.title,
              ordinal = parsed.title .. " " .. tostring(parsed.number), -- search by title and issue number
            }
          end
        end,
      }),
      sorter = config.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer({
        title = "Pull Request Details",
        define_preview = function(self, entry)
          vim.api.nvim_buf_set_lines(
            self.state.bufnr,
            0,
            0,
            true,
            vim
              .iter({
                "# " .. entry.value.title .. " (#" .. entry.value.number .. ")",
                "",
                vim.split(entry.value.body, "\r\n", { trimempty = true }),
                "```lua",
                vim.split(vim.inspect(entry), "\n"),
                "```",
              })
              :flatten()
              :totable()
          )
          utils.highlighter(self.state.bufnr, "markdown")
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          log.debug("selected", selection)

          local command = {
            "!",
            "gh",
            "pr",
            "view",
            tostring(selection.value.number),
            "--web",
          }
          log.debug("command to run!", command)
          vim.cmd(vim.fn.join(command, " "))
        end)
        return true
      end,
    })
    :find()
end

vim.keymap.set("n", "<Leader>opr", M.show_pull_requests, { desc = "[O]pen [P]ull Requests" })

return M
