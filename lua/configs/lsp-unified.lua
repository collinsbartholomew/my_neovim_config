-- Unified God-Level LSP Configuration
-- Combines all features without conflicts

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Enhanced capabilities with ALL advanced features
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
end

-- Advanced capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
capabilities.textDocument.semanticTokens = { multilineTokenSupport = true }
capabilities.textDocument.inlayHint = { dynamicRegistration = true }
capabilities.textDocument.codeLens = { dynamicRegistration = true }
capabilities.textDocument.documentHighlight = { dynamicRegistration = true }
capabilities.textDocument.linkedEditingRange = { dynamicRegistration = true }
capabilities.textDocument.colorProvider = { dynamicRegistration = true }
capabilities.workspace = {
	didChangeWatchedFiles = { dynamicRegistration = true },
	workspaceFolders = true,
	configuration = true,
	semanticTokens = { refreshSupport = true },
	codeLens = { refreshSupport = true },
	inlayHint = { refreshSupport = true },
}
capabilities.semanticTokensProvider = { full = { delta = true } }

-- Unified on_attach with all features
local function unified_on_attach(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Prevent duplicate completions from multiple servers
	if
		client.name == "html" and (vim.bo[bufnr].filetype:match("react") or vim.bo[bufnr].filetype:match("typescript"))
	then
		client.server_capabilities.completionProvider = false
	end
	if
		client.name == "emmet_ls"
		and (vim.bo[bufnr].filetype:match("typescript") or vim.bo[bufnr].filetype:match("javascript"))
	then
		client.server_capabilities.completionProvider = false
	end

	-- Core LSP mappings with safety checks
	if vim.lsp.buf.definition then
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	end
	if vim.lsp.buf.declaration then
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	end
	if vim.lsp.buf.implementation then
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	end
	if vim.lsp.buf.references then
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end
	if vim.lsp.buf.hover then
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	end
	if vim.lsp.buf.signature_help then
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	end
	if vim.lsp.buf.rename then
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	end
	if vim.lsp.buf.code_action then
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end
	if vim.lsp.buf.format then
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end

	-- Advanced LSP features with safety checks
	if vim.lsp.buf.workspace_symbol then
		vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
	end
	if vim.lsp.buf.add_workspace_folder then
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	end
	if vim.lsp.buf.remove_workspace_folder then
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	end

	-- Inlay hints disabled by default with safety checks
	if client.server_capabilities and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		vim.keymap.set("n", "<leader>ih", function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		end, opts)
	end

	-- Code lens with safety checks
	if client.server_capabilities and client.server_capabilities.codeLensProvider and vim.lsp.codelens then
		pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
		vim.keymap.set("n", "<leader>cl", function()
			pcall(vim.lsp.codelens.run)
		end, opts)
		vim.keymap.set("n", "<leader>cr", function()
			pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
		end, opts)
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
			end,
		})
	end

	-- Document highlights
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = group,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = group,
			callback = vim.lsp.buf.clear_references,
		})
	end

	-- Call/Type hierarchy with safety checks
	if client.server_capabilities.callHierarchyProvider and vim.lsp.buf.incoming_calls then
		vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, opts)
	end
	if client.server_capabilities.callHierarchyProvider and vim.lsp.buf.outgoing_calls then
		vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, opts)
	end
	if client.server_capabilities.typeHierarchyProvider and vim.lsp.buf.typehierarchy then
		vim.keymap.set("n", "<leader>st", function()
			vim.lsp.buf.typehierarchy("supertypes")
		end, opts)
		vim.keymap.set("n", "<leader>it", function()
			vim.lsp.buf.typehierarchy("subtypes")
		end, opts)
	end
end

-- Enhanced diagnostic configuration
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
		spacing = 2,
		severity_limit = "Warning",
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
		prefix = "",
	},
})

