-- UI Module aggregator - consolidates all UI configurations
local diagnostics = {}

local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify(string.format("Error loading UI module %s: %s", mod, err), vim.log.levels.WARN)
    table.insert(diagnostics, {mod=mod, err=err})
  end
  return ok
end

-- Load all UI modules
local ui_modules = {
  'profile.ui.theme',
  'profile.ui.statusline',
  'profile.ui.neotree',
  'profile.ui.toggleterm',
  'profile.ui.notifications',
  'profile.ui.focus',
  'profile.ui.transparency',
  'profile.ui.diagnostics',
  'profile.ui.undotree',
  'profile.ui.enhancements',
}

for _, mod in ipairs(ui_modules) do
  safe_require(mod)
end

-- Setup modules that require explicit setup
pcall(function() require('profile.ui.theme').setup() end)
pcall(function() require('profile.ui.statusline').setup() end)
pcall(function() require('profile.ui.neotree').setup() end)
pcall(function() require('profile.ui.notifications').setup() end)
pcall(function() require('profile.ui.focus').setup() end)
pcall(function() require('profile.ui.transparency').setup() end)
pcall(function() require('profile.ui.diagnostics').setup() end)
pcall(function() require('profile.ui.enhancements').setup() end)

-- Report any loading errors
if #diagnostics > 0 then
  local f = io.open(vim.fn.stdpath('config')..'/ui-errors.log', 'w')
  if f then
    for _, d in ipairs(diagnostics) do
      f:write(string.format('Module: %s\nError: %s\n\n', d.mod, d.err))
    end
    f:close()
  end
end