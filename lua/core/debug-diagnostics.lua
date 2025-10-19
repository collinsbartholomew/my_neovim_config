-- Debug and Linting Diagnostics
local M = {}

function M.check_debug_setup()
	print("=== DEBUG ADAPTER DIAGNOSTICS ===")

	-- Check DAP installation
	local dap_ok, dap = pcall(require, "dap")
	print("DAP available: " .. (dap_ok and "✓" or "✗"))

	if not dap_ok then
		print("Install DAP: Add nvim-dap to your plugins")
		return
	end

	-- Check current filetype
	local filetype = vim.bo.filetype
	print("Current filetype: " .. filetype)

	-- Check if configurations exist for current filetype
	local configs = dap.configurations[filetype]
	print("Debug configs for " .. filetype .. ": " .. (configs and #configs .. " found" or "None"))

	if configs then
		for i, config in ipairs(configs) do
			print("  " .. i .. ". " .. config.name)
		end
	end

	-- Check adapters
	local adapters_to_check = {
		javascript = "pwa-node",
		typescript = "pwa-node",
		rust = "codelldb",
		c = "codelldb",
		cpp = "codelldb",
		python = "python",
		go = "delve",
	}

	local adapter_name = adapters_to_check[filetype]
	if adapter_name then
		local adapter = dap.adapters[adapter_name]
		print("Adapter (" .. adapter_name .. "): " .. (adapter and "✓ Configured" or "✗ Missing"))

		-- Check if adapter executable exists
		if adapter and adapter.executable then
			local cmd = adapter.executable.command
			if cmd then
				local available = vim.fn.executable(cmd) == 1
				print("Adapter executable: " .. (available and "✓ " .. cmd or "✗ " .. cmd .. " not found"))
			end
		end
	end

	-- Check Mason DAP adapters
	local mason_adapters = {
		"js-debug-adapter",
		"codelldb",
		"debugpy",
		"delve",
	}

	print("\\nMason DAP adapters:")
	for _, adapter in ipairs(mason_adapters) do
		local path = vim.fn.stdpath("data") .. "/mason/bin/" .. adapter
		local available = vim.fn.executable(path) == 1
		print("  " .. adapter .. ": " .. (available and "✓" or "✗"))
	end
end

function M.test_biome_linting()
	print("=== BIOME LINTING TEST ===")

	local filetype = vim.bo.filetype
	local supported_types = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json" }

	if not vim.tbl_contains(supported_types, filetype) then
		print("Current file type (" .. filetype .. ") not supported by Biome")
		print("Open a JS/TS file to test Biome linting")
		return
	end

	-- Check if Biome LSP is running
	local clients = vim.lsp.get_active_clients({ name = "biome" })
	if #clients == 0 then
		print("Biome LSP not running. Try:")
		print("1. :LspRestart")
		print("2. Ensure you're in a JS/TS project directory")
		return
	end

	print("Biome LSP is running ✓")

	-- Get current diagnostics
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	print("Total diagnostics: " .. #diagnostics)

	local biome_diags = 0
	for _, diag in ipairs(diagnostics) do
		if diag.source and diag.source:match("biome") then
			biome_diags = biome_diags + 1
		end
	end

	print("Biome diagnostics: " .. biome_diags)

	if biome_diags == 0 then
		print("\\nTo test Biome linting, try adding:")
		print("- Unused variables: let unused = 'test';")
		print("- Missing semicolons")
		print("- Syntax errors")
	end
end

-- Combined diagnostic command
function M.full_diagnostic()
	M.check_debug_setup()
	print("\\n")
	M.test_biome_linting()

	print("\\n=== QUICK TESTS ===")
	print("1. :BiomeDiagnose - Detailed Biome diagnostics")
	print("2. :LspInfo - Check active LSP clients")
	print("3. <leader>db - Set breakpoint (if DAP working)")
	print("4. <leader>f - Format file (if Biome working)")
end

-- Create commands
vim.api.nvim_create_user_command("DebugDiagnose", M.check_debug_setup, { desc = "Diagnose debug adapter setup" })
vim.api.nvim_create_user_command("BiomeTest", M.test_biome_linting, { desc = "Test Biome linting" })
vim.api.nvim_create_user_command("FullDiagnose", M.full_diagnostic, { desc = "Full debug and linting diagnostics" })

return M

