local M = {}

M.setup = function ()
  local lsp_installer = require("nvim-lsp-installer")

  lsp_installer.on_server_ready(function(server)
      local opts = {}

      require("settings.lsp.servers.nvim-metals").setup()

      if server.name == 'sumneko_lua' then
        local sumneko_lua_opts = require("settings.lsp.servers.sumneko_lua").opts
        opts = vim.tbl_deep_extend("force", sumneko_lua_opts, opts)
      end

      if server.name == 'yamlls' then
        local yamlls_opts = require("settings.lsp.servers.yamlls").opts
        opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
      end

      server:setup(opts)
  end)

end

return M

