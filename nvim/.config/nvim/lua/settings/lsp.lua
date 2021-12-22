local M = {}

M.setup = function()
  local lsp_config = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util.default_config, {
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
  })

  metals_config = require("metals").bare_config()

  metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = type,
  }

  metals_config.init_options.statusBarProvider = "on"
  metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  lsp_config.html.setup({})
  lsp_config.jsonls.setup({})
  lsp_config.tsserver.setup({})
  lsp_config.yamlls.setup({})
end

return M
