-- Aggregated tools configuration loader
-- This module loads and initializes small tool modules (so plugins can require 'configs.tools')
local M = {}
local modules = {
	"mason",
	"formatting",
}

for _, name in ipairs(modules) do
	local ok, mod = pcall(require, "configs.tools." .. name)
	if ok and mod then
		if type(mod) == "table" and type(mod.setup) == "function" then
			pcall(mod.setup)
		elseif type(mod) == "function" then
			pcall(mod)
		end
		M[name] = mod
	else
		M[name] = nil
	end
end

return M

