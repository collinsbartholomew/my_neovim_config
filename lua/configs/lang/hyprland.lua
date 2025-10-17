-- Hyprland config support (hyprls LSP)
local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "hyprlang",
		callback = function()
			local opts = { buffer = true, silent = true }
			vim.keymap.set("n", "<leader>hr", function()
				vim.cmd("!hyprctl reload")
				vim.notify("Hyprland config reloaded", vim.log.levels.INFO)
			end, vim.tbl_extend("force", opts, { desc = "Reload Hyprland config" }))

			vim.keymap.set("n", "<leader>hf", function()
				vim.lsp.buf.format({ async = true })
			end, vim.tbl_extend("force", opts, { desc = "Format Hyprland config" }))
		end,
	})
end

return M

