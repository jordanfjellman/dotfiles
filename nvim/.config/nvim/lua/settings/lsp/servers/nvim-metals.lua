local M = {}

M.setup = function()
  local cmd = vim.cmd
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  cmd([[augroup lsp]])
  cmd([[autocmd!]])
  cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
  cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)]])
  cmd([[augroup end]])

  Metals_config = require("metals").bare_config()
  Metals_config.init_options.statusBarProvider = "on"
  Metals_config.settings = {
    serverVersion = "0.11.0",
    showImplicitArguments = true,
    showInferredType = true,
  }
  Metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
  Metals_config.on_attach = function(_, _)
    -- null-ls handles formatting
    -- client.resolved_capabilities.document_formatting = false
    -- client.resolved_capabilities.document_range_formatting = false
    cmd([[
      augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]])

    cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
    cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
    cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])
  end
end

return M

