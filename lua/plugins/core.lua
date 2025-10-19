return {
	-- Core functionality
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			{ "nvim-treesitter/nvim-treesitter-context", opts = true },
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("core.treesitter").setup()
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", priority = 900 },
			--            { "williamboman/mason-lspconfig.nvim", priority = 800 },
			{ "hrsh7th/cmp-nvim-lsp", priority = 700 },
			{
				"folke/neodev.nvim",
				priority = 1000, -- Load before LSP setup
				config = function()
					require("neodev").setup({
						library = {
							enabled = true,
							plugins = true,
							runtime = true,
							types = true,
						},
					})
				end,
			},
		},
		config = function()
			local ok, lsp = pcall(require, "core.lsp")
			if not ok then
				vim.notify("Failed to load LSP configuration", vim.log.levels.ERROR)
				return
			end
			lsp.setup()
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		dependencies = {
			--			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("tools.mason").setup()
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim", -- Add lspkind for VSCode-like pictograms
		},
		config = function()
			require("tools.completion").setup()
		end,
	},

	-- Formatting support
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				scss = { { "prettierd", "prettier" } },
				markdown = { { "prettierd", "prettier" } },
				rust = { "rustfmt" },
				go = { "gofmt", "goimports" },
				c = { "clang_format" },
				cpp = { "clang_format" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "pylint", "mypy" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				lua = { "luacheck" },
				sh = { "shellcheck" },
				markdown = { "markdownlint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	-- Task management
	{
		"stevearc/overseer.nvim",
		cmd = {
			"OverseerRun",
			"OverseerToggle",
			"OverseerBuild",
			"OverseerTaskAction",
		},
		config = function()
			require("tools.overseer").setup()
		end,
	},

	-- Code annotations and TODOs
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("tools.todo").setup()
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Ensure LSP UI enhancements are loaded before LSP
	{
		"onsails/lspkind.nvim",
		lazy = true,
		config = function()
			require("lspkind").init()
		end,
	},

	-- Development tool installation
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
	},

	-- Essential plugins
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			plugins = { spelling = true },
			defaults = {
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["gz"] = { name = "+surround" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+file/find" },
				["<leader>g"] = { name = "+git" },
				["<leader>q"] = { name = "+quit/session" },
				["<leader>s"] = { name = "+search" },
				["<leader>u"] = { name = "+ui" },
				["<leader>w"] = { name = "+windows" },
				["<leader>x"] = { name = "+diagnostics/quickfix" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},

	-- Modern matchit implementation
	{
		"andymass/vim-matchup",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},

	-- Better search
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
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
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Flash Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},

	-- Better yanking
	{
		"gbprod/yanky.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		opts = {
			highlight = { timer = 250 },
			ring = { storage = "sqlite" },
		},
		keys = {
			{
				"y",
				"<Plug>(YankyYank)",
				mode = { "n", "x" },
				desc = "Yank text",
			},
			{
				"p",
				"<Plug>(YankyPutAfter)",
				mode = { "n", "x" },
				desc = "Put yanked text after cursor",
			},
			{
				"P",
				"<Plug>(YankyPutBefore)",
				mode = { "n", "x" },
				desc = "Put yanked text before cursor",
			},
			{
				"gp",
				"<Plug>(YankyGPutAfter)",
				mode = { "n", "x" },
				desc = "Put yanked text after selection",
			},
			{
				"gP",
				"<Plug>(YankyGPutBefore)",
				mode = { "n", "x" },
				desc = "Put yanked text before selection",
			},
			{ "<c-p>", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
			{ "<c-n>", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
			{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
			{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
			{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
			{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
			{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
			{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
			{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
			{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
			{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
			{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
		},
	},

	-- Better text-objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			local i = {
				[" "] = "Whitespace",
				['"'] = 'Balanced "',
				["'"] = "Balanced '",
				["`"] = "Balanced `",
				["("] = "Balanced (",
				[")"] = "Balanced ) including white-space",
				[">"] = "Balanced > including white-space",
				["<lt>"] = "Balanced <",
				["]"] = "Balanced ] including white-space",
				["["] = "Balanced [",
				["}"] = "Balanced } including white-space",
				["{"] = "Balanced {",
				["?"] = "User Prompt",
				_ = "Underscore",
				a = "Argument",
				b = "Balanced ), ], }",
				c = "Class",
				f = "Function",
				o = "Block, conditional, loop",
				q = "Quote `, \", '",
				t = "Tag",
			}
			local a = vim.deepcopy(i)
			for k, v in pairs(a) do
				a[k] = v:gsub(" including.*", "")
			end

			local ic = vim.deepcopy(i)
			local ac = vim.deepcopy(a)
			for key, name in pairs({ n = "Next", l = "Last" }) do
				i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
				a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
			end
			require("which-key").register({
				mode = { "o", "x" },
				i = i,
				a = a,
			})
		end,
	},

	-- Better diagnostics list
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			use_diagnostic_signs = true,
		},
	},

	-- Better quickfix
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {},
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
			{ "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo" },
		},
	},

	-- Better terminals
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
		opts = {
			size = 20,
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = false,
			shading_factor = 0.3,
			start_in_insert = true,
			persist_size = true,
			direction = "float",
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		},
		keys = {
			{ "<c-/>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
			{ "<c/_>", "<cmd>ToggleTerm<cr>", desc = "which_key_ignore" },
		},
	},

	-- Project management
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		opts = {
			detection_methods = { "pattern", "lsp" },
			patterns = {
				".git",
				"_darcs",
				".hg",
				".bzr",
				".svn",
				"Makefile",
				"package.json",
				"pom.xml",
				"Cargo.toml",
				"go.mod",
				"CMakeLists.txt",
			},
		},
		config = function(_, opts)
			require("project_nvim").setup(opts)
			require("telescope").load_extension("projects")
		end,
		keys = {
			{ "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
		},
	},

	-- Task runner
	{
		"stevearc/overseer.nvim",
		keys = {
			{ "<leader>tt", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
			{ "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Run" },
			{ "<leader>ta", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
			{ "<leader>tb", "<cmd>OverseerBuild<cr>", desc = "Build" },
			{ "<leader>tc", "<cmd>OverseerClose<cr>", desc = "Close" },
			{ "<leader>td", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
			{ "<leader>tl", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
			{ "<leader>ts", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
			{ "<leader>tq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
		},
		opts = {
			task_list = {
				direction = "right",
				min_width = 50,
				max_width = 90,
				default_detail = 1,
				bindings = {
					["?"] = "ShowHelp",
					["<CR>"] = "RunAction",
					["<C-e>"] = "Edit",
					["o"] = "Open",
					["<C-v>"] = "OpenVsplit",
					["<C-s>"] = "OpenSplit",
					["<C-f>"] = "OpenFloat",
					["<C-q>"] = "OpenQuickFix",
					["p"] = "TogglePreview",
					["<C-l>"] = "IncreaseDetail",
					["<C-h>"] = "DecreaseDetail",
					["L"] = "IncreaseAllDetail",
					["H"] = "DecreaseAllDetail",
					["["] = "DecreaseWidth",
					["]"] = "IncreaseWidth",
					["{"] = "PrevTask",
					["}"] = "NextTask",
				},
			},
		},
	},
}
