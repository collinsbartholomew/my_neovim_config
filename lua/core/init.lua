local M = {}

function M.setup()
	-- Set up core components in the correct order
	require("core.options").setup() -- Basic vim options first
	require("core.keymaps").setup() -- Key mappings
	require("core.lsp_setup").setup() -- LSP configuration
	--	require("core.diagnostics").setup() -- Diagnostic settings
	require("ui.theme").setup() -- Theme configuration

	--	-- Sync package installations
	--	local mason_registry = require("mason-registry")
	--	if not mason_registry.is_installed("typescript-language-server") then
	--		vim.notify("Installing required packages...", vim.log.levels.INFO)
	--		vim.cmd("MasonInstall typescript-language-server")
	--	end
	--
	--	-- Post-setup configurations
	--	vim.api.nvim_create_autocmd("User", {
	--		pattern = "LazyDone",
	--		callback = function()
	--			-- Ensure treesitter parsers are installed
	--			vim.cmd("TSInstall javascript typescript tsx lua")
	--			-- Update snippets
	--			require("luasnip.loaders.from_vscode").load()
	--		end,
	--	})

	return true
end

return M
