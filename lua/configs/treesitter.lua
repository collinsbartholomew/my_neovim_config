local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not ok then
	vim.notify("nvim-treesitter not available", vim.log.levels.WARN)
	return
end

treesitter_configs.setup({
	ensure_installed = {
		"lua",
		"python",
		"javascript",
		"typescript",
		"html",
		"css",
		"json",
		"yaml",
		"bash",
		"markdown",
		"rust",
		"go",
		"java",
		"c",
		"cpp",
		"dart",
		"vim",
		"vimdoc",
		"regex",
		"asm",
	},
	sync_install = false,
	auto_install = true,
	ignore_install = {}, -- List of parsers to ignore installing
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		-- Disable for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	indent = {
		enable = true,
		-- Disable for problematic languages
		disable = { "yaml", "python" },
	},
	-- Add incremental selection
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
})

