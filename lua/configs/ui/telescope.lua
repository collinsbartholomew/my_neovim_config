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
		layout_config = { horizontal = { prompt_position = "top", preview_width = 0.55 }, width = 0.80, height = 0.85 },
		mappings = { i = { ["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous } },
	},
	pickers = { find_files = { theme = "dropdown", previewer = false }, buffers = { theme = "dropdown" } },
})

pcall(telescope.load_extension, "fzf")

local map = vim.keymap.set
map("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>tg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>tb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>th", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>tr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>tc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
map("n", "<leader>tk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>ts", "<cmd>Telescope grep_string<cr>", { desc = "Grep string" })
map("n", "<leader>tm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
map("n", "<leader>tj", "<cmd>Telescope jumplist<cr>", { desc = "Jump list" })
map("n", "<leader>tq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix list" })
map("n", "<leader>tl", "<cmd>Telescope loclist<cr>", { desc = "Location list" })
map("n", "<leader>tgf", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
map("n", "<leader>tgc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
map("n", "<leader>tgb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
map("n", "<leader>tgs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })

