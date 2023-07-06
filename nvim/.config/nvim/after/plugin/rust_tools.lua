local has_rust_tools, rust_tools = pcall(require, "rust-tools")
if not has_rust_tools then
  return
end

local codelldb = require("mason-registry").get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

rust_tools.setup({
  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
  },
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>k", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
    end
  },
  tools = {
    hover_actions = {
      auto_focus = true,
      border = "none",
    },
  },
})
