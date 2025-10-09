require("neo-tree").setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,

	window = {
		position = "left",
		width = 30,
		mappings = {
			["<cr>"] = "open",
			["o"] = "open",
		},
	},
	default_component_configs = {
		name = {
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
	},
	filesystem = {
		components = {
			name = function(config, node, state)
				if node.type == "directory" and node:get_depth() == 1 then
					return {
						text = vim.fn.fnamemodify(node.path, ":t"),
						highlight = config.highlight or "NeoTreeDirectoryName",
					}
				else
					return require("neo-tree.sources.common.components").name(config, node, state)
				end
			end,
		},
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