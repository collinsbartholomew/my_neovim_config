-- Main profile aggregator

local diagnostics = {}

local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify(string.format("Error loading %s: %s", mod, err), vim.log.levels.WARN)
    table.insert(diagnostics, {mod=mod, err=err})
  end
  return ok
end

-- Core modules
safe_require('profile.core.options')
safe_require('profile.core.keymaps')
safe_require('profile.core.autocmds')
safe_require('profile.core.mason')  -- Ensure Mason loads first
safe_require('profile.core.utils')

-- UI modules - consolidated
safe_require('profile.ui')

-- Plugin manager and core features
safe_require('profile.lazy.plugins')
safe_require('profile.completion.cmp')
safe_require('profile.lsp.lspconfig')
safe_require('profile.dap')
safe_require('profile.null_ls')

-- Language modules
local languages = {
  'ccpp', 'rust', 'go', 'web', 'flutter', 'java',
  'csharp', 'zig', 'asm', 'dbs'
}

for _, lang in ipairs(languages) do
  safe_require('profile.languages.'..lang)
end

-- Report any loading errors
if #diagnostics > 0 then
  local f = io.open(vim.fn.stdpath('config')..'/setup-errors.log', 'w')
  if f then
    for _, d in ipairs(diagnostics) do
      f:write(string.format('Module: %s\nError: %s\n\n', d.mod, d.err))
    end
    f:close()
  end
end