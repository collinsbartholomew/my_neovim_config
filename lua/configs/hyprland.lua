-- Shim forwarding to configs.lang.hyprland
local ok, mod = pcall(require, 'configs.lang.hyprland')
if not ok then
  vim.notify('configs.hyprland shim: target configs.lang.hyprland not found', vim.log.levels.WARN)
  return {}
end
return mod

