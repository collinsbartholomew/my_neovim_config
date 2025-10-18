-- /home/collins/.config/nvim/init.lua
-- Performance optimizations (guarded for older Neovim versions)
pcall(function() vim.loader.enable() end)

-- Disable unused providers early
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
-- Set python3 host only if it exists to avoid hard failing on systems without python3
local py3 = vim.fn.exepath("python3")
if py3 ~= "" then
    vim.g.python3_host_prog = py3
end

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Initialize theme variable
_G.current_theme = "rose-pine"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Use vim.loop.fs_stat for robust stat check
local stat_ok, stat = pcall(function() return vim.loop.fs_stat(lazypath) end)
if not (stat_ok and stat) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Failed to clone lazy.nvim: " .. out)
		return
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim BEFORE loading core so plugins are available to core modules
require("lazy").setup("plugins", {
	defaults = { lazy = true },
	install = { colorscheme = { "rose-pine" } },
	checker = { enabled = false },
	change_detection = { notify = false },
	performance = {
		cache = { enabled = true },
		reset_packpath = true,
		rtp = {
			reset = true,
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- Load core configuration (after plugins are set up)
require("core")
