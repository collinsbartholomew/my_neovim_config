return {
	-- Core dependencies for completion and snippets
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},
		config = function()
			require("configs.completion")
		end,
	},

	-- Treesitter for syntax and parsing
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("configs.treesitter")
		end,
	},
	{ -- Auto close/rename HTML/JSX tags
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascriptreact", "typescriptreact", "svelte", "vue", "xml" },
		config = function()
			local ok, autotag = pcall(require, "nvim-ts-autotag")
			if ok then autotag.setup() end
		end,
	},

	-- Colorizer for color previews
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("configs.ui.colorizer")
		end,
	},
	-- Colorschemes
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("configs.ui.rose-pine")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = true,
				terminal_colors = true,
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					functions = {},
					variables = {},
					sidebars = "transparent",
					floats = "transparent",
				},
				sidebars = { "qf", "help" },
				day_brightness = 0.3,
				hide_inactive_statusline = false,
				dim_inactive = false,
				lualine_bold = false,
			})
		end,
	},

	-- CMake tools for project/preset management (Qt cross-platform builds)
	{
		"Civitasv/cmake-tools.nvim",
		cmd = { "CMake", "CMakeBuild", "CMakeConfigure", "CMakeSelectBuildType" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			pcall(function() require('configs.merged').setup_cmake() end)
		end,
	},

	-- clangd extensions: inlay hints, AST, memory usage and useful ui helpers
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp", "h", "hpp", "objc", "objcpp" },
		config = function()
			local ok, ext = pcall(require, 'clangd_extensions')
			if ok then
				ext.setup({
					autocmd = { enabled = true },
					symbols = { enable = true },
				})
			end
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			pcall(function() require('configs.merged').setup_copilot() end)
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		after = "nvim-cmp",
		config = function()
			pcall(function() require('copilot_cmp').setup() end)
		end,
	},

	-- Rust tooling: rust-tools + cargo integration
	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
		config = function()
			pcall(function() require('configs.lang.rust').setup() end)
		end,
	},
	{
		"Saecki/crates.nvim",
		ft = { "rust", "toml" },
		config = function()
			pcall(function() require('crates').setup() end)
		end,
	},

	-- Go tooling
	{
		"ray-x/go.nvim",
		ft = { "go" },
		dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
		config = function()
			pcall(function() require('configs.lang.go').setup() end)
		end,
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			pcall(function() require('gopher').setup() end)
		end,
	},
	{
		"jose-elias-alvarez/typescript.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			pcall(function()
				require('typescript').setup({
					-- Recommended settings for auto-imports and refactors
					disable_commands = false,
					-- automatically update imports when moving files
					update_imports_on_move = true,
					-- enable import-on-completion where supported
					import_on_completion = true,
					-- use Volar (vtsls) if available
					-- fallback to tsserver only if necessary
				})
			end)
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			pcall(function() require('configs.dap.js_debug') end)
		end,
	},
}
