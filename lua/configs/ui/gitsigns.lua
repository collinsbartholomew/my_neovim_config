local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
	vim.notify("gitsigns not available", vim.log.levels.WARN)
	return
end

gitsigns.setup({
	signs = { add = { text = "│" }, change = { text = "│" }, delete = { text = "_" }, topdelete = { text = "‾" }, changedelete = { text = "~" }, untracked = { text = "┆" } },
	watch_gitdir = { interval = 1000, follow_files = true },
	attach_to_untracked = true,
	update_debounce = 50,
	max_file_length = 40000,
	preview_config = { border = "rounded", style = "minimal", relative = "cursor" },
	current_line_blame = false,
	current_line_blame_opts = { ignore_whitespace = true },
})

vim.keymap.set("n", "<leader>gb", function()
	gitsigns.blame_line()
end, { desc = "Git blame" })
vim.keymap.set("n", "<leader>gB", function()
	gitsigns.toggle_current_line_blame()
end, { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>gn", function()
	gitsigns.next_hunk()
end, { desc = "Next hunk" })
vim.keymap.set("n", "<leader>gN", function()
	gitsigns.prev_hunk()
end, { desc = "Previous hunk" })
vim.keymap.set("n", "<leader>gr", function()
	gitsigns.reset_hunk()
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gR", function()
	gitsigns.reset_buffer()
end, { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>gS", function()
	gitsigns.stage_hunk()
end, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gu", function()
	gitsigns.undo_stage_hunk()
end, { desc = "Unstage hunk" })
vim.keymap.set("n", "<leader>gv", function()
	gitsigns.preview_hunk()
end, { desc = "Preview hunk" })

