return {
	-- Colorschemes
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("configs.rose-pine")
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

	-- LSP and Mason
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
		config = function()
			require("configs.mason")
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
			if not ok then
				return
			end

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"biome",
					"tsserver",
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
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local ok, mason_tool_installer = pcall(require, "mason-tool-installer")
			if not ok then
				return
			end

			mason_tool_installer.setup({
				ensure_installed = {
					-- Formatters
					"stylua",
					"biome",
					"prettier",
					"shfmt",
					"shellcheck",
					"asm-lsp",
					"asmfmt",
					"clang-format",
					"cmake-format",
					"goimports",
					"rustfmt",
					"google-java-format",
					"ktlint",
					"php-cs-fixer",
					"sqlfluff",
					"pg_format",
					"ruff",
					"taplo",
					"xmlformatter",
					"buf",
					-- DAP Adapters
					"js-debug-adapter",
					"codelldb",
					"debugpy",
					"bash-debug-adapter",
					"delve",
				},
				auto_update = false,
				run_on_start = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 50,
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("configs.lsp-progress")
			require("configs.lsp-modern")
			require("configs.react").setup()
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
					local ok, luasnip_vscode = pcall(require, "luasnip.loaders.from_vscode")
					if ok then
						luasnip_vscode.lazy_load()
					end
				end,
			},
		},
		config = function()
			local ok = pcall(require, "configs.completion")
			if not ok then
				vim.notify("Failed to load completion config", vim.log.levels.WARN)
			end
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

	-- Formatting (nvim-lint removed - LSP provides better diagnostics)
	{
		"stevearc/conform.nvim",
		lazy = false,
		cmd = { "ConformInfo" },
		config = function()
			require("configs.formatting")
		end,
	},

	-- Database tools (enhanced)
	{
		"tpope/vim-dadbod",
		cmd = "DB",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
		},
		config = function()
			require("configs.database").setup()
		end,
	},

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

	-- Assembly Language Support (consolidated)
	{
		"philj56/vim-asm-indent",
		ft = { "asm", "nasm", "masm", "gas", "s", "S", "arm" },
		config = function()
			require("configs.assembly")
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
			{ "<leader>so", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols Outline" },
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

	-- Git integration (keeping only Neogit + Diffview - more powerful than Fugitive)
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
			{ "<leader>gs", "<cmd>Neogit<cr>", desc = "Git status" },
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
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
						background_colour = "#000000",
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

	-- Debugging (DAP)
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
		},
		config = function()
			require("configs.dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		lazy = true,
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Evaluate Expression",
				mode = { "n", "v" },
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		lazy = true,
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},

	-- Build/Task Runner
	{
		"stevearc/overseer.nvim",
		cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo" },
		keys = {
			{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
			{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Tasks" },
			{ "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Task Info" },
		},
		config = function()
			require("overseer").setup({
				templates = { "builtin", "user.cpp_build", "user.rust_build", "user.go_build" },
			})
		end,
	},

	-- Testing
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
			"rouge8/neotest-rust",
			"nvim-neotest/neotest-python",
			"haydenmeade/neotest-jest",
		},
		keys = {
			{
				"<leader>tn",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest Test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File Tests",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Test Summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Show Test Output",
			},
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go"),
					require("neotest-rust"),
					require("neotest-python"),
					require("neotest-jest"),
				},
			})
		end,
	},

	-- Refactoring
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>rr",
				function()
					require("refactoring").select_refactor()
				end,
				desc = "Refactor Menu",
				mode = { "n", "x" },
			},
			{
				"<leader>re",
				function()
					require("refactoring").refactor("Extract Function")
				end,
				desc = "Extract Function",
				mode = "x",
			},
			{
				"<leader>rf",
				function()
					require("refactoring").refactor("Extract Function To File")
				end,
				desc = "Extract Function To File",
				mode = "x",
			},
			{
				"<leader>rv",
				function()
					require("refactoring").refactor("Extract Variable")
				end,
				desc = "Extract Variable",
				mode = "x",
			},
			{
				"<leader>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				desc = "Inline Variable",
				mode = { "n", "x" },
			},
		},
		config = function()
			require("refactoring").setup()
		end,
	},

	-- Incremental Rename
	{
		"smjonas/inc-rename.nvim",
		keys = {
			{
				"<leader>rn",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "Incremental Rename",
				expr = true,
			},
		},
		config = function()
			require("inc-rename").setup()
		end,
	},

	-- Illuminate (highlight references)
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("illuminate").configure({
				providers = { "lsp", "treesitter", "regex" },
				delay = 100,
				filetypes_denylist = { "dirvish", "fugitive", "neo-tree" },
			})
		end,
	},

	-- Scratch files
	{
		"mtth/scratch.vim",
		cmd = { "Scratch", "ScratchPreview" },
		keys = {
			{ "<leader>sc", "<cmd>Scratch<cr>", desc = "New Scratch Buffer" },
			{ "<leader>sp", "<cmd>ScratchPreview<cr>", desc = "Preview Scratch" },
		},
	},
}
