local M = {}

function M.setup()
	-- LSP server configuration is handled by core.lsp using the servers table
	require("lspconfig").zls.setup({
		capabilities = require("core.lsp").get_capabilities(),
		on_attach = function(client, bufnr)
			require("core.lsp").on_attach(client, bufnr)
		end,
	})

	-- Set up Zig-specific keymaps and commands
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "zig",
		callback = function()
			-- Local keymaps for Zig files
			local opts = { buffer = true, silent = true }
			vim.keymap.set("n", "<leader>zb", "<cmd>ZigBuild<cr>", opts)
			vim.keymap.set("n", "<leader>zt", "<cmd>ZigTest<cr>", opts)
			vim.keymap.set("n", "<leader>zr", "<cmd>ZigRun<cr>", opts)
		end,
	})

	-- Configure build templates
	if pcall(require, "tools.overseer") then
		require("tools.overseer").setup_zig_templates()
	end
end

return M
