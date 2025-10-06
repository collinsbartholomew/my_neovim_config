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
	open_mapping = [[<C-\>]],
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
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
	winbar = {
		enabled = false,
		name_formatter = function(term)
			return term.name
		end,
	},
})

