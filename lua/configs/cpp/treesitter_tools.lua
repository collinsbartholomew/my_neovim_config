local M = {}

function M.setup()
	require("nvim-treesitter.configs").setup({
		cpp_tools = {
			enable = true,
			preview = {
				quit = "q",
				accept = "<tab>",
			},
		},
	})
end

return M
