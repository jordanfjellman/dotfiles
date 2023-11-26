return {
  "simrat39/rust-tools.nvim",
  ft = "rust",
  dependencies = {
    "neovim/nvim-lspconfig",

    -- required for debugging
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
  config = function()
    local codelldb = require("mason-registry").get_package("codelldb")
    local extension_path = codelldb:get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

    local rust_tools = require("rust-tools")
    rust_tools.setup({
      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
      },
      server = {
        on_attach = function(_, bufnr)
          -- Hover actions
          vim.keymap.set("n", "<Leader>k", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
        end,
      },
      tools = {
        hover_actions = {
          auto_focus = true,
          border = "none",
        },
      },
    })
  end,
}
