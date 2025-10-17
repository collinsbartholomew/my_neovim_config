--Mason configuration (moved to configs/tools/mason.lua)
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

-- Auto-install essential tools in background
local essential_tools = {
	"eslint_d", "htmlhint", "stylelint", "jsonlint", "yamllint", "shellcheck", "hadolint", "luacheck", "ruff", "mypy", "golangci-lint", "gosec", "sqlfluff",
	"cargo-audit", "dependency-check",
	"lua-language-server", "rust-analyzer", "clangd", "gopls", "jdtls", "asm-lsp", "pyright", "omnisharp", "elixir-ls", "vtsls", "eslint-lsp", "tailwindcss-language-server", "css-lsp", "html-lsp", "emmet-ls", "lemminx", "prisma-language-server", "cmake-language-server",
	"prettier", "prettierd", "stylua", "black", "isort", "clang-format", "gofumpt", "goimports", "rustfmt", "google-java-format", "csharpier", "cmakelang",
	"js-debug-adapter", "codelldb", "delve","java-debug-adapter", "debugpy", "netcoredbg",
}

vim.defer_fn(function()
	local ok, mason_registry = pcall(require, 'mason-registry')
	if not ok then
		return
	end
	for _, tool in ipairs(essential_tools) do
		local ok2, package= pcall(mason_registry.get_package, tool)
		if ok2 and package and not package:is_installed() then
			package:install()
		end
	end
end, 1000)

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
vim.keymap.set("n", "<leader>mi", "<cmd>MasonInstall<cr>", { desc ="Mason install" })
vim.keymap.set("n", "<leader>mu", "<cmd>MasonUpdate<cr>", { desc = "Mason update" })
vim.keymap.set("n", "<leader>ml", "<cmd>MasonLog<cr>", { desc = "Mason log" })
vim.keymap.set("n", "<leader>mt", "<cmd>MasonToolsInstall<cr>", { desc = "Mason tools" })
vim.keymap.set("n", "<leader>mU", "<cmd>MasonToolsUpdate<cr>", { desc = "Mason tools update" })

vim.api.nvim_create_user_command("MasonCheckHealth", function()
	local mason_registry = require('mason-registry')
	local missing = {}
	for _, tool in ipairs(essential_tools) do
		local ok, package = pcall(mason_registry.get_package, tool)
		if ok and package and not package:is_installed()then
			table.insert(missing, tool)
		end
	end
	if #missing > 0 then
		vim.notify("Missing tools: " .. table.concat(missing, ", ") .. "\nRun :Mason to install", vim.log.levels.WARN)
	else
		vim.notify("All essentialtools are installed!", vim.log.levels.INFO)
	end
end, { desc = "Check for missing Mason tools" })

