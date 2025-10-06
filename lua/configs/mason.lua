require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
		border = "rounded",
		width = 0.8,
		height = 0.9,
	},
	install_root_dir = vim.fn.stdpath("data") .. "/mason",
	pip = {
		upgrade_pip = false,
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
	github = {
		download_url_template = "https://github.com/%s/releases/download/%s/%s",
	},
})

-- Create autocmd to install tools in background
vim.api.nvim_create_autocmd("User", {
	pattern = "MasonToolsStartingInstall",
	callback = function()
		vim.schedule(function()
			require("notify")("Installing Mason tools in background...", "info")
		end)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MasonToolsUpdateCompleted",
	callback = function(e)
		vim.schedule(function()
			require("notify")("Mason tools installation completed!", "info")
		end)
	end,
})

