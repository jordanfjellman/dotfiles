return {
  "mrcjkb/rustaceanvim",
  version = "^4", -- Recommended
  ft = { "rust" },
  dependencies = {
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

    local cfg = require("rustaceanvim.config")
    vim.g.rustaceanvim = {
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
      server = {
        on_attach = function(_, bufnr)
          -- Hover actions
          vim.keymap.set("n", "<leader>E", function()
            vim.cmd.RustLsp("explainError")
          end, { buffer = bufnr })
        end,
      },
      settings = {
        ["rust-analyzer"] = {
          ["rust-analyzer.check.overrideCommand"] = {
            "cargo",
            "component",
            "check",
            "--workspace",
            "--all-targets",
            "--message-format=json",
          },
        },
      },
      tools = {
        hover_actions = {
          auto_focus = true,
          border = "none",
        },
      },
    }
  end,
}
