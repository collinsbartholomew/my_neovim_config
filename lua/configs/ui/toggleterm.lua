local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
	vim.notify("toggleterm not available", vim.log.levels.WARN)
	return
end

toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	open_mapping = [[<C-\\>]],
	on_create = function()
		vim.opt.foldcolumn = "0"
		vim.opt.signcolumn = "no"
	end,
	hide_numbers = true,
	shade_filetypes = {},
	autochdir = false,
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	persist_mode = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	auto_scroll = true,
	float_opts = { border = "curved", winblend = 0, highlights = { border = "Normal", background = "Normal" } },
	winbar = { enabled = false, name_formatter = function(term)
		return term.name
	end },
})

local Terminal = require("toggleterm.terminal").Terminal
local valgrind_term = Terminal:new({ cmd = "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes ", direction = "float", float_opts = { border = "double" } })
function _VALGRIND()
	valgrind_term:open()
end
local asan_term = Terminal:new({ cmd = "echo 'Run your program with ASAN_OPTIONS=detect_leaks=1' && echo 'Example: ASAN_OPTIONS=detect_leaks=1 ./your_program'", direction = "float", float_opts = { border = "double" } })
function _ASAN()
	asan_term:open()
end

vim.keymap.set("n", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>Tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float Terminal" })
vim.keymap.set("n", "<leader>Th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal Terminal" })
vim.keymap.set("n", "<leader>Tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical Terminal" })
vim.keymap.set("n", "<leader>TA", "<cmd>ToggleTermToggleAll<cr>", { desc = "Toggle All Terminals" })

local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
local node = Terminal:new({ cmd = "node", hidden = true, direction = "float" })
local python = Terminal:new({ cmd = "python", hidden = true, direction = "float" })

vim.keymap.set("n", "<leader>Tg", function()
	lazygit:toggle()
end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>Tn", function()
	node:toggle()
end, { desc = "Node REPL" })
vim.keymap.set("n", "<leader>Tp", function()
	python:toggle()
end, { desc = "Python REPL" })

vim.keymap.set("t", "<C-h>", [[<C-\\><C-n><C-w>h]], { desc = "Terminal: Go to left window" })
vim.keymap.set("t", "<C-j>", [[<C-\\><C-n><C-w>j]], { desc = "Terminal: Go to lower window" })
vim.keymap.set("t", "<C-k>", [[<C-\\><C-n><C-w>k]], { desc = "Terminal: Go to upper window" })
vim.keymap.set("t", "<C-l>", [[<C-\\><C-n><C-w>l]], { desc = "Terminal: Go to right window" })

local function send_visual_to_terminal()
	local mode = vim.fn.mode()
	if mode ~= 'v' and mode ~= 'V' then
		vim.notify("Select some text in visual mode first", vim.log.levels.WARN)
		return
	end
	local _, srow, scol = unpack(vim.fn.getpos("'<"))
	local _, erow, ecol = unpack(vim.fn.getpos("'>"))
	local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
	if #lines == 0 then
		return
	end
	lines[#lines] = string.sub(lines[#lines], 1, ecol)
	lines[1] = string.sub(lines[1], scol)
	local text = table.concat(lines, "\n")
	local terms = require("toggleterm.terminal").get_all() or {}
	if #terms == 0 then
		vim.notify("No active terminals. Opening a new one...", vim.log.levels.INFO)
		vim.cmd("ToggleTerm")
		terms = require("toggleterm.terminal").get_all() or {}
	end
	local term = terms[#terms]
	if term then
		term:send(text)
	else
		vim.notify("Failed to find a terminal instance", vim.log.levels.ERROR)
	end
end

vim.keymap.set("v", "<leader>Ts", send_visual_to_terminal, { desc = "Send selection to Terminal" })
local ok, rose_pine = pcall(require, "rose-pine")
if not ok then
	return
end

rose_pine.setup({
	variant = "auto",
	dark_variant = "main",
	bold_vert_split = false,
	dim_nc_background = false,
	disable_background = true,
	disable_float_background = true,
	disable_italics = true,
	groups = {
		background = "base",
		panel = "surface",
		border = "highlight_med",
		comment = "muted",
		link = "iris",
		punctuation = "subtle",
		error = "love",
		hint = "iris",
		info = "foam",
		warn = "gold",
		headings = { h1 = "iris", h2 = "foam", h3 = "rose", h4 = "gold", h5 = "pine", h6 = "foam" },
	},
	highlight_groups = {
		Comment = { fg = "muted" },
		["@string"] = { fg = "gold" },
		["@string.escape"] = { fg = "pine" },
		["@string.special"] = { fg = "foam" },
		["@punctuation.special"] = { fg = "iris" },
		["@function"] = { fg = "rose" },
		["@function.builtin"] = { fg = "rose" },
		["@function.call"] = { fg = "rose" },
	},
})

vim.cmd([[colorscheme rose-pine]])
_G.current_theme = "rose-pine"

