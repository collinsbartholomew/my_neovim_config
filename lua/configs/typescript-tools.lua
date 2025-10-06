-- Enhanced TypeScript tools configuration
local ok, typescript_tools = pcall(require, "typescript-tools")
if not ok then
	vim.notify("typescript-tools not available", vim.log.levels.WARN)
	return
end

typescript_tools.setup({
	on_attach = function(client, bufnr)
		-- Disable semantic tokens to prevent conflicts
		client.server_capabilities.semanticTokensProvider = nil

		-- Prevent duplicate completions from other servers
		if client.name == "typescript-tools" then
			-- Disable other TS-related servers for these filetypes
			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			for _, other_client in ipairs(clients) do
				if other_client.name == "html" or other_client.name == "emmet_ls" then
					if vim.bo[bufnr].filetype:match("typescript") or vim.bo[bufnr].filetype:match("javascript") then
						other_client.server_capabilities.completionProvider = false
					end
				end
			end
		end

		-- Standard LSP keybindings
		local opts = { buffer = bufnr, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- TypeScript-specific commands
		vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", opts)
		vim.keymap.set("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", opts)
		vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnused<cr>", opts)
		vim.keymap.set("n", "<leader>td", "<cmd>TSToolsGoToSourceDefinition<cr>", opts)
		vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRenameFile<cr>", opts)
		vim.keymap.set("n", "<leader>tf", "<cmd>TSToolsFixAll<cr>", opts)
	end,

	handlers = {
		-- Disable some noisy handlers
		["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
			-- Filter out some noisy diagnostics
			if result and result.diagnostics then
				result.diagnostics = vim.tbl_filter(function(diagnostic)
					-- Filter out some common noisy diagnostics
					return not (
						diagnostic.message:match("is declared but its value is never read")
						and diagnostic.severity == 4
					)
				end, result.diagnostics)
			end
			vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
		end,
	},

	settings = {
		-- Separate tsserver instance
		separate_diagnostic_server = true,
		-- Publish diagnostic on insert mode
		publish_diagnostic_on = "insert_leave",
		-- Array of strings("fix_all"|"add_missing_imports"|"remove_unused"|"remove_unused_imports"|"organize_imports")
		expose_as_code_action = {},
		-- String|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
		tsserver_path = nil,
		-- Specify a list of plugins to load by tsserver, e.g., for support `styled-components`
		tsserver_plugins = {},
		-- This value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
		tsserver_max_memory = "auto",
		-- Described below
		tsserver_format_options = {},
		tsserver_file_preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
			importModuleSpecifier = "relative",
		},
		-- Mirror of VSCode's `typescript.suggest` settings
		complete_function_calls = true,
		include_completions_with_insert_text = true,
		-- CodeLens
		code_lens = "off",
		-- Inlay hints
		disable_member_code_lens = true,
		jsx_close_tag = {
			enable = false,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
})