-- Enhanced diagnostic signs
local signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Unified server configurations
local servers = {
	-- Core Language Servers
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
				hint = { enable = true },
			},
		},
	},

	biome = {
		root_dir = util.root_pattern("biome.json", "package.json", ".git"),
	},

	tailwindcss = {
		root_dir = util.root_pattern("tailwind.config.js", "tailwind.config.ts", "package.json", ".git"),
		settings = {
			tailwindCSS = {
				classAttributes = { "class", "className", "classList", "ngClass" },
				experimental = {
					classRegex = {
						"tw`([^`]*)",
						'tw="([^"]*)',
						"tw={'([^'}]*)",
						"tw\\.\\w+`([^`]*)",
						"tw\\(.*?\\)`([^`]*)",
					},
				},
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidConfigPath = "error",
					invalidTailwindDirective = "error",
					recommendedVariantOrder = "warning",
				},
			},
		},
	},

	-- Database Stack
	prismals = {
		root_dir = util.root_pattern("schema.prisma", "package.json", ".git"),
		settings = {
			prisma = {
				showInfos = true,
			},
		},
	},

	sqls = {
		root_dir = util.root_pattern(".sqls.yml", "schema.sql", ".git"),
		settings = {
			sqls = {
				connections = {
					{
						driver = "postgresql",
						dataSourceName = "postgresql://localhost/mydb?sslmode=disable",
					},
				},
			},
		},
	},

	-- Systems Engineering Stack
	rust_analyzer = {
		root_dir = util.root_pattern("Cargo.toml", ".git"),
		settings = {
			["rust-analyzer"] = {
				cargo = { allFeatures = true },
				checkOnSave = { command = "clippy" },
				inlayHints = {
					bindingModeHints = { enable = false },
					chainingHints = { enable = true },
					closingBraceHints = { enable = true, minLines = 25 },
					closureReturnTypeHints = { enable = "never" },
					lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = false },
					maxLength = 25,
					parameterHints = { enable = true },
					reborrowHints = { enable = "never" },
					renderColons = true,
					typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
				},
			},
		},
	},

	gopls = {
		root_dir = util.root_pattern("go.mod", "go.work", ".git"),
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
				gofumpt = true,
				usePlaceholders = true,
				directoryFilters = { "-node_modules", "-vendor" },
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},

	clangd = {
		root_dir = util.root_pattern("CMakeLists.txt", "compile_commands.json", ".git"),
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
		},
		init_options = {
			usePlaceholders = true,
			completeUnimported = true,
			clangdFileStatus = true,
		},
	},

	pyright = {
		root_dir = util.root_pattern("pyproject.toml", "setup.py", "requirements.txt", ".git"),
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
					typeCheckingMode = "basic",
				},
			},
		},
	},

	jdtls = {
		root_dir = util.root_pattern("pom.xml", "build.gradle", ".git"),
		settings = {
			java = {
				configuration = {
					updateBuildConfiguration = "interactive",
				},
				completion = {
					favoriteStaticMembers = {
						"org.hamcrest.MatcherAssert.assertThat",
						"org.hamcrest.Matchers.*",
						"org.junit.jupiter.api.Assertions.*",
						"java.util.Objects.requireNonNull",
						"org.mockito.Mockito.*",
					},
				},
			},
		},
	},

	dartls = {
		root_dir = util.root_pattern("pubspec.yaml", ".git"),
		settings = {
			dart = {
				completeFunctionCalls = true,
				showTodos = true,
			},
		},
	},

	zls = {
		root_dir = util.root_pattern("build.zig", "zls.json", ".git"),
	},
}

-- Setup all servers
for server, config in pairs(servers) do
	config.capabilities = capabilities
	config.on_attach = unified_on_attach
	lspconfig[server].setup(config)
end

-- Setup basic servers
local basic_servers = {
	"bashls",
	"cmake",
	"kotlin_language_server",
	"intelephense",
	"vimls",
	"html",
	"cssls",
	"jsonls",
	"yamlls",
	"emmet_ls",
}

for _, server in ipairs(basic_servers) do
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = unified_on_attach,
	})
end

-- Global LSP keymaps
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

-- Global refresh commands
vim.keymap.set("n", "<leader>lR", function()
	local bufnr = vim.api.nvim_get_current_buf()
	for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client.server_capabilities.workspaceSymbolProvider then
			client.request("workspace/didChangeWatchedFiles", {
				changes = {},
			})
		end
	end
	vim.lsp.codelens.refresh({ bufnr = bufnr })
	if vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
	vim.notify("LSP workspace refreshed", vim.log.levels.INFO)
end, { desc = "Refresh all LSP features" })

