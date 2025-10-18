-- core init: load core modules
require("core.options")
require("core.keymaps")  -- Comprehensive keymaps
require("core.autocmds")
require("core.diagnostics")
require("core.biome-diagnostics")
require("core.debug-diagnostics")
require("core.startup").setup()

-- Run consolidated small configs (non-blocking)
pcall(function()
    local ok, merged = pcall(require, 'configs.merged')
    if ok and merged and type(merged.setup) == 'function' then
        pcall(merged.setup)
    end
end)

-- Qt/QML integration (merged into main config): register filetype autocommands and keymaps
pcall(function()
	local ok, qt_autocmds = pcall(require, 'configs.qt.autocmds')
	if ok and qt_autocmds and qt_autocmds.setup then
		qt_autocmds.setup()
	end
end)
pcall(function()
	local ok, qt_keymaps = pcall(require, 'configs.qt.keymaps')
	if ok and qt_keymaps and qt_keymaps.setup then
		qt_keymaps.setup()
	end
end)
-- Treesitter/QML hints (non-blocking)
pcall(function()
	local ok, qt_ts = pcall(require, 'configs.qt.treesitter')
	if ok and qt_ts and qt_ts.setup then
		qt_ts.setup()
	end
end)
-- Qt debug helpers (lightweight; core DAP remains authoritative)
pcall(function()
	local ok, qt_debug = pcall(require, 'configs.qt.debug')
	if ok and qt_debug and qt_debug.setup then
		qt_debug.setup()
	end
end)

-- Memory-safety helpers (registers FileType autocmds for C/C++)
pcall(function()
	local ok, memsafe = pcall(require, 'configs.memsafe')
	if ok and memsafe and memsafe.setup then
		memsafe.setup()
	end
end)

-- Tools and LSP: mason, formatting, and unified LSP setup (all non-blocking)
pcall(function()
	pcall(require, 'configs.tools.mason')
end)
pcall(function()
	pcall(require, 'configs.tools.formatting')
end)
pcall(function()
	-- Do not call `ui.setup()` here: plugin configurations will initialize UI modules
	-- individually (this avoids double-setup and duplicate UI instances such as
	-- neo-tree opening twice on startup).
	-- local ok, ui = pcall(require, 'ui')
	-- if ok and ui and type(ui.setup) == 'function' then
	-- 	pcall(ui.setup)
	-- end
end)
pcall(function()
	local ok, lsp_setup = pcall(require, 'core.lsp_setup')
	if ok and lsp_setup and type(lsp_setup.setup) == 'function' then
		pcall(lsp_setup.setup)
	end
end)
