local M = {}

function M.setup()
	-- Create treesitter parser install directory if it doesn't exist
	local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
	vim.fn.mkdir(parser_install_dir, "p")

	-- Configure parser installation directory
	vim.opt.runtimepath:append(parser_install_dir)

	-- Force install jsx/tsx parsers
	local install = require("nvim-treesitter.install")
	local parsers = require("nvim-treesitter.parsers")

	-- Ensure parsers are installed synchronously
	install.prefer_git = true
	install.compilers = { "gcc" }

	-- Configure the tsx parser to handle jsx files
	local tsx_config = parsers.get_parser_configs()["tsx"]
	if tsx_config then
		tsx_config.used_by = { "javascript", "typescript.tsx" }
		tsx_config.filetype_to_parsername = {
			["javascript"] = "tsx",
			["typescript"] = "tsx",
			["javascriptreact"] = "tsx",
			["typescriptreact"] = "tsx",
		}
	end

	require("nvim-treesitter.configs").setup({
		auto_install = true,
		sync_install = true,
		ensure_installed = {
			"lua",
			"vim",
			"javascript",
			"typescript",
			"tsx",
			"html",
			"css",
			"json",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		autotag = { enable = true }, -- Enable auto tag closing
	})
end

return M
