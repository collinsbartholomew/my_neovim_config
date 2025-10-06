local telescope_ok, telescope = pcall(require, "telescope")
local actions_ok, actions = pcall(require, "telescope.actions")

if not telescope_ok or not actions_ok then
	vim.notify("telescope not available", vim.log.levels.WARN)
	return
end

telescope.setup({
	defaults = {
		prompt_prefix = "   ",
		selection_caret = "  ",
		path_display = { "truncate" },
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
			},
			width = 0.80,
			height = 0.85,
		},
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
		},
		buffers = {
			theme = "dropdown",
		},
	},
})

pcall(telescope.load_extension, "fzf")

