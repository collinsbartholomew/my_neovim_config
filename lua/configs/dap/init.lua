-- Modular DAP configuration loader
-- This file wires together all smaller DAP modules to avoid overloading a single file
-- and to keep the configuration consistent and discoverable.

local ok, dap = pcall(require, 'dap')
if not ok then
	vim.notify('DAP not available: ' .. tostring(dap), vim.log.levels.WARN)
	return {}
end

-- Global defaults that should be set once
-- Keep this minimal; language specifics live in their own modules.
dap.defaults.fallback.exception_breakpoints = { 'raised', 'uncaught' }

-- Visuals/signs
pcall(require, 'configs.dap.signs')

-- Adapters (debug servers/bridges)
pcall(require, 'configs.dap.adapters')

-- Per-language configurations (consolidated into a single module)
pcall(require, 'configs.dap.languages')

-- js-debug helper (js debugging via vscode-js)
pcall(require, 'configs.dap.js_debug')

-- Keymaps
pcall(require, 'configs.dap.keymaps')

-- Installers/helpers
pcall(require, 'configs.dap.installers')

-- Pretty printers and debug helpers
pcall(require, 'configs.dap.printers')

return {}
