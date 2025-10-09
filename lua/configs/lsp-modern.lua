-- Advanced Modern LSP Configuration
local ok, util = pcall(require, 'lspconfig.util')
if not ok then
	return
end

-- Load enhanced LSP features
local lsp_enhanced = require('configs.lsp-enhanced')
lsp_enhanced.setup()

-- Enhanced capabilities with ALL advanced features
local capabilities = lsp_enhanced.setup_enhanced_capabilities()
local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
	capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
end

-- Enhanced on_attach with optimal TSServer/Biome configuration
local function on_attach(client, bufnr)
	-- Optimize client capabilities to prevent conflicts
	if client.name == 'biome' then
		-- Biome: Keep linting/formatting, disable IntelliSense
		client.server_capabilities.completionProvider = false
		client.server_capabilities.hoverProvider = false
		client.server_capabilities.definitionProvider = false
	elseif client.name == 'tsserver' then
		-- TSServer: Keep IntelliSense, disable formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	elseif client.name == 'html' and (vim.bo[bufnr].filetype:match('react') or vim.bo[bufnr].filetype:match('typescript')) then
		client.server_capabilities.completionProvider = false
	elseif client.name == 'emmet_ls' and (vim.bo[bufnr].filetype:match('typescript') or vim.bo[bufnr].filetype:match('javascript')) then
		client.server_capabilities.completionProvider = false
	end

	-- Apply enhanced on_attach
	lsp_enhanced.enhanced_on_attach(client, bufnr)
end

-- Diagnostic configuration is handled by lsp-enhanced module

local function setup_server(name, config)
	config = config or {}
	config.capabilities = capabilities
	config.on_attach = on_attach
	
	-- Use new vim.lsp.config if available (Neovim 0.11+)
	if vim.lsp.config and vim.fn.has('nvim-0.11') == 1 then
		vim.lsp.config[name] = config
	else
		require('lspconfig')[name].setup(config)
	end
end

-- Advanced server configurations (prioritizing performance)
local servers = {
	-- Lua (fastest: written in C++)
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
				telemetry = { enable = false }, hint = { enable = true },
			},
		},
	},

	-- JS/TS: Biome (Rust) - fastest, replaces ESLint/Prettier
	biome = { 
		root_dir = util.root_pattern('biome.json', 'package.json', '.git'),
		settings = {
			biome = {
				linter = { enabled = true },
				formatter = { enabled = true },
				organizeImports = { enabled = true },
			},
		},
	},

	-- Systems languages (all native/compiled)
	rust_analyzer = {
		root_dir = util.root_pattern('Cargo.toml', '.git'),
		settings = {
			['rust-analyzer'] = {
				cargo = { allFeatures = true }, checkOnSave = { command = 'clippy' },
				inlayHints = { parameterHints = { enable = true }, typeHints = { enable = true } },
			},
		},
	},
	gopls = {
		root_dir = util.root_pattern('go.mod', 'go.work', '.git'),
		settings = {
			gopls = {
				analyses = { unusedparams = true, shadow = true },
				staticcheck = true, gofumpt = true, usePlaceholders = true,
				hints = { assignVariableTypes = true, compositeLiteralFields = true, constantValues = true },
			},
		},
	},
	clangd = {
		root_dir = util.root_pattern('CMakeLists.txt', 'compile_commands.json', '.git'),
		cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu', '--completion-style=detailed', '--function-arg-placeholders' },
		init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
	},
	zls = { root_dir = util.root_pattern('build.zig', 'zls.json', '.git') },

	-- Web stack (keep only essential)
	tailwindcss = {
		root_dir = util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'package.json', '.git'),
		settings = { tailwindCSS = { classAttributes = { 'class', 'className', 'classList', 'ngClass' } } },
	},

	-- TypeScript server (for React projects without Biome)
	tsserver = {
		root_dir = util.root_pattern('package.json', 'tsconfig.json', '.git'),
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
		init_options = {
			preferences = {
				disableSuggestions = false,
			},
		},
	},

	-- Other essential servers
	pyright = {
		root_dir = util.root_pattern('pyproject.toml', 'setup.py', 'requirements.txt', '.git'),
		settings = { python = { analysis = { autoSearchPaths = true, diagnosticMode = 'workspace', useLibraryCodeForTypes = true } } },
	},
	jdtls = { root_dir = util.root_pattern('pom.xml', 'build.gradle', '.git') },
	sqls = { root_dir = util.root_pattern('.sqls.yml', 'schema.sql', '.git') },
	prismals = { root_dir = util.root_pattern('schema.prisma', 'package.json', '.git') },
}

-- Setup all servers
for server, config in pairs(servers) do
	setup_server(server, config)
end

-- Setup basic servers
local basic_servers = { 'bashls', 'cmake', 'kotlin_language_server', 'intelephense', 'vimls', 'html', 'cssls', 'jsonls', 'yamlls', 'emmet_ls' }
for _, server in ipairs(basic_servers) do
	setup_server(server)
end



-- Global keymaps are handled by lsp-enhanced module