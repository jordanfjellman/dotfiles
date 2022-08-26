----------------------------
-- Metals
-- Language server for Scala
----------------------------
local has_metals, metals = pcall(require, "metals")
if not has_metals then
  return
end

vim.cmd([[augroup lsp]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
vim.cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)]])
vim.cmd([[augroup end]])

Metals_config = metals.bare_config()
Metals_config.init_options.statusBarProvider = "on"
Metals_config.settings = {
  serverVersion = "0.11.8",
  showImplicitArguments = true,
  showInferredType = true,
}
Metals_config.on_attach = function(_, _)
  vim.cmd([[
    augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    augroup END
  ]])

  vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
  vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
  vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])
end

-- autocompletion
-- warn: potential race condition with cmp configuration?
-- todo: look into race condition
local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
if not has_cmp then
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
Metals_config.capabilities = cmp.update_capabilities(capabilities)
