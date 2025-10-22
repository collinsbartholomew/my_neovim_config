--LSP and Mason setup
-- added-by-agent: zig-setup 20251020
local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
	vim.notify("Mason is not available", vim.log.levels.WARN)
	return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
	vim.notify("Mason-lspconfig is not available", vim.log.levels.WARN)
	return
end

local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status_ok then
	vim.notify("cmp_nvim_lsp is not available", vim.log.levels.WARN)
	return
end

-- LSP capabilitieswith nvim-cmp
local capabilities =
	vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())

-- Enhanced capabilities for better LSP features
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.textDocument.codeAction = {
	dynamicRegistration = false,
	codeActionLiteralSupport = {
		codeActionKind = {
			valueSet = (vim.tbl_keys(vim.lsp.protocol.CodeActionKind)),
		},
	},
}

-- Common on_attach function for LSP
local function on_attach(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Attachnvim-navic
	localnavic = require("nvim-navic")
	navic.attach(client, bufnr)

	-- Buffer local mappings
	local opts = { buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<space>wl", function()
print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

	-- Enhanced navigation
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async =true })
	end, opts)
	vim.keymap.set("n", "<space>ld", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

	-- Format on save if server supports it
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback= function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					filter = function(fclient)
						return fclient.name == client.name
					end,
				})
			end,
		})
	end

	-- Enable code lens if supported
	if client.server_capabilities.codeLensProvider then
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh()
			end,
		})
	end
end

-- InitializeMason
mason.setup({
ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Configure specific language servers with enhanced settings
local servers = {
	lua_ls = {
		settings = {
			Lua = {
diagnostics = {
					globals = { "vim", "describe", "it", "before_each", "after_each" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME")] = true,
						[vim.fn.stdpath("data") .. "/lazy/plenary.nvim/lua"] = true,
						[vim.fn.stdpath("data") .. "/lazy/nvim-dap/lua"] = true,
						[vim.fn.stdpath("config") .."/lua"] = true,
					},
					checkThirdParty = false,
				},
				completion = {
					callSnippet = "Replace",
				},
				hint = {
					enable = true,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				cargo = {
					loadOutDirsFromCheck = true,
				},
				checkOnSave = {
					command = "clippy",
				},
				procMacro = {
				enable = true,
				},
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	},
	clangd ={
		cmd = {
			"clangd",
			"--background-index",
			"--suggest-missing-includes",
			"--clang-tidy",
			"--header-insertion=iwyu",
		},
	},
	qmlls = {
		cmd = { "qmlls" },
	filetypes = { "qml", "qmlproject" },
	},
	zls = {
		settings = {
			enable_build_on_save = true,
			semantic_tokens = "full",
			zig_lib_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/zls/bin/"),
			zig_exe_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/zls/bin/zls"),
		},
	},
	ts_ls = {
		init_options = {
			plugins = {
				{
					name = "@vue/typescript-plugin",
					location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
					languages = { "vue" },
				},
			},
		},
		filetypes = { "typescript", "typescriptreact", "typescript.tsx", "vue" },
	},
	pyright = {
		settings = {
			python = {
				analysis = {
				autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
				},
			},
		},
	},
	jdtls = {},
	asm_lsp = {
		filetypes = { "asm", "s", "S", "nasm", "gas" },
		root_dir = require("lspconfig").util.root_pattern(".git", "Makefile"),
		settings = {
			asm = {
				includePaths = {
					"/usr/include",
				},
				defines = {
					["ARCH_X86_64"] = "1",
				},
			},
		},
	},
	omnisharp = {
		cmd = { "omnisharp" },
		filetypes = { "cs", "vb" },
		root_dir = require("lspconfig").util.root_pattern(".sln", ".csproj", ".git"),
	settings = {
			FormattingOptions = {
				EnableEditorConfigSupport = true,
				OrganizeImports = true,
			},
			MsBuild = {
				LoadProjectsOnDemand = true,
				UseLegacySdkResolver = false,
			},
			RoslynExtensionsOptions = {
				EnableAnalyzersSupport = true,
				AnalyzersSupport = true,
				EnableImportCompletion = true,
				EnableAsyncCompletion = true,
				DocumentAnalysisTimeoutMs = 30000,
			},
			OmniSharp = {
				UseModernNet = true,
				EnableDecompilationSupport = true,
				EnableLspEditorSupport = true,
				EnableCSharp7Support = true,
				EnableCSharp8Support = true,
				EnableCSharp9Support = true,
				EnableCSharp10Support = true,
				EnableCSharp11Support= true,
			},
		},
	},
	mojo = {
		cmd = { "mojo-lsp-server" },
		filetypes = { "mojo", "🔥" },
		root_dir = require("lspconfig").util.root_pattern(".git", "main.mojo", "main.🔥"),
		settings = {
			mojo = {
				-- Add any specific Mojo LSP settings here
			},
		},
	},
}

--Setupmason-lspconfig to automatically enable installed servers
mason_lspconfig.setup({
	ensure_installed = {
		"lua_ls",
	"rust_analyzer",
		"gopls",
		"clangd",
		"qmlls",
		"zls",
		"ts_ls",
		"pyright",
		"jdtls",
		"asm_lsp",
		"omnisharp",
	},
	automatic_installation = true,
})

-- Setup each language server manually since we need custom configurations
for server_name, config in pairs(servers) do
	config.on_attach = on_attach
	config.capabilities = capabilities
	vim.lsp.config(server_name, config)
end
