local ok, neotree = pcall(require, "neo-tree")
if not ok then
	vim.notify("neo-tree not available", vim.log.levels.WARN)
	return
end

neotree.setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	log_level = "info",
	window = {
		position = "left",
		width = 30,
		mappings = {
			["<cr>"] = {
				"open",
				nowait = false,
			},
			["o"] = {
				"open",
				nowait = false,
			},
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_hidden = false,
			hide_by_name = {},
			never_show = { ".DS_Store", "thumbs.db" },
		},
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
		hijack_netrw_behavior = "open_default",
		use_libuv_file_watcher = true,
	},
	event_handlers = {
		{
			event = "file_opened",
			handler = function()
				require("neo-tree.command").execute({ action = "close" })
			end,
		},
	},
})
