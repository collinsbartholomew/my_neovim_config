return {
	{ import = "plugins.core" },

	-- LSP and Mason
	{
		"williamboman/mason.nvim",
		lazy = false,
		priority = 200,
		config = function()
			require("configs.tools.mason")
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
					"ts_ls",
					"eslint",
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
					"omnisharp",
					"qmlls",
					"elixirls",
					"hyprls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local ok, mason_tool_installer = pcall(require, "mason-tool-installer")
			if not ok then
				return
			end

			mason_tool_installer.setup({
				ensure_installed = {
					-- Formatters and linters that don't require local Go/Rust toolchains
					"stylua",
					"biome",
					"prettier",
					"prettierd",
					"shfmt",
					"shellcheck",
					"asmfmt",
					"clang-format",
					"google-java-format",
					"ktlint",
					"php-cs-fixer",
					"sqlfluff",
					"pg_format",
					"ruff",
					"black",
					"isort",
					"taplo",
					"xmlformatter",
					"buf",
					"styler",
					"csharpier",
					"djlint",
					"htmlbeautifier",
					-- Zig tooling
					"zig",
					"zigfmt",
					-- Linters & utilities
					"jsonlint",
					"htmlhint",
					"stylelint",
					"cppcheck",
					"cpplint",
					"clang-tidy",
					"mypy",
					"pylint",
					"luacheck",
					"golangci-lint",
					"revive",
					"checkstyle",
					"phpcs",
					"phpstan",
					"yamllint",
					"hadolint",
					"lintr",
					-- Debug adapters and language-independent tools
					"js-debug-adapter",
					"codelldb",
					"cpptools",
					"debugpy",
					"bash-debug-adapter",
					"java-debug-adapter",
					"dart-debug-adapter",
					"netcoredbg",
					-- Added Go/Rust tools
					"goimports",
					"gofumpt",
					"delve",
					"rustfmt",
				},
				auto_update = false,
				run_on_start = false, -- disabled to avoid startup install race/errors
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 50,
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			-- Use canonical LSP config (configs.lsp) insteadof legacy shim
			pcall(function()
				require('configs.lsp').setup()
			end)
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
			"hrsh7th/cmp-cmdline",
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
			local ok_result = pcall(require, "configs.completion")
			if not ok_result then
				vim.notify("Failed to load completion config", vim.log.levels.WARN)
			end
		end,
	},

	--Removed: emmet-vim (emmet_ls LSP provides better functionality)

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- Use merged treesitter setup (avoidshim)
			pcall(function()
				require('configs.merged').setup_treesitter()
			end)
		end,
	},


	--Fileexplorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
		event = { "VimEnter", "BufWinEnter" },
		keys = { {
			"<leader>e",
			function()
				require("neo-tree.command").execute({ action = "toggle", source = "filesystem" })
			end,
			desc = "Togglefile explorer"
		} },
		config = function()
			-- Use canonical UI neotree module
			pcall(function()
				require('ui.neotree').setup()
			end)
		end,
	},

	--Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8", --Use specific stable tag insteadof branch
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",             desc = "Livegrep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>",               desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>",             desc = "Help tags" },
			{ "<leader>lr", "<cmd>Telescope lsp_references<cr>",        desc = "LSP References" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
			{ "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
			-- fixed: call the builtin 'diagnostics' picker properly
			{ "<leader>ld", "<cmd>Telescope diagnostics<cr>",           desc = "Diagnostics" },
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
			-- Use canonicaltelescope UI config
			pcall(function()
				require('ui.telescope').setup()
			end)
		end,
	},

	--Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			pcall(function()
				require('ui.statusline').setup()
			end)
		end,
	},

	--Git
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			pcall(function()
				require('ui.gitsigns').setup()
			end)
		end,
	},

	--Formattingand Linting
	{
		"stevearc/conform.nvim",
		lazy = false,
		cmd = { "ConformInfo" },
		config = function()
			require("configs.tools.formatting")
		end,
	},
	{
		"mfussenegger/nvim-lint",
		lazy = false, -- Changeto false to ensure linting is always available
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Use merged linting helper
			pcall(function()
				require('configs.merged').setup_linting()
			end)
		end,
	},

	--Databasetools (enhanced)
	{
		"tpope/vim-dadbod",
		cmd = "DB",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>D",  "<cmd>DBUIToggle<cr>",     desc = "Toggle DatabaseUI" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DBBuffer" },
		},
		config = function()
			-- Use merged database helpers
			pcall(function()
				require('configs.merged').setup_database()
			end)
		end,
	},

	--Prisma support
	{
		"prisma/vim-prisma",
		ft = "prisma",
	},

	-- Fluttertools (lazyloaded)
	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			pcall(function()
				require('configs.lang.flutter-tools').setup()
			end)
		end,
	},

	--Snippets
	{ "rafamadriz/friendly-snippets", lazy = true },

	-- Schemastore for JSON/YAML
	{
		"b0o/schemastore.nvim",
		lazy = true,
	},

	-- AssemblyLanguage Support(consolidated)
	{
		"philj56/vim-asm-indent",
		ft = { "asm", "nasm", "masm", "gas", "s", "S", "arm" },
		config = function()
			-- Use canonical assembly config
			pcall(function()
				require('configs.lang.assembly').setup()
			end)
		end,
	},

	--Hyprland Configuration Support
	{
		"luckasRanarison/tree-sitter-hyprlang",
		ft = "hyprlang",
		config = function()
			-- Use canonical hyprland config
			pcall(function()
				require('configs.lang.hyprland').setup()
			end)
		end,
	},

	--Essentialadditions
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

	-- Enhancednavigation and workflow
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>",                      desc = "Diagnostics" },
			{ "<leader>xX", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Buffer Diagnostics" },
			{ "<leader>cs", "<cmd>TroubleToggle lsp_references<cr>",       desc = "Symbols References" },
			{ "<leader>so", "<cmd>TroubleToggle lsp_definitions<cr>",      desc = "Symbols Outline" },
		},
		config = function()
			pcall(function()
				require('ui.trouble').setup()
			end)
		end,
	},
	--[[ Removed bufferlineplugin to eliminate the top bar showing opened files
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			pcall(function() require('configs.ui.bufferline') end)
		end,
	},
	]] --
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		lazy = false,
		keys = { "<C-\\>" },
		config = function()
			pcall(function()
				require('ui.toggleterm').setup()
			end)
		end,
	},

	--Gitintegration(keeping only Neogit + Diffview -more powerfulthan Fugitive)
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Gitdiff" },
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
			-- simplified: open Neogit (commit handled inside UI)
			{ "<leader>gc", "<cmd>Neogit<cr>", desc = "Git commit" },
		},
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		config = function()
			require("neogit").setup({
				integrations = { diffview = true },
			})
		end,
	},

	--UIenhancements
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
								{ find = ";after #%d+" },
								{ find = "; before#%d+" },
								{ find = "%d fewerlines" },
								{ find = "%dmorelines" },
							},
						},
						view = "mini",
					},
				},
				views = {
					cmdline_popup = {
						position = {
							row = 5,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
			})

			--Enableshowcmd for all modes
			vim.opt.showcmd = true
			vim.opt.showmode = true

			--Globalfunction for lualinetoshow
			_G.show_cmd_info = function()
				local cmd = vim.fn.getcmdline()
				if cmd ~= ""
				then
					return " " .. cmd
				else
					local showcmd = vim.fn.reg_recording()
					if showcmd ~= "" then
						return "recording@" .. showcmd
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

	--Session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "RestoreSession",
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
				desc = "Don't Save CurrentSession",
			},
		},
		config = function()
			require("persistence").setup()
		end,
	},

	-- EditorConfig for consistent coding styles
	{
		"editorconfig/editorconfig-vim",
		event = "BufReadPre",
	},

	-- Todocomments for highlighting TODOs/FIXMEs
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>td", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
			{ "<leader>tq", "<cmd>TodoTrouble<cr>",   desc = "TODOs Trouble" },
		},
		config = true,
	},

	-- Quickfileswitching
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
				desc = "Harpoon quickmenu",
			},
			{
				"<C-1>",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon file1",
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
			-- Use canonical colorizer config
			pcall(function()
				require('ui.colorizer').setup()
			end)
		end,
	},

	-- Debugging (DAP)
	{
		"mfussenegger/nvim-dap",
		lazy = false,
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
				desc = "OpenREPL",
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
		lazy = false,
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAPUI",
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
		lazy = false,
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},

	-- Build/Task Runner
	{
		"stevearc/overseer.nvim",
		cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo" },
		keys = {
			{ "<leader>or", "<cmd>OverseerRun<cr>",    desc = "Run Task" },
			{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Tasks" },
			{ "<leader>oi", "<cmd>OverseerInfo<cr>",   desc = "Task Info" },
			{
				"<leader>dm",
				function()
					local ok, overseer = pcall(require, "overseer")
					if ok then
						overseer.run_template({ name = "valgrind memorycheck" })
					end
				end,
				desc = "Memory check (Valgrind)",
			},
			{
				"<leader>da",
				function()
					local ok, overseer = pcall(require, "overseer")
					if ok then
						overseer.run_template({ name = "addresssanitizercheck" })
					end
				end,
				desc = "ASan check",
			},
			{
				"<leader>ds",
				function()
					local ok, overseer = pcall(require, "overseer")
					if ok then
						overseer.run_template({ name = "securityscan with trivy" })
					end
				end,
				desc = "Security scan (Trivy)",
			},
			{
				"<leader>dt",
				function()
					local ok, overseer = pcall(require, "overseer")
					if ok then
						overseer.run_template({ name = "threatscan with semgrep" })
					end
				end,
				desc = "Threat scan (Semgrep)",
			},
		},
		config = function()
			require("overseer").setup({
				templates = {
					"builtin",
					"user.cpp_build",
					"user.rust_build",
					"user.go_build",
					"user.safe_build",
					"user.valgrind_check",
					"user.asan_check",
					"user.security_scan",
					"user.secrets_scan",
					"user.threat_scan",
				},
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
				desc = "Toggle TestSummary",
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
					require("refactoring").refactor("ExtractFunction To File")
				end,
				desc = "Extract FunctionTo File",
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

	-- Python support

	--Node.js support
	{
		"moll/vim-node",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			require("configs.nodejs")
		end,
	},

	--Reactsupport
	{
		"pangloss/vim-javascript",
		ft = { "javascript", "javascriptreact" },
		config = function()
			require("configs.react")
		end,
	},

	-- Terminal integration (canonical)
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		lazy = false,
		keys = { "<C-\\>" },
		config = function()
			pcall(function()
				require('ui.toggleterm').setup()
			end)
		end,
	},

	--Memory-safety configuration is initialized from `core/init.lua` (configs.memsafe)

	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = function()
			require("inc_rename").setup()
		end,
	},
	-- Debugging
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{
				"<leader>dd",
				function()
					require('dap').continue()
				end,
				desc = "DAP Continue"
			},
			{
				"<leader>db",
				function()
					require('dap').toggle_breakpoint()
				end,
				desc = "DAP Toggle Breakpoint"
			},
			{
				"<leader>do",
				function()
					require('dap').step_over()
				end,
				desc = "DAP Step Over"
			},
			{
				"<leader>di",
				function()
					require('dap').step_into()
				end,
				desc = "DAP Step Into"
			},
			{
				"<leader>dO",
				function()
					require('dap').step_out()
				end,
				desc = "DAP Step Out"
			},
			{
				"<leader>dr",
				function()
					require('dap').repl.open()
				end,
				desc = "DAP REPL"
			},
		},
		config = function()
			require("configs.dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local ok, dapui = pcall(require, "dapui")
			if not
				ok then
				return
			end
			dapui.setup()
			local dap = require("dap")
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

	-- CMake tools for project/preset management (Qt cross-platform builds)
	{
		"Civitasv/cmake-tools.nvim",
		cmd = { "CMake", "CMakeBuild", "CMakeConfigure", "CMakeSelectBuildType" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			pcall(function()
				require('configs.cmake').setup()
			end)
		end,
	},

	-- clangd extensions:inlay hints, AST, memory usage and useful ui helpers
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp", "h", "hpp", "objc", "objcpp" },
		config = function()
			local ok, ext = pcall(require, 'clangd_extensions')
			if ok then
				ext.setup({
					autocmd = { enabled = true },
					symbols = { -- configure as desired
						enable = true,
					},
				})
			end
		end,
	},
}
