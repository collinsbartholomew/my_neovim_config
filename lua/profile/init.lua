-- Main profile aggregator
local diagnostics = {}
local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then table.insert(diagnostics, {mod=mod, err=err}) end
end
-- Core modules
safe_require('profile.core.options')
safe_require('profile.core.keymaps')
safe_require('profile.core.autocmds')
safe_require('profile.core.utils')
-- UI modules
safe_require('profile.ui.theme')
safe_require('profile.ui.statusline')
safe_require('profile.ui.transparency')
-- Plugin manager
safe_require('profile.lazy.plugins')
-- Completion, LSP, DAP, Null-ls
safe_require('profile.completion.cmp')
safe_require('profile.lsp.lspconfig')
safe_require('profile.dap')
safe_require('profile.null_ls')
-- Language modules
for _, lang in ipairs({'cpp', 'rust', 'go', 'web', 'flutter', 'java', 'csharp', 'zig', 'asm', 'dbs'}) do
  safe_require('profile.languages.'..lang..'.init')
end
-- Diagnostics report
if #diagnostics > 0 then
  local f = io.open(vim.fn.stdpath('config')..'/setup-errors.log', 'w')
  for _, d in ipairs(diagnostics) do
    f:write(string.format('Module: %s\nError: %s\n', d.mod, d.err))
  end
  f:close()
end

