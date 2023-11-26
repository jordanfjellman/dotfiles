return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local metals = require("metals")

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
      serverVersion = "1.1.0",
      showImplicitArguments = true,
      showInferredType = true,
    }

    local function metals_status_handler(_, status, ctx)
      -- https://github.com/scalameta/nvim-metals/blob/main/lua/metals/status.lua#L36-L50
      local val = {}
      if status.hide then
        val = { kind = "end" }
      elseif status.show then
        val = { kind = "begin", message = status.text }
      elseif status.text then
        val = { kind = "report", message = status.text }
      else
        return
      end
      local info = { client_id = ctx.client_id }
      local msg = { token = "metals", value = val }
      -- call fidget progress handler
      vim.lsp.handlers["$/progress"](nil, msg, info)
    end

    local handlers = {}
    handlers["metals/status"] = metals_status_handler
    Metals_config.handlers = handlers

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
      local has_dap, dap = pcall(require, "dap")
      if has_dap then
        dap.configurations.scala = {
          {
            type = "scala",
            request = "launch",
            name = "RunOrTest",
            metals = {
              runType = "runOrTestFile",
              --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
          },
          {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
              runType = "testTarget",
            },
          },
        }
      end
      metals.setup_dap()
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

    vim.keymap.set("v", "K", function()
      metals.type_of_range()
    end)
    vim.keymap.set("n", "<leader>ws", function()
      metals.hover_worksheet()
    end)
  end,
}
