local M = {}

-- Default LSP config that applies to all servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_nvim_lsp.default_capabilities()
end

local default_config = {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

		-- Mappings
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	end,
}

function M.setup()
	-- Configure diagnostic signs
	local signs = {
		{ name = "DiagnosticSignError", text = "󰅙", texthl = "DiagnosticSignError" },
		{ name = "DiagnosticSignWarn", text = "󰀦", texthl = "DiagnosticSignWarn" },
		{ name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticSignInfo" },
		{ name = "DiagnosticSignHint", text = "󰌵", texthl = "DiagnosticSignHint" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, {
			texthl = sign.texthl,
			text = sign.text,
			numhl = sign.numhl or "",
		})
	end

	-- Configure diagnostics display
	vim.diagnostic.config({
		virtual_text = true,
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
			prefix = "",
		},
	})

	-- Set up handlers
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

	-- Ensure mason is set up first
	local mason_ok, mason = pcall(require, "mason")
	if not mason_ok then
		vim.notify("mason.nvim not found", vim.log.levels.ERROR)
		return
	end
	mason.setup()

	-- Set up mason-lspconfig
	--    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	--    if not mason_lspconfig_ok then
	--        vim.notify("mason-lspconfig.nvim not found", vim.log.levels.ERROR)
	--        return
	--    end
	--
	--    mason_lspconfig.setup({
	--        ensure_installed = {
	--            "lua_ls",
	--            "clangd",
	--            "pyright",
	--            "tsserver",
	--            "rust_analyzer",
	--        },
	--        automatic_installation = true,
	--    })
	--
	--    -- Set up servers
	--    mason_lspconfig.setup_handlers({
	--        function(server_name)
	--            local config = vim.tbl_deep_extend("force", default_config, {})
	--            require("lspconfig")[server_name].setup(config)
	--        end,
	--
	--        -- Custom server configurations
	--        ["clangd"] = function()
	--            require("lspconfig").clangd.setup(vim.tbl_deep_extend("force", default_config, {
	--                cmd = {
	--                    "clangd",
	--                    "--background-index",
	--                    "--suggest-missing-includes",
	--                    "--clang-tidy",
	--                    "--header-insertion=iwyu",
	--                },
	--            }))
	--        end,
	--    })

	-- Set up file type detection
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = {
			-- Web development
			"*.js",
			"*.jsx",
			"*.ts",
			"*.tsx",
			"*.html",
			"*.css",
			"*.scss",
			"*.sass",
			-- Configuration files
			"*.json",
			"*.yaml",
			"*.yml",
			-- Lua
			"*.lua",
			-- Other common formats
			"*.md",
			"*.toml",
		},
		callback = function()
			-- Ensure LSP is started immediately
			vim.cmd([[LspStart]])
		end,
	})

	-- Enable format on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function()
			vim.lsp.buf.format({ async = false })
		end,
	})
end

return M
