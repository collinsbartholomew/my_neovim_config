-- Shim forwarding to ui.trouble (canonical location)
local ok, mod = pcall(require, 'ui.trouble')
if not ok then
  vim.notify('configs.trouble shim: target ui.trouble not found', vim.log.levels.WARN)
  return {}
end
return mod
