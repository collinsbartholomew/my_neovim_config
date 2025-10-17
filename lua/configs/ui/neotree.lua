local neotree_status, neotree = pcall(require, "neo-tree")
if not neotree_status then
	vim.notify("Neo-tree not available: " .. tostring(neotree), vim.log.levels.WARN)
	return
end

neotree.setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	window = { position = "left", width = 30, mapping_options = { noremap = true, nowait = true }, mappings = { ["<cr>"] = "open", ["o"] = "open" } },
	default_component_configs = { name = { use_git_status_colors = true, highlight = "NeoTreeFileName" } },
	filesystem = { filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false, hide_hidden = false, never_show = { ".DS_Store", "thumbs.db" } }, follow_current_file = { enabled = true, leave_dirs_open = false }, hijack_netrw_behavior = "open_default", use_libuv_file_watcher = true },
	event_handlers = { { event = "file_opened", handler = function()
		require("neo-tree.command").execute({ action = "close" })
	end } },
})

local neo_tree_opened = false
local function open_neotree()
	if neo_tree_opened then
		return
	end
	local argv = vim.fn.argv()
	if not (vim.fn.argc() == 1 and vim.fn.isdirectory(argv[1]) == 1) then
		return
	end
	neo_tree_opened = true
	local ok, err = pcall(function()
		require("neo-tree.command").execute({ action = "show", source = "filesystem", position = "left" })
	end)
	if not ok then
		vim.notify("Failed to open Neo-tree: " .. tostring(err), vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd("VimEnter", { callback = function()
	vim.defer_fn(open_neotree, 500)
end })
vim.api.nvim_create_autocmd("BufEnter", { once = true, callback = open_neotree })
vim.api.nvim_create_autocmd("FileType", { pattern = "neo-tree", callback = function()
	vim.opt_local.spell = false
	vim.opt_local.signcolumn = "no"
end })

vim.api.nvim_create_user_command("Neotree", function(opts)
	require("neo-tree.command").execute(opts.fargs)
end, { nargs = "*", complete = function(arglead, cmdline, cursorpos)
	return require("neo-tree.command").complete(arglead, cmdline, cursorpos)
end })

vim.keymap.set("n", "<leader>e", function()
	require("neo-tree.command").execute({ toggle = true, reveal = true, position = "left", source = "filesystem" })
end, { desc = "Explorer Toggle (Neo-tree)" })
vim.keymap.set("n", "<leader>nt", function()
	require("neo-tree.command").execute({ toggle = true, reveal = true, position = "left", source = "filesystem" })
end, { desc = "Neo-tree: Toggle" })
vim.keymap.set("n", "<leader>no", function()
	require("neo-tree.command").execute({ action = "show", reveal = true, position = "left", source = "filesystem" })
end, { desc = "Neo-tree: Open/Show" })
vim.keymap.set("n", "<leader>nr", function()
	require("neo-tree.command").execute({ action = "reveal", reveal = true, position = "left", source = "filesystem" })
end, { desc = "Neo-tree: Reveal current file" })
