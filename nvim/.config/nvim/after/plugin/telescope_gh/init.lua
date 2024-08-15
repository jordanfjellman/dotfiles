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
          return { "gh", "pr", "list", "--json", "number,title,body,author", "--jq", ".[]" }
        end,

        entry_maker = function(entry)
          local parsed = vim.json.decode(entry)
          log.debug(parsed)
          if parsed then
            return {
              value = parsed,
              display = "#" .. parsed.number .. "\t| " .. parsed.title,
              ordinal = parsed.title .. " " .. tostring(parsed.number), -- .. " " .. parsed.author.name, -- search by title, issue number, and author name
            }
          end
        end,
      }),
      sorter = config.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer({
        title = "Pull Request Details",
        define_preview = function(self, entry)
          local body = vim.tbl_flatten(vim.split(entry.value.body, "\r\n"))
          local lines_table = {}
          for _, value in ipairs(body) do
            local lines = vim.split(value, "\n")
            table.insert(lines_table, lines)
          end
          vim.api.nvim_buf_set_lines(
            self.state.bufnr,
            0,
            0,
            true,
            vim
              .iter({
                "# " .. entry.value.title .. " (#" .. entry.value.number .. ")",
                "",
                -- "Authored by " .. entry.value.author.name .. " (@" .. entry.value.author.login .. ")",
                "Authored by @" .. entry.value.author.login,
                "---",
                "",
                vim.tbl_flatten(lines_table),
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

vim.keymap.set("n", "<leader>spr", M.show_pull_requests, { desc = "[S]earch [P]ull [R]equests" })

return M
