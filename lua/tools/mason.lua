local M = {}

function M.setup()
	-- Configure Mason
	require("mason").setup({
		ui = {
			border = "rounded",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		max_concurrent_installers = 20,
		pip = {
			upgrade_pip = true,
		},
		registries = {
			"github:mason-org/mason-registry",
		},
	})

	-- Configure Mason-LSPConfig integration
	--	local ml_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	--	if not ml_ok then
	--		vim.notify("mason-lspconfig not found; skipping mason-lspconfig setup", vim.log.levels.WARN)
	--	else
	--		mason_lspconfig.setup({
	--			automatic_installation = true,
	--			ensure_installed = {
	--				-- Use lspconfig server names (mason-lspconfig expects these)
	--				"html",
	--				"cssls",
	--				"tsserver",
	--				"eslint",
	--				"tailwindcss",
	--				"yamlls",
	--				"bashls",
	--				"cmake",
	--			},
	--		})
	--
	--		-- Set up handlers for mason-lspconfig
	--		local ok, lspconfig = pcall(require, "lspconfig")
	--		if not ok then
	--			vim.notify("nvim-lspconfig not available; mason-lspconfig handlers won't be attached", vim.log.levels.WARN)
	--		else
	--			mason_lspconfig.setup_handlers({
	--				-- Default handler
	--				function(server_name)
	--					if lspconfig[server_name] and type(lspconfig[server_name].setup) == "function" then
	--						lspconfig[server_name].setup({})
	--					else
	--						vim.notify(
	--							"mason-lspconfig: lspconfig server '" .. server_name .. "' not found",
	--							vim.log.levels.WARN
	--						)
	--					end
	--				end,
	--				-- Custom handlers
	--				["lua_ls"] = function()
	--					if lspconfig.lua_ls then
	--						lspconfig.lua_ls.setup({
	--							settings = {
	--								Lua = {
	--									diagnostics = {
	--										globals = { "vim" },
	--									},
	--									workspace = {
	--										library = vim.api.nvim_get_runtime_file("", true),
	--										checkThirdParty = false,
	--									},
	--									telemetry = {
	--										enable = false,
	--									},
	--								},
	--							},
	--						})
	--					end
	--				end,
	--			})
	--		end
	--	end
end

return M
