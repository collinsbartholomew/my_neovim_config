--============================================================================
-- BIOME LSP DIAGNOSTICS HELPER
-- ============================================================================
-- Comprehensive diagnostic tool for Biome LSP server setup and functionality
-- Checks installation, configuration, client status, and provides recommendations
-- Usage: :BiomeDiagnose
-- ============================================================================

local M = {}

-- Main diagnostic function that checks all aspects of Biome setup
function M.check_biome_setup()
	print("=== BIOME DIAGNOSTICS ===")

	-- Step 1: Check if Biome executable is installed via Mason
	local biome_path = vim.fn.stdpath("data") .. "/mason/bin/biome"
	local biome_available = vim.fn.executable(biome_path) == 1
	print("Biome executable: " .. (biome_available and "✓ Available" or "✗ Missing"))

	-- Get Biome version if available
	if biome_available then
		local handle = io.popen(biome_path .. " --version 2>&1")
		if handle then
			local version = handle:read("*a")
			handle:close()
			print("Biome version: " .. version:gsub("\n", ""))
		end
	end

	-- Step 2: Check if Biome LSP client is running
	local clients = vim.lsp.get_active_clients({ name = "biome" })
	print("Biome LSP client: " .. (#clients > 0 and "✓ Active" or "✗ Not running"))

	-- Display detailed client information if running
	if #clients > 0 then
		local client = clients[1]
		print("Client ID: " .. client.id)
		print("Root dir: " .. (client.config.root_dir or "None"))

		-- Step 3: Check LSP server capabilities
		local caps = client.server_capabilities
		if caps then
			print("Capabilities:")
			print("  Diagnostics: " .. (caps.diagnosticProvider and "✓" or "✗"))
			print("  Formatting: " .. (caps.documentFormattingProvider and "✓" or "✗"))
			print("  Code Actions: " .. (caps.codeActionProvider and "✓" or "✗"))
		end
	end

	-- Step 4: Check for Biome configuration files in project root
	local config_files = { "biome.json", "biome.jsonc" }
	local config_found = false
	for _, config in ipairs(config_files) do
		if vim.fn.filereadable(config) == 1 then
			print("Config file: ✓ " .. config)
			config_found = true
			break
		end
	end
	if not config_found then
		print("Config file: ✗ No biome.json found")
	end

	-- Step 5: Analyze current buffer and file type compatibility
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype
	local filename = vim.api.nvim_buf_get_name(bufnr)
	print("Current file: " .. (filename ~= "" and vim.fn.fnamemodify(filename, ":t") or "No file"))
	print("Filetype: " .. filetype)

	-- Check if filetype is supported by Biome
	local biome_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" }
	local supported = vim.tbl_contains(biome_filetypes, filetype)
	print("Biome supports filetype: " .. (supported and "✓" or "✗"))

	-- Step 6: Check for active Biome diagnostics in current buffer
	local diagnostics = vim.diagnostic.get(bufnr)
	local biome_diagnostics = {}
	for _, diag in ipairs(diagnostics) do
		if diag.source and diag.source:match("biome") then
			table.insert(biome_diagnostics, diag)
		end
	end
	print("Biome diagnostics: " .. #biome_diagnostics .. " found")

	print("\n=== RECOMMENDATIONS ===")
	if not biome_available then
		print("1. Install Biome: :Mason")
	elseif #clients == 0 then
		print("1. Restart Neovim to start Biome LSP")
		print("2. Check if you're in a JS/TS project directory")
	elseif not supported then
		print("1. Open a JavaScript/TypeScript file to test Biome")
	elseif not config_found then
		print("1. Create biome.json config file (optional)")
		print("2. Biome works without config but custom rules need biome.json")
	else
		print("1. Try adding syntax errors to test diagnostics")
		print("2. Use <leader>f to test formatting")
	end
end

-- Create command
vim.api.nvim_create_user_command("BiomeDiagnose", M.check_biome_setup, { desc = "Diagnose Biome LSP setup" })

--Add a command to install Biome via Mason
vim.api.nvim_create_user_command("BiomeInstall", function()
	vim.cmd("MasonInstall biome")
	vim.notify("Installing Biome via Mason...", vim.log.levels.INFO)
end, { desc = "Install Biome via Mason" })

return M
