return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		priority = 1000,
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				ensure_installed = {
					-- LSP
					"lua-language-server",
					"typescript-language-server",
					"css-lsp",
					"html-lsp",
					"json-lsp",
					"gopls",
					"pyright",
					"rust-analyzer",

					-- Linters
					"eslint_d",
					"luacheck",
					"shellcheck",
					"pylint",

					-- Formatters
					"prettier",
					"stylua",
					"black",
					"rustfmt",
					"gofmt",

					-- Debug Adapters
					"js-debug-adapter",
					"codelldb",
					"debugpy",
				},
				automatic_installation = true,
				max_concurrent_installers = 4,
			})

			-- Clean up orphaned packages
			local registry = require("mason-registry")
			local installed = registry.get_installed_packages()
			local installed_names = {}
			for _, pkg in ipairs(installed) do
				installed_names[pkg.name] = true
			end

			-- Remove packages that aren't in our ensure_installed list
		end,
	},
	-- Add treesitter configuration
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"go",
				"javascript",
				"typescript",
				"tsx",
				"lua",
				"python",
				"rust",
				"yaml",
				"json",
				"html",
				"css",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-s>",
					node_decremental = "<C-backspace>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
