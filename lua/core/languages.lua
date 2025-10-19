local M = {}

-- Core language configuration
local languages = {
	lua = {
		formatter = "stylua",
		lsp = "lua_ls",
		lsp_settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	},
	python = {
		formatter = "black",
		lsp = "pyright",
		lsp_settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
	},
	rust = {
		formatter = "rustfmt",
		lsp = "rust_analyzer",
		lsp_settings = {
			["rust-analyzer"] = {
				checkOnSave = { command = "clippy" },
				cargo = { allFeatures = true },
				procMacro = { enable = true },
				diagnostics = { experimental = { enable = true } },
			},
		},
	},
	go = {
		formatter = "gofmt",
		lsp = "gopls",
		lsp_settings = {
			gopls = {
				analyses = { unusedparams = true },
				staticcheck = true,
				gofumpt = true,
				usePlaceholders = true,
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},
	typescript = {
		formatter = "prettier",
		lsp = "tsserver",
		lsp_settings = {
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},
	cpp = {
		formatter = "clang-format",
		lsp = "clangd",
		lsp_settings = {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
		},
	},
}

-- LSP setup function
function M.setup()
	local lspconfig = require("lspconfig")
	local mason = require("mason")
	--    local mason_lspconfig = require("mason-lspconfig")
	--    local null_ls = require("null-ls")
	local lsp_defaults = require("core.lsp").setup()

	-- Initialize Mason
	mason.setup({
		ui = {
			border = "rounded",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	-- Configure language servers
	--    mason_lspconfig.setup({
	--        ensure_installed = vim.tbl_map(function(lang) return lang.lsp end, languages),
	--        automatic_installation = true,
	--    })
	--
	--    -- Configure formatters and linters through null-ls
	--    local formatting = null_ls.builtins.formatting
	--    local diagnostics = null_ls.builtins.diagnostics
	--
	--    null_ls.setup({
	--        border = "rounded",
	--        sources = {
	--            -- Formatters
	--            formatting.stylua,
	--            formatting.black,
	--            formatting.prettier.with({
	--                extra_filetypes = { "svelte", "astro" },
	--            }),
	--            formatting.rustfmt,
	--            formatting.gofmt,
	--            formatting.clang_format,
	--
	--            -- Linters
	--            diagnostics.eslint_d,
	--            diagnostics.shellcheck,
	--            diagnostics.luacheck.with({
	--                extra_args = { "--globals", "vim" },
	--            }),
	--        },
	--    })

	-- Configure each language server
	for lang_name, lang_config in pairs(languages) do
		if lspconfig[lang_config.lsp] then
			local config = vim.tbl_deep_extend("force", lsp_defaults, { settings = lang_config.lsp_settings or {} })

			lspconfig[lang_config.lsp].setup(config)
		end
	end

	-- Set up autoformatting
	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function(opts)
			-- Get the filetype
			local filetype = vim.bo[opts.buf].filetype

			-- Check if we have a formatter for this filetype
			for lang_name, lang_config in pairs(languages) do
				if filetype == lang_name and lang_config.formatter then
					vim.lsp.buf.format({ timeout_ms = 2000, async = false })
					break
				end
			end
		end,
	})

	return true
end

return M
