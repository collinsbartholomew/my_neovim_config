-- Aggregated UI configuration loader
-- This module loads and initializes small UI modules (so plugins can require 'configs.ui')
local M = {}
local modules = {
	"colorizer",
	"flash",
	"gitsigns",
	"neotree",
	"telescope",
	"statusline",
	"toggleterm",
	"trouble",
	"rose-pine",
}

for _, name in ipairs(modules) do
	local ok, mod = pcall(require, "configs.ui." .. name)
	if ok and mod then
		-- If module exposes setup(), call it
		if type(mod) == "table" and type(mod.setup) == "function" then
			pcall(mod.setup)
		elseif type(mod) == "function" then
			pcall(mod)
		end
		M[name] = mod
	else
		-- keep nil but don't error on missing optional UI pieces
		M[name] = nil
	end
end

return M

