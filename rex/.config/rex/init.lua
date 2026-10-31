rex.bind("alt+shift+n", "session.next")
rex.bind("alt+shift+p", "session.previous")
rex.bind("alt+shift+]", "session.next")
rex.bind("alt+shift+[", "session.previous")

rex.bind("alt+c", "client.tab.new")
rex.bind("alt+t", "client.tab.new")
rex.bind("alt+n", "client.tab.next")
rex.bind("alt+p", "client.tab.previous")
rex.bind("alt+]", "client.tab.next")
rex.bind("alt+[", "client.tab.previous")

rex.bind("alt+d", "pane.close")
rex.bind("alt+w", "pane.close")

rex.bind("ctrl+h", "pane.focus.left")
rex.bind("ctrl+j", "pane.focus.down")
rex.bind("ctrl+k", "pane.focus.up")
rex.bind("ctrl+l", "pane.focus.right")

rex.bind("ctrl+b>s", "pane.split.down")
rex.bind("ctrl+b>v", "pane.split.right")
rex.bind("ctrl+b>ctrl+l", "pane.send_key", { key = "ctrl+l" })
rex.bind("ctrl+b>shift+4", "pane.move_to_new_tab")
rex.bind("ctrl+b>r", "client.config.reload")

local home = os.getenv("HOME")
local shell = "com.superlogical.terminal.shell"

-- Matches tmux-sessionizer, so a directory maps to
-- the same session name under every multiplexer.
local function session_name(dir)
  local parent, base = dir:match("^(.*)/([^/]+)/?$")
  local name = base
  if rex.exec({ "test", "-d", parent .. "/.bare" }).ok then
    name = parent:match("([^/]+)$") .. "/" .. base
  end
  return (name:gsub("[ .]", "_"))
end

rex.action{
  name  = "sessionizer",
  title = "Open Session for Directory",
  args  = { path = "string" },
  run   = function(ctx, args)
    local dir = args.path:gsub("^~", home)
    local name = session_name(dir)
    local id
    for _, s in ipairs(rex.call("session.list").sessions or {}) do
      if s.label == name then
        id = s.session_id
        break
      end
    end
    if not id then
      local created, err = rex.call("session.create", {
        label = name,
        initial_windows = {
          { layout = rex.layout.block{ flavor = shell, options = { cwd = dir } } },
        },
      })
      if not created then
        error(err)
      end
      id = created.session_id
    end
    rex.client.queue("session.select", { session_id = id })
  end,
}

local function popup(command)
  return function(ctx)
    local argv = type(command) == "function" and command(ctx) or { command }
    rex.session.new_layer{
      bounds = { 0, 0.25, 1, 0.5 },
      focus  = true,
      layout = rex.layout.block{ flavor = shell, options = { command = argv } },
    }
    return true
  end
end

rex.bind("ctrl+b>t", popup("code-sessionizer"))
rex.bind("ctrl+b>shift+t", popup("note-sessionizer"))
rex.bind("ctrl+b>u", popup(function(ctx) return { "rex-urls", ctx.block_id } end))
rex.bind("ctrl+b>shift+u", popup(function(ctx) return { "rex-urls", ctx.block_id, "--scrollback" } end))
rex.bind("ctrl+b>n", "sessionizer", { path = "~/notes" })
rex.bind("ctrl+b>m", "sessionizer", { path = "~/agent-memory" })
rex.bind("ctrl+b>i", "sessionizer", { path = "~/lifewayit" })
