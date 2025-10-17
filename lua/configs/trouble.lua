-- Shim forwarding to configs.ui.trouble
local ok, mod = pcall(require, 'configs.ui.trouble')
if not ok then
  vim.notify('configs.trouble shim: target configs.ui.trouble not found', vim.log.levels.WARN)
  return {}
end
return mod

