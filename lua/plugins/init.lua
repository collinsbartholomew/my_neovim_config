return {
	-- Colorscheme
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				disable_float_background = true,
				disable_italics = true,
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},

	-- LSP and Mason
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			require("configs.mason")
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			vim.defer_fn(function()
				local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
				if not ok then
					vim.notify("mason-lspconfig not available", vim.log.levels.WARN)
					return
				end

				mason_lspconfig.setup({
					ensure_installed = {
						"lua_ls",
						"biome",
						"html",
						"cssls",
						"tailwindcss",
						"jsonls",
						"yamlls",
						"emmet_ls",
						"bashls",
						"cmake",
						"gopls",
						"rust_analyzer",
						"clangd",
						"jdtls",
						"kotlin_language_server",
						"intelephense",
						"sqls",
						"vimls",
						"prismals",
						"pyright",
						"zls",
					},
					automatic_installation = true,
				})
				-- Install tools in background with error handling
				vim.schedule(function()
					pcall(vim.cmd, "MasonInstall lua_ls html cssls tailwindcss jsonls yamlls emmet_ls")
				end)
			end, 1000)
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			vim.defer_fn(function()
				local ok, mason_tool_installer = pcall(require, "mason-tool-installer")
				if not ok then
					vim.notify("mason-tool-installer not available", vim.log.levels.WARN)
					return
				end

				mason_tool_installer.setup({
					ensure_installed = {
						-- Core formatters and tools (verified names)
						"stylua",
						"biome",
						"shfmt",
						"shellcheck",
						"asm-lsp",
						"asmfmt",
						"clang-format",
						"cmakelang",
						"goimports",
						"rustfmt",
						"google-java-format",
						"php-cs-fixer",
						"sqlfmt",
					},
					auto_update = false,
					run_on_start = false,
				})
				-- Install tools in background after delay with error handling
				vim.schedule(function()
					pcall(mason_tool_installer.run_on_start)
				end)
			end, 3000)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 70,
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("configs.lsp-progress")
			require("configs.lsp-unified")
		end,
	},

	{
		"onsails/lspkind.nvim",
		lazy = true,
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("gopher").setup()
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>so", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		config = function()
			require("fidget").setup({
				notification = { window = { winblend = 0 } },
			})
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			require("configs.completion")
		end,
	},

	-- Removed: emmet-vim (emmet_ls LSP provides better functionality)

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("configs.treesitter")
		end,
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" } },
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
		config = function()
			require("configs.neotree")
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8", -- Use specific stable tag instead of branch
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
			{ "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
			{ "<leader>ld", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		config = function()
			require("configs.telescope")
		end,
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.statusline")
		end,
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("configs.gitsigns")
		end,
	},

	-- Formatting and linting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			require("configs.formatting")
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				-- JS/TS: Removed (Biome handles this better)
				-- Python: Use Ruff (faster than flake8)
				python = { "ruff" },
				-- Shell: Keep shellcheck (best for shell)
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				-- Removed: htmlhint, stylelint, markdownlint (handled by LSP/formatters)
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	-- Database tools (consolidated - sqls LSP provides better functionality)
	{
		"tpope/vim-dadbod",
		cmd = "DB",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	},
	-- Removed: vim-dadbod-completion (sqls LSP provides better completions)

	-- Prisma support
	{
		"prisma/vim-prisma",
		ft = "prisma",
	},

	-- Flutter tools (lazy loaded)
	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.flutter-tools")
		end,
	},

	-- Snippets
	{ "rafamadriz/friendly-snippets", lazy = true },

	-- Schema store for JSON/YAML
	{
		"b0o/schemastore.nvim",
		lazy = true,
	},

	-- Assembly Language Support (Modern)
	{
		"ARM9/arm-syntax-vim",
		ft = { "asm", "s", "S", "arm" },
	},
	{
		"Shirk/vim-gas",
		ft = { "asm", "s", "S" },
	},
	{
		"philj56/vim-asm-indent",
		ft = { "asm", "nasm", "masm", "gas" },
		config = function()
			require("configs.assembly")
		end,
	},
	{
		"mhinz/vim-startify",
		event = "VimEnter",
		config = function()
			vim.g.startify_custom_header = {
				"   ╔═══════════════════════════════════════════════════════════╗",
				"   ║                    Assembly IDE Ready                     ║",
				"   ║              Professional Development Environment         ║",
				"   ╚═══════════════════════════════════════════════════════════╝",
			}
			vim.g.startify_lists = {
				{ type = "files", header = { "   Recent Files" } },
				{ type = "sessions", header = { "   Sessions" } },
			}
		end,
	},

	-- Essential additions
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gb" },
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("ibl").setup({ indent = { char = "│" } })
		end,
	},

	-- Enhanced navigation and workflow
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
		},
		config = function()
			require("configs.trouble")
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
		config = function()
			require("configs.flash")
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		keys = { "<C-\\>" },
		config = function()
			require("configs.toggleterm")
		end,
	},

	-- Git integration
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G" },
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
			{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
			{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git diff" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git history" },
		},
		config = function()
			require("diffview").setup()
		end,
	},
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
		},
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		config = function()
			require("neogit").setup({
				integrations = { diffview = true },
			})
		end,
	},

	-- UI enhancements
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				config = function()
					require("notify").setup({
						fps = 30,
						icons = {
							DEBUG = "",
							ERROR = "",
							INFO = "",
							TRACE = "✎",
							WARN = "",
						},
						level = 2,
						minimum_width = 24,
						max_width = function()
							return math.floor(vim.o.columns * 0.32)
						end,
						max_height = function()
							return math.floor(vim.o.lines * 0.32)
						end,
						render = "compact",
						stages = "fade_in_slide_out",
						timeout = 2000,
						top_down = true,
					})
				end,
			},
		},
		config = function()
			require("noice").setup({
				lsp = {
					progress = { enabled = false },
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "%d+L, %d+B" },
								{ find = "; after #%d+" },
								{ find = "; before #%d+" },
								{ find = "%d fewer lines" },
								{ find = "%d more lines" },
							},
						},
						view = "mini",
					},
				},
			})

			-- Enable showcmd for all modes
			vim.opt.showcmd = true
			vim.opt.showmode = true

			-- Global function for lualine to show commands
			_G.show_cmd_info = function()
				local cmd = vim.fn.getcmdline()
				if cmd ~= "" then
					return " " .. cmd
				else
					local showcmd = vim.fn.reg_recording()
					if showcmd ~= "" then
						return "recording @" .. showcmd
					else
						return ""
					end
				end
			end
		end,
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		config = function()
			require("dressing").setup({
				input = {
					enabled = true,
					default_prompt = "Input:",
					trim_prompt = true,
					title_pos = "left",
					insert_only = true,
					start_in_insert = true,
					border = "rounded",
					relative = "cursor",
					prefer_width = 40,
					width = nil,
					max_width = { 140, 0.9 },
					min_width = { 20, 0.2 },
					win_options = {
						winblend = 10,
						wrap = false,
						list = true,
						listchars = "precedes:…,extends:…",
						colorcolumn = "99999",
					},
					mappings = {
						n = {
							["<Esc>"] = "Close",
							["<CR>"] = "Confirm",
						},
						i = {
							["<C-c>"] = "Close",
							["<CR>"] = "Confirm",
							["<Up>"] = "HistoryPrev",
							["<Down>"] = "HistoryNext",
						},
					},
				},
				select = {
					enabled = true,
					backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
					trim_prompt = true,
					telescope = require("telescope.themes").get_ivy({
						layout_config = {
							height = 0.4,
						},
					}),
					nui = {
						position = "50%",
						size = nil,
						relative = "editor",
						border = {
							style = "rounded",
						},
						buf_options = {},
						win_options = {
							winblend = 10,
						},
						max_width = 80,
						max_height = 40,
						min_width = 40,
						min_height = 10,
					},
					builtin = {
						show_numbers = true,
						border = "rounded",
						relative = "editor",
						buf_options = {},
						win_options = {
							winblend = 10,
						},
						width = nil,
						max_width = { 140, 0.8 },
						min_width = { 40, 0.2 },
						height = nil,
						max_height = 0.9,
						min_height = { 10, 0.2 },
					},
				},
			})
		end,
	},

	-- Session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
		config = function()
			require("persistence").setup()
		end,
	},

	-- Quick file switching
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon add file",
			},
			{
				"<C-e>",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon quick menu",
			},
			{
				"<C-1>",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon file 1",
			},
			{
				"<C-2>",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon file 2",
			},
			{
				"<C-3>",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon file 3",
			},
			{
				"<C-4>",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon file 4",
			},
		},
		config = function()
			require("harpoon").setup()
		end,
	},

	-- TypeScript enhanced tools
	{
		"pmizio/typescript-tools.nvim",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("configs.typescript-tools")
		end,
	},

	-- Text manipulation
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	-- Color picker integration (updated)
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("configs.colorizer")
		end,
	},

	-- Enhanced LSP UI
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_signature").setup({
				bind = true,
				handler_opts = { border = "rounded" },
				hint_enable = false,
				floating_window = false,
			})
		end,
	},
}
