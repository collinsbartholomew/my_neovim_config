-- God-Level LSP Enhancement Features
local M = {}

-- Enhanced LSP capabilities with all modern features
function M.setup_enhanced_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	
	-- Completion enhancements
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" }
	}
	
	-- Advanced LSP features
	capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
	capabilities.textDocument.semanticTokens = { multilineTokenSupport = true }
	capabilities.textDocument.inlayHint = { dynamicRegistration = true }
	capabilities.textDocument.codeLens = { dynamicRegistration = true }
	capabilities.textDocument.documentHighlight = { dynamicRegistration = true }
	capabilities.textDocument.linkedEditingRange = { dynamicRegistration = true }
	capabilities.textDocument.colorProvider = { dynamicRegistration = true }
	
	-- Workspace features
	capabilities.workspace = {
		didChangeWatchedFiles = { dynamicRegistration = true },
		workspaceFolders = true,
		configuration = true,
		semanticTokens = { refreshSupport = true },
		codeLens = { refreshSupport = true },
		inlayHint = { refreshSupport = true },
	}
	
	return capabilities
end

-- Enhanced on_attach with all god-level features
function M.enhanced_on_attach(client, bufnr)
	local opts = { buffer = bufnr, silent = true }
	
	-- Core LSP mappings
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
	
	-- Advanced workspace features
	vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	
	-- Inlay hints (god-level feature)
	if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		vim.keymap.set('n', '<leader>ih', function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
			vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"))
		end, opts)
	end
	
	-- Code lens (JetBrains-like)
	if client.server_capabilities.codeLensProvider and vim.lsp.codelens then
		vim.lsp.codelens.refresh({ bufnr = bufnr })
		vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
		vim.keymap.set('n', '<leader>cr', function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end, opts)
		
		-- Auto-refresh code lens
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
		})
	end
	
	-- Document highlights (illuminate references)
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references,
		})
	end
	
	-- Call hierarchy (JetBrains-like navigation)
	if client.server_capabilities.callHierarchyProvider then
		vim.keymap.set('n', '<leader>ci', vim.lsp.buf.incoming_calls, opts)
		vim.keymap.set('n', '<leader>co', vim.lsp.buf.outgoing_calls, opts)
	end
	
	-- Type hierarchy (advanced navigation)
	if client.server_capabilities.typeHierarchyProvider then
		vim.keymap.set('n', '<leader>st', vim.lsp.buf.supertypes, opts)
		vim.keymap.set('n', '<leader>it', vim.lsp.buf.subtypes, opts)
	end
	
	-- Semantic tokens (syntax highlighting++)
	if client.server_capabilities.semanticTokensProvider then
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.semantic_tokens.force_refresh(bufnr)
			end,
		})
	end
	

end

-- Enhanced diagnostic configuration
function M.setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = {
			prefix = "●",
			source = "if_many",
			spacing = 2,
			severity_limit = "Warning"
		},
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = ""
		},
	})
	
	-- Enhanced diagnostic signs
	local signs = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " "
	}
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

-- Global LSP keymaps for god-level productivity
function M.setup_global_keymaps()
	vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
	vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist)
	
	
end

-- Initialize all enhanced features
function M.setup()
	M.setup_diagnostics()
	M.setup_global_keymaps()
end

return M