-- Safe helper to install/check formatter binaries referenced by configs.tools.formatting
local M = {}

local function safe_require(name)
  local ok, mod = pcall(require, name)
  if not ok then return nil end
  return mod
end

local function unique(tbl)
  local s = {}
  for _, v in ipairs(tbl) do s[v] = true end
  local out = {}
  for k, _ in pairs(s) do table.insert(out, k) end
  table.sort(out)
  return out
end

local function gather_formatters()
  local fmt_mod = safe_require('configs.tools.formatting')
  if not fmt_mod then return {} end
  local fmt_map = fmt_mod.formatters_by_ft or {}
  local names = {}
  for _, v in pairs(fmt_map) do
    for _, name in ipairs(v) do table.insert(names, name) end
  end
  -- Also include any named formatters in fmt_mod.formatters
  if type(fmt_mod.formatters) == 'table' then
    for name, _ in pairs(fmt_mod.formatters) do table.insert(names, name) end
  end
  return unique(names)
end

function M.setup()
  -- No-op setup; existence allows user to call commands below
  return true
end

vim.api.nvim_create_user_command('MasonInstallFormatters', function()
  local mason = safe_require('mason')
  local reg = safe_require('mason-registry')
  if not mason or not reg then
    vim.notify('Mason or mason-registry is not available', vim.log.levels.ERROR)
    return
  end
  local formatters = gather_formatters()
  if #formatters == 0 then
    vim.notify('No formatters detected in configs.tools.formatting', vim.log.levels.INFO)
    return
  end
  local installed = {}
  for _, name in ipairs(formatters) do
    local ok, pkg = pcall(reg.get_package, name)
    if not ok or not pkg then
      vim.notify('Mason package not found for ' .. name, vim.log.levels.WARN)
    else
      if not pkg:is_installed() then
        vim.notify('Installing formatter: ' .. name, vim.log.levels.INFO)
        local ok_install = pcall(function() pkg:install() end)
        if ok_install then table.insert(installed, name) else vim.notify('Failed to install ' .. name, vim.log.levels.WARN) end
      end
    end
  end
  if #installed > 0 then
    vim.notify('Installed: ' .. table.concat(installed, ', '), vim.log.levels.INFO)
  else
    vim.notify('No new formatters installed', vim.log.levels.INFO)
  end
end, { desc = 'Install formatters referenced by configs.tools.formatting via Mason' })

vim.api.nvim_create_user_command('MasonFormattersCheck', function()
  local reg = safe_require('mason-registry')
  if not reg then
    vim.notify('mason-registry not available', vim.log.levels.ERROR)
    return
  end
  local formatters = gather_formatters()
  local missing = {}
  for _, name in ipairs(formatters) do
    local ok, pkg = pcall(reg.get_package, name)
    if ok and pkg then
      if not pkg:is_installed() then table.insert(missing, name) end
    else
      table.insert(missing, name)
    end
  end
  if #missing > 0 then
    vim.notify('Missing formatters: ' .. table.concat(missing, ', ') .. '\nRun :MasonInstallFormatters to install', vim.log.levels.WARN)
  else
    vim.notify('All referenced formatters appear installed', vim.log.levels.INFO)
  end
end, { desc = 'Check formatters referenced in configs.tools.formatting' })

return M

