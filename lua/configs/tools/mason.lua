-- Mason configuration (moved to configs/tools/mason.lua)
require("mason").setup({
	ui = {
		icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
		border = "rounded",
		width = 0.8,
		height = 0.9,
	},
	install_root_dir = vim.fn.stdpath("data") .. "/mason",
	pip = { upgrade_pip = false },
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
	github = { download_url_template = "https://github.com/%s/releases/download/%s/%s" },
})

-- Auto-install essential tools in background (opt-in)
-- Set vim.g.mason_auto_install = true if you want automatic installation on startup
local auto_install_on_start = vim.g.mason_auto_install == true

local essential_tools = {
	"eslint_d", "htmlhint", "stylelint", "jsonlint", "yamllint", "shellcheck", "hadolint", "luacheck", "ruff", "mypy", "golangci-lint", "gosec", "sqlfluff",
	"cargo-audit", "dependency-check",
	"lua-language-server", "rust-analyzer", "clangd", "gopls", "jdtls", "asm-lsp", "pyright", "omnisharp", "elixir-ls", "ts_ls", "eslint-lsp", "tailwindcss-language-server", "css-lsp", "html-lsp", "emmet-ls", "lemminx", "prisma-language-server", "cmake-language-server",
	"prettier", "prettierd", "stylua", "black", "isort", "clang-format", "gofumpt", "goimports", "rustfmt", "google-java-format", "csharpier", "cmakelang",
	"js-debug-adapter", "codelldb", "delve", "java-debug-adapter", "debugpy", "netcoredbg",
	"vtsls",
}

-- Determine availability of toolchains
local has_go = vim.fn.exepath('go') ~= ''
local has_rust = vim.fn.exepath('rustc') ~= '' or vim.fn.exepath('rustup') ~= ''

-- Tools that require Go or Rust toolchains to build from source
local requires_go = {
	goimports = true,
	gofmt = true,
	gopls = true,
	delve = true,
	hyprls = true,
	sqls = true,
}
local requires_rust = {
	-- names that build with cargo or need rust toolchain
	rustfmt = true,
	codelldb = false,
	-- codelldb has binaries for many platforms; keep it optional
}

-- Build a filtered list that only includes tools whose toolchains are present
local filtered_tools = {}
for _, t in ipairs(essential_tools) do
	local name = t
	-- normalize (mason names sometimes include dashes; use direct match)
	if requires_go[name] and not has_go then
		-- skip
	elseif requires_rust[name] and not has_rust then
		-- skip
	else
		table.insert(filtered_tools, t)
	end
end

-- Use filtered_tools for auto install / health checks below
-- Auto-install conditional uses 'filtered_tools' instead of 'essential_tools'

if auto_install_on_start then
	vim.defer_fn(function()
		local ok, mason_registry = pcall(require, 'mason-registry')
		if not ok then
			return
		end
		for _, tool in ipairs(filtered_tools) do
			local ok2, package = pcall(mason_registry.get_package, tool)
			if ok2 and package and not package:is_installed() then
				-- install safely and ignore per-package errors
				pcall(function()
					package:install()
				end)
			end
		end
	end, 1000)
end

-- Provide a safe manual installer that the user can run: :MasonInstallEssential
vim.api.nvim_create_user_command("MasonInstallEssential", function()
	local ok, mason_registry = pcall(require, 'mason-registry')
	if not ok then
		vim.notify('mason-registry not available', vim.log.levels.ERROR)
		return
	end
	local installed = {}
	for _, tool in ipairs(filtered_tools) do
		local ok2, package = pcall(mason_registry.get_package, tool)
		if not ok2 or not package then
			vim.notify('Mason: package not found for ' .. tool, vim.log.levels.WARN)
		else
			if not package:is_installed() then
				vim.notify('Mason: Installing ' .. tool .. ' (this may fail if toolchain missing)', vim.log.levels.INFO)
				local ok_inst = pcall(function()
					package:install()
				end)
				if not ok_inst then
					vim.notify('Mason: Failed installing ' .. tool, vim.log.levels.WARN)
				else
					table.insert(installed, tool)
				end
			end
		end
	end
	if #installed > 0 then
		vim.notify('Installed: ' .. table.concat(installed, ', '), vim.log.levels.INFO)
	else
		vim.notify('No new packages installed', vim.log.levels.INFO)
	end
end, { desc = 'Manually install essential Mason tools safely' })

vim.api.nvim_create_autocmd("User", { pattern = "MasonToolsStartingInstall", callback = function()
	vim.schedule(function()
		vim.notify("Installing Mason tools in background...", vim.log.levels.INFO)
	end)
end })
vim.api.nvim_create_autocmd("User", { pattern = "MasonToolsUpdateCompleted", callback = function()
	vim.schedule(function()
		vim.notify("Mason tools installation completed!", vim.log.levels.INFO)
	end)
end })

vim.keymap.set("n", "<leader>mm", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>mi", "<cmd>MasonInstall<cr>", { desc = "Mason install" })
vim.keymap.set("n", "<leader>mu", "<cmd>MasonUpdate<cr>", { desc = "Mason update" })
vim.keymap.set("n", "<leader>ml", "<cmd>MasonLog<cr>", { desc = "Mason log" })
vim.keymap.set("n", "<leader>mt", "<cmd>MasonToolsInstall<cr>", { desc = "Mason tools" })
vim.keymap.set("n", "<leader>mU", "<cmd>MasonToolsUpdate<cr>", { desc = "Mason tools update" })

-- Update MasonCheckHealth to inspect filtered_tools
vim.api.nvim_create_user_command("MasonCheckHealth", function()
	local mason_registry = require('mason-registry')
	local missing = {}
	for _, tool in ipairs(filtered_tools) do
		local ok, package = pcall(mason_registry.get_package, tool)
		if ok and package and not package:is_installed() then
			table.insert(missing, tool)
		end
	end
	if #missing > 0 then
		vim.notify("Missing tools: " .. table.concat(missing, ", ") .. "\nRun :MasonInstallEssential to install safely", vim.log.levels.WARN)
	else
		vim.notify("All essential tools (for available toolchains) are installed!", vim.log.levels.INFO)
	end
end, { desc = "Check for missing Mason tools" })
