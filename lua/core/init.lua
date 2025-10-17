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
