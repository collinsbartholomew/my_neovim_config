--============================================================================
-- DIAGNOSTIC UTILITIES - Troubleshooting Helper
-- ============================================================================
-- Comprehensive diagnostics for LSP, linting, and Neo-tree issues
-- ============================================================================

local M = {}

-- Check linter availability
function M.check_linters()
	local ok, lint = pcall(require, "lint")
	if not ok then
		print("nvim-lint not available: " .. tostring(lint))
		return
	end
	
	local filetype = vim.bo.filetype
	local linters = lint.linters_by_ft[filetype] or {}
	
	print("=== LINTER DIAGNOSTICS ===")
	print("Current filetype: ".. filetype)
	print("Configured linters: " .. (#linters > 0 and table.concat(linters, ", ") or "None"))
	
	if #linters > 0 then
		print("\nLinter availability:")
		for _, linter in ipairs(linters) do
			local available = vim.fn.executable(linter) == 1
			local mason_path = vim.fn.stdpath("data") .. "/mason/bin/" .. linter
			local mason_available = vim.fn.executable(mason_path) == 1
			local status = (available or mason_available) and "✓ Available" or "✗ Missing"
			print("  " .. linter .. ": " .. status)
			
			if not (available or mason_available) then
				print("    Install with: :Mason or npm install -g " .. linter)
			end
		end
	else
		print("\nNo linters configured for filetype: " .. filetype)
		print("Check if this filetype should have linters configured")
	end
	
	-- Check Mason installation
	local mason_ok, mason_registry = pcall(require, "mason-registry")
	if mason_ok then
		print("\nMason packages:")
		local essential = {"eslint_d", "htmlhint", "stylelint", "prettier", "stylua", "ruff", "luacheck"}
		for _, tool in ipairs(essential) do
			local ok, package = pcall(mason_registry.get_package, tool)
			if ok and package then
				local status = package:is_installed() and "✓ Installed" or "✗ Not installed"
				print("  " .. tool .. ": " .. status)
			end
		end
	end
end

-- Check LSP status
function M.check_lsp()
	print("=== LSP DIAGNOSTICS ===")
	local clients = vim.lsp.get_active_clients({ bufnr = 0 })
	
	if #clients == 0 then
		print("No LSP clients attached to current buffer")
		return
	end
	
	for _, client in ipairs(clients) do
		print("Client: " .. client.name)
		print("  Status: " .. (client.is_stopped() and "Stopped" or "Running"))
		print("  Root dir: " .. (client.config.root_dir or "None"))
		
		-- Check capabilities
		local caps = client.server_capabilities
		if caps then
			print("  Capabilities:")
			print("    Formatting: " .. (caps.documentFormattingProvider and "✓" or "✗"))
			print("    Hover: " .. (caps.hoverProvider and "✓" or "✗"))
			print("    Completion: " .. (caps.completionProvider and "✓" or "✗"))
			print("    Diagnostics: " .. (caps.textDocumentSync and "✓" or "✗"))
		end
	end
end

-- Check file and buffer status
function M.check_buffer()
	print("=== BUFFER DIAGNOSTICS ===")
	local bufnr = vim.api.nvim_get_current_buf()
	local file_path = vim.api.nvim_buf_get_name(bufnr)
	
	print("Buffer number: " .. bufnr)
	print("File path: " .. (file_path ~= "" and file_path or "No file"))
	print("File exists: " .. (vim.fn.filereadable(file_path) == 1 and "✓" or "✗"))
	print("Buffer type: " .. vim.bo[bufnr].buftype)
	print("Filetype: " .. vim.bo[bufnr].filetype)
	print("Modifiable: " .. (vim.bo[bufnr].modifiable and "✓" or "✗"))
	print("Modified: " .. (vim.bo[bufnr].modified and "✓" or "✗"))
	
	if file_path ~= "" then
		local file_size = vim.fn.getfsize(file_path)
		print("File size: "..(file_size >= 0 and file_size .. " bytes" or "Unknown"))
	end
end

-- Comprehensive diagnostic
function M.diagnose_all()
	M.check_buffer()
	print("")
	M.check_lsp()
	print("")
	M.check_linters()
	print("\n=== RECOMMENDATIONS ===")
	print("1. Run :Mason to install missing tools")
	print("2. Run :LspInfo to check LSP status")
	print("3. Run :checkhealth to verify Neovim setup")
	print("4. Use <leader>li to check linters for current file")
end

-- Setup diagnostic keymaps
local keymap = vim.keymap.set

keymap("n", "<leader>df", function()
	vim.diagnostic.open_float()
end, { desc = "Diagnostic float" })

keymap("n", "<leader>dn", function()
	vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })

keymap("n", "<leader>dp", function()
	vim.diagnostic.goto_prev()
end, { desc = "Previous diagnostic" })

keymap("n", "<leader>dl", function()
	vim.diagnostic.setloclist()
end, { desc = "Populate location list" })

keymap("n", "<leader>dq", function()
	vim.diagnostic.setqflist()
end, { desc = "Populate quickfix list" })

keymap("n", "<leader>dr", function()
	vim.diagnostic.reset()
end, { desc = "Reset diagnostics" })

keymap("n", "<leader>dt", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Legacy navigation
keymap("n", "[d", function()
	vim.diagnostic.goto_prev()
end, { desc = "Previous diagnostic" })

keymap("n", "]d", function()
	vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })

-- Create user commands
vim.api.nvim_create_user_command("LspDiagnose", M.diagnose_all, { desc = "Comprehensive LSP and linting diagnostics" })
vim.api.nvim_create_user_command("LspStatus", M.check_lsp, { desc = "Show LSP client status" })
vim.api.nvim_create_user_command("LinterStatus", M.check_linters, { desc = "Show linter availability" })

return M