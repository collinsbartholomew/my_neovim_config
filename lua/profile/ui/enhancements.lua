--Additional UI enhancements
local M = {}

function M.setup()
	-- Bufferline is disabled as requested
	-- Removed bufferline setup and keymaps

	-- Setup dropbar (breadcrumbs)
	pcall(function()
		require("dropbar").setup({
			icons = {
				enable = true,
			},
			bar = {
				enable = true,
				attach_events = {
					"BufWinEnter",
					"BufWritePost",
					"BufModifiedSet",
					"LspAttach",
				},
			},
		})
	end)

	-- Setup navic for winbar context
	pcall(function()
		require("nvim-navic").setup({
			highlight = true,
			separator = " > ",
			depth_limit = 0,
			depth_limit_indicator = "..",
		})
	end)

	-- Setup codewindow (minimap)
	pcall(function()
		require("codewindow").setup({
			auto_enable = true,
			width_multiplier = 12,
			height_multiplier = 12,
			show_cursor = true,
			auto_close = true,
			use_lsp = true,
			use_treesitter = true,
		})

		-- Add keymap for toggling minimap
		vim.keymap.set("n", "<leader>um", function()
			require("codewindow").toggle_minimap()
		end, { desc = "Toggle minimap" })
	end)

	-- Setup indent-blankline
	pcall(function()
		local ibl = require("ibl")
		ibl.setup({
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = {
				enabled = true,
				show_start = true,
				show_end = true,
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		})
	end)

	-- Setup alpha (startup screen)
	pcall(function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Customize header
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		dashboard.section.buttons.val = {
			dashboard.button("f", " Find file", ":Telescope find_files <CR>"),
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("p", "  Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
			dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
			dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
			dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
			dashboard.button("q", "  Quit", ":qa<CR>"),
		}

		dashboard.section.footer = {
			type = "text",
			val = "Neovim Configuration",
			opts = {
				position = "center",
			},
		}

		-- Fixthe layout issue by ensuring we're using the proper config
		local config = {
			layout = {
				{ type = "padding", val = 2 },
				dashboard.section.header,
				{ type = "padding", val = 2 },
				dashboard.section.buttons,
				dashboard.section.footer or { type = "padding", val = 1 },
			},
			opts = {
				margin = 5,
			},
		}

		alpha.setup(config)
	end)
end

return M

