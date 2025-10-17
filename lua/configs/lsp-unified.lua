-- Compatibility shim: expose `configs.lsp-unified` for legacy requires
-- Forwards to `configs.lsp` (the new canonical module).
local ok, mod = pcall(require, 'configs.lsp')
if not ok or not mod then
  vim.notify("configs.lsp module not found (required by configs.lsp-unified)", vim.log.levels.WARN)
  return {}
end
-- If the module has a setup function, call it (protected)
if type(mod.setup) == 'function' then
  pcall(mod.setup)
end
return mod

