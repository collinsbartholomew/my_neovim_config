-- Neo-tree setup
local M = {}

function M.setup()
	-- Ensure required dependencies are loaded first
	local status_ok, neo_tree = pcall(require, "neo-tree")
	if not status_ok then
		return
	end

	neo_tree.setup({
		close_if_last_window = true,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		window = {
			position = "left",
			width = 30,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
		},
		filesystem = {
			filtered_items = {
				visible = true, -- Show all files
				hide_dotfiles = false, -- Don't hide dotfiles
				hide_gitignored = false, -- Don't hide gitignored files
				hide_hidden = false, -- Don't hide hidden files
				never_show = {}, -- Don't hide any files
			},
			follow_current_file = true,
			group_empty_dirs = false,
			hijack_netrw_behavior = "open_default",
			use_libuv_file_watcher = true,
		},
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.opt_local.signcolumn = "auto"
				end,
			},
		},
		default_component_configs = {
			indent = {
				indent_size = 2,
				padding = 1,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				highlight = "NeoTreeIndentMarker",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "ﰊ",
				default = "*",
				highlight = "NeoTreeFileIcon",
			},
			modified = {
				symbol = "[+] ",
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					added = "✚",
					deleted = "✖",
					modified = "",
					renamed = "➜",
					untracked = "★",
					ignored = "◌",
					unstaged = "✗",
					staged = "✓",
					conflict = "",
				},
			},
		},
		commands = {
			toggle = function(state)
				state:close()
			end,
		},
	})

	-- Register with which-key
	require("which-key").add({
		{ "<leader>u", group = "UI" },
		{ "<leader>ut", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" },
	})
	
	-- Set up the <C-n> keymap for Neo-tree
	vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<cr>", { noremap = true, silent = true })
end

return M