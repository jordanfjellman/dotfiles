-- Based on recommendations from https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        print("Found .luarc.json/.luarc.jsonc in workspace folder, skipping global type extensions")
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          -- vim.api.nvim_get_runtime_file("", true),
          -- Add lazy.nvim path where snacks is installed
          vim.env.VIMRUNTIME,
          -- "${3rd}/lazy/lazy.nvim",
          -- "${3rd}/lazy/snacks.nvim",
          "${3rd}/luv/library",
          vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
          vim.fn.stdpath("data") .. "/lazy/quicker.nvim",
          vim.fn.stdpath("data") .. "/lazy/snacks.nvim",
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3188
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      },
    })
  end,
  settings = {
    Lua = {
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
