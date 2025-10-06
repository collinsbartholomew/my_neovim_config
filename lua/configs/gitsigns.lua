local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
	vim.notify("gitsigns not available", vim.log.levels.WARN)
	return
end

gitsigns.setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	watch_gitdir = { interval = 1000, follow_files = true },
	attach_to_untracked = true,
	update_debounce = 50,
	max_file_length = 40000,
	preview_config = { border = "rounded", style = "minimal", relative = "cursor" },
	current_line_blame = false,
	current_line_blame_opts = { ignore_whitespace = true },
})
