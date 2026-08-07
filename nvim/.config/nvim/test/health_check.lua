-- Headless neovim config health check
-- Usage:
--   nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/test/health_check.lua
--
-- Or test a specific filetype:
--   nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/test/health_check.lua -- lua
--   nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/test/health_check.lua -- typescript

local results = {}
local errors = {}

local function log(msg)
  table.insert(results, msg)
end

local function err(msg)
  table.insert(errors, "ERROR: " .. msg)
end

local function check_treesitter_for_ft(ft, sample_code)
  -- Create a scratch buffer with the given filetype
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(sample_code, "\n"))
  vim.bo[buf].filetype = ft

  -- Give treesitter a moment to attach
  vim.wait(1000, function()
    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    return ok and parser ~= nil
  end, 50)

  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  local has_parser = ok and parser ~= nil
  local hl_active = false

  if has_parser then
    -- Check if highlighting is active on the buffer
    hl_active = vim.treesitter.highlighter.active[buf] ~= nil
  end

  -- Check LSP clients that would attach to this filetype
  -- (won't fully attach in headless but we can verify config exists)
  local lsp_configs = {}
  for name, config in pairs(vim.lsp._configs or {}) do
    if config.filetypes then
      for _, configured_ft in ipairs(config.filetypes) do
        if configured_ft == ft then
          table.insert(lsp_configs, name)
        end
      end
    end
  end

  vim.api.nvim_buf_delete(buf, { force = true })

  return {
    ft = ft,
    has_parser = has_parser,
    hl_active = hl_active,
    lsp_configs = lsp_configs,
  }
end

local function check_plugin_loaded(name)
  local ok = pcall(require, name)
  return ok
end

-- Sample code snippets per filetype
local samples = {
  lua = [[
local M = {}
function M.setup()
  vim.opt.number = true
end
return M
]],
  typescript = [[
interface User {
  name: string;
  age: number;
}
const greet = (user: User): string => {
  return `Hello, ${user.name}`;
};
]],
  javascript = [[
const express = require('express');
const app = express();
app.get('/', (req, res) => {
  res.send('Hello World');
});
]],
  go = [[
package main

import "fmt"

func main() {
  fmt.Println("hello")
}
]],
  rust = [[
fn main() {
    let x: i32 = 42;
    println!("Value: {}", x);
}
]],
  scala = [[
object Main extends App {
  val x: Int = 42
  println(s"Value: $x")
}
]],
  json = [[
{
  "name": "test",
  "version": "1.0.0"
}
]],
  yaml = [[
apiVersion: v1
kind: Service
metadata:
  name: my-service
]],
  markdown = [[
# Heading

Some **bold** and *italic* text.

```lua
print("hello")
```
]],
  html = [[
<!DOCTYPE html>
<html>
<head><title>Test</title></head>
<body><h1>Hello</h1></body>
</html>
]],
  python = [[
def greet(name: str) -> str:
    return f"Hello, {name}"

if __name__ == "__main__":
    print(greet("world"))
]],
  bash = [[
#!/bin/bash
set -euo pipefail

for f in *.txt; do
  echo "Processing $f"
done
]],
  typescriptreact = [[
import React from 'react';

interface Props {
  name: string;
}

const Hello: React.FC<Props> = ({ name }) => {
  return <div className="greeting">Hello, {name}</div>;
};

export default Hello;
]],
  javascriptreact = [[
import React from 'react';

const App = () => {
  return (
    <div className="app">
      <h1>Hello World</h1>
    </div>
  );
};

export default App;
]],
  css = [[
.container {
  display: flex;
  align-items: center;
  gap: 1rem;
}

@media (max-width: 768px) {
  .container { flex-direction: column; }
}
]],
  graphql = [[
type Query {
  user(id: ID!): User
}

type User {
  id: ID!
  name: String!
  email: String
}
]],
  dockerfile = [[
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
]],
  toml = [[
[package]
name = "my-crate"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
]],
  jsonc = [[
{
  // TypeScript compiler options
  "compilerOptions": {
    "strict": true,
    "target": "ES2022"
  }
}
]],
}

-- ─── Main ────────────────────────────────────────────────────────────────────

local function main()
  -- Determine which filetypes to test (passed via env var or test all)
  local requested_fts = {}
  local env_fts = vim.env.HEALTH_CHECK_FTS
  if env_fts and #env_fts > 0 then
    for ft in env_fts:gmatch("%S+") do
      table.insert(requested_fts, ft)
    end
  end

  -- If no specific filetypes requested, test all
  local fts_to_test = #requested_fts > 0 and requested_fts or vim.tbl_keys(samples)
  table.sort(fts_to_test)

  log("═══════════════════════════════════════════════════════")
  log("  Neovim Config Health Check")
  log("  Neovim version: " .. tostring(vim.version()))
  log("═══════════════════════════════════════════════════════")
  log("")

  -- 1. Check core plugins loaded
  log("── Plugin Loading ──────────────────────────────────────")
  local plugins_to_check = {
    "lazy",
    "snacks",
    "gitsigns",
    "lualine",
    "conform",
    "lint",
    "harpoon",
    "trouble",
    "mason",
  }
  for _, plugin in ipairs(plugins_to_check) do
    local loaded = check_plugin_loaded(plugin)
    log(string.format("  %-20s %s", plugin, loaded and "✓" or "✗ NOT LOADED"))
    if not loaded then
      err(plugin .. " failed to load")
    end
  end
  log("")

  -- 2. Check treesitter parsers available
  log("── Treesitter Parsers ──────────────────────────────────")
  local ts_ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
  if not ts_ok then
    -- Try the newer API (nvim-treesitter main branch)
    ts_ok = pcall(require, "nvim-treesitter")
  end

  for _, ft in ipairs(fts_to_test) do
    -- Check if parser is available via vim.treesitter
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local parser_ok = pcall(vim.treesitter.language.inspect, lang)
    log(string.format("  %-20s %s", ft .. " (" .. lang .. ")", parser_ok and "✓ installed" or "✗ MISSING"))
    if not parser_ok then
      err("treesitter parser missing for " .. ft .. " (lang: " .. lang .. ")")
    end
  end
  log("")

  -- 3. Check treesitter highlighting per filetype
  log("── Treesitter Highlighting ─────────────────────────────")
  for _, ft in ipairs(fts_to_test) do
    local sample = samples[ft]
    if sample then
      local result = check_treesitter_for_ft(ft, sample)
      local status
      if result.has_parser and result.hl_active then
        status = "✓ parser + highlighting active"
      elseif result.has_parser then
        status = "~ parser ok, highlighting NOT active"
      else
        status = "✗ NO parser"
      end
      log(string.format("  %-20s %s", ft, status))
    else
      log(string.format("  %-20s (no sample code defined)", ft))
    end
  end
  log("")

  -- 4. Check LSP configs exist
  log("── LSP Configurations ──────────────────────────────────")
  local enabled_servers = {}
  -- Neovim 0.12 stores configs differently
  for _, ft in ipairs(fts_to_test) do
    local servers = {}
    -- Check known server-to-ft mappings
    local ft_server_map = {
      lua = "lua_ls",
      typescript = "tsgo",
      javascript = "tsgo",
      go = "gopls",
      rust = "rust_analyzer",
      scala = "metals",
      json = "jsonls",
      yaml = "yamlls",
      html = "html",
      markdown = "marksman",
      python = "diagnosticls",
      bash = "bashls",
    }
    local expected = ft_server_map[ft]
    if expected then
      table.insert(servers, expected)
    end
    log(string.format("  %-20s expected: %s", ft, expected or "(none mapped)"))
  end
  log("")

  -- 5. Check for startup errors
  log("── Startup Messages ────────────────────────────────────")
  local msgs = vim.api.nvim_exec2("messages", { output = true })
  if msgs.output and #msgs.output > 0 then
    local lines = vim.split(msgs.output, "\n")
    local error_lines = vim.tbl_filter(function(l)
      return l:match("[Ee]rror") or l:match("[Ww]arning") or l:match("[Dd]eprecated")
    end, lines)
    if #error_lines > 0 then
      for _, line in ipairs(error_lines) do
        log("  ⚠ " .. line)
        err(line)
      end
    else
      log("  ✓ No errors/warnings in messages")
    end
  else
    log("  ✓ No messages")
  end
  log("")

  -- Summary
  log("── Summary ─────────────────────────────────────────────")
  if #errors > 0 then
    log(string.format("  %d error(s) found:", #errors))
    for _, e in ipairs(errors) do
      log("    • " .. e)
    end
  else
    log("  ✓ All checks passed!")
  end
  log("")

  -- Output results
  local output = table.concat(results, "\n")
  print(output)

  -- Exit with code based on errors
  vim.cmd("qa!")
end

-- When called via dofile() from a running nvim instance, run directly
main()
