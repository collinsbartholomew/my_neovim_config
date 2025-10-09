-- Startup Configuration
local M = {}

function M.setup()
	-- Auto-open Neo-tree on startup
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			-- Always open Neo-tree on startup
			vim.defer_fn(function()
				vim.cmd("Neotree show")
			end, 50)
		end,
	})
end

return M