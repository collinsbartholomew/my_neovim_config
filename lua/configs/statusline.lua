-- Unified Statusline Configuration
local ok, lualine = pcall(require, "lualine")
if not ok then
	vim.notify("lualine not available", vim.log.levels.WARN)
	return
end

lualine.setup({
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = "",
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			"filename",
			{
				function()
					return require("configs.lsp-progress").get_progress()
				end,
				cond = function()
					return require("configs.lsp-progress").get_progress() ~= ""
				end,
				color = { fg = "#ffaa00" },
			},
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	extensions = { "neo-tree", "trouble" },
})

