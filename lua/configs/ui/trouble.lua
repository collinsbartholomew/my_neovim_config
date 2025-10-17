local ok, trouble = pcall(require, "trouble")
if not ok then
	vim.notify("trouble not available", vim.log.levels.WARN)
	return
end

trouble.setup({
	position = "bottom",
	height = 10,
	width = 50,
	icons = true,
	mode = "diagnostics",
	fold_open = "",
	fold_closed = "",
	group = true,
	padding = true,
	action_keys = { close = "q", cancel = "<esc>", refresh = "r", jump = { "<cr>", "<tab>" }, open_split = { "<c-x>" }, open_vsplit = { "<c-v>" }, open_tab = { "<c-t>" }, jump_close = { "o" }, toggle_mode = "m", toggle_preview = "P", hover = "K", preview = "p", close_folds = { "zM", "zm" }, open_folds = { "zR", "zr" }, toggle_fold = { "zA", "za" }, previous = "k", next = "j" },
	indent_lines = true,
	auto_open = false,
	auto_close = false,
	auto_preview = true,
	auto_fold = false,
	auto_jump = { "lsp_definitions" },
	signs = { error = "", warning = "", hint = "", information = "", other = "﫠" },
	use_diagnostic_signs = false,
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>so", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols Outline" })

