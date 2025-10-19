-- Startup Configuration
local M = {}

function M.setup()
	-- Check and install required components
	--	local function ensure_installed()
	--		-- Check for treesitter
	--		local ts_ok, ts = pcall(require, "nvim-treesitter.parsers")
	--		if ts_ok then
	--			local parsers = { "jsx", "typescript", "tsx", "javascript", "lua" }
	--			for _, parser in ipairs(parsers) do
	--				if not ts.has_parser(parser) then
	--					vim.cmd("TSInstall " .. parser)
	--				end
	--			end
	--		end
	--
	-- Check for mason packages
	--		local mason_ok, registry = pcall(require, "mason-registry")
	--		if mason_ok then
	--			local packages = { "ts-ls", "lua-language-server", "typescript-language-server" }
	--			for _, pkg_name in ipairs(packages) do
	--				local pkg = registry.get_package(pkg_name)
	--				if not pkg:is_installed() then
	--					pkg:install()
	--				end
	--			end
	--		end
	--	end

	-- Schedule the installation check to run after startup
	vim.schedule(function()
		pcall(ensure_installed)
	end)

	-- Startup optimizations and configurations

	-- Set FZF to load lazily
	vim.g.fzf_loading = 0 -- Prevent automatic loading
	vim.cmd([[
	  command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)
	  command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
	]])

	-- Plugin loading settings
	vim.g.matchup_enabled = 0 -- Disable matchup until needed
	vim.g.loaded_matchit = 1 -- Disable built-in matchit
	vim.g.loaded_remote_plugins = 1 -- Disable remote plugins
	vim.g.loaded_python_provider = 0 -- Disable Python 2 provider
	vim.g.python3_host_prog = "" -- Don't set Python path unless needed

	-- Performance tweaks
	vim.opt.shadafile = "NONE" -- Disable shada file during startup
	vim.opt.showtabline = 1 -- Show tabline only when needed
	vim.opt.ruler = false -- Disable ruler during startup
	vim.opt.cursorline = false -- Disable cursorline initially

	-- Defer heavy UI operations
	vim.schedule(function()
		vim.opt.ruler = true
		vim.opt.cursorline = true
		vim.g.matchup_enabled = 1
	end)
end

return M
