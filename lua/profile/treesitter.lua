-- nvim-treesitter setup
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"python",
		"java",
		"javascript",
		"typescript",
		"c",
		"cpp",
		"go",
		"gomod",
		"gosum",
		"gowork",
		"gotmpl",
		"sql",
		"comment",
		"rust",
		"zig",
		"bash",
		"yaml",
		"json",
		"html",
		"css",
		"scss",
		"vue",
		"svelte",
		"tsx",
		"jsx",
		"dart",
		"c_sharp",
		"toml",
		"markdown",
		"markdown_inline",
		"asm",
	},
	auto_install = true,
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25,
	 persist_queries = false,
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
})