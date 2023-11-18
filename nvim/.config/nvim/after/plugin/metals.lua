----------------------------
-- Metals
-- Language server for Scala
----------------------------
local has_metals, metals = pcall(require, "metals")
if not has_metals then
  return
end

local metals_group = vim.api.nvim_create_augroup("CustomMetals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = metals_group,
  callback = function()
    metals.initialize_or_attach(Metals_config)
  end,
  pattern = { "scala", "sbt", "java" },
})

Metals_config = metals.bare_config()
Metals_config.init_options.statusBarProvider = "on"
Metals_config.settings = {
  serverVersion = "1.0.1",
  showImplicitArguments = true,
  showInferredType = true,
}
Metals_config.on_attach = function(_, bufnr)
  local metals_lsp_group = vim.api.nvim_create_augroup("CustomMetalsLsp", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = metals_lsp_group,
    callback = vim.lsp.buf.format,
    pattern = { "scala", "sbt", "java" },
  })
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
    group = metals_lsp_group,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
    group = metals_lsp_group,
  })
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
    group = metals_lsp_group,
  })
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

-- autocompletion
-- warn: potential race condition with cmp configuration?
-- todo: look into race condition
local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
if not has_cmp then
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
Metals_config.capabilities = cmp.default_capabilities(capabilities)

vim.keymap.set("v", "K", function() metals.type_of_range() end)
vim.keymap.set("n", "<leader>ws", function() metals.hover_worksheet() end)
