-- added-by-agent: web-setup 20251020-173000
-- mason: tsserver, tailwindcss-language-server, prettier, eslint
-- manual: node.js installation required

local M = {}

function M.setup()
    local lspconfig_status, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_status then
        vim.notify("lspconfig not available for web setup", vim.log.levels.WARN)
        return
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_nvim_lsp_status then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    -- Enhanced on_attach function for all web LSPs
    local function on_attach(client, bufnr)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

        -- Enable inlay hints if available
        pcall(function()
            if client.supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint(bufnr, true)
            end
        end)
        
        -- Enable document formatting if supported
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
        end
    end

    -- TypeScript/JavaScript LSP with enhanced configuration
    lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
            preferences = {
                disableSuggestions = false,
                quotePreference = "auto",
                includePackageJsonAutoImports = "auto",
                importModuleSpecifierPreference = "shortest",
                importModuleSpecifierEnding = "auto",
                allowTextChangesInNewFiles = true,
                lazyConfiguredProjectsFromExternalProject = false,
                providePrefixAndSuffixTextForRename = true,
                allowRenameOfImportPath = true,
                separateNamedImports = true,
            }
        },
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                }
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                }
            }
        }
    })

    -- HTML LSP with enhanced configuration
    lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            html = {
                suggest = {
                    html5 = true
                },
                autoCompletion = true,
                hover = {
                    documentation = true,
                    references = true
                }
            }
        },
        filetypes = {
            "html", "handlebars", "hbs", "eruby", "erb", "ejs"
        }
    })

    -- CSS LSP with enhanced configuration
    lspconfig.cssls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            css = {
                validate = true,
                lint = {
                    unknownAtRules = "ignore"
                }
            },
            scss = {
                validate = true,
                lint = {
                    unknownAtRules = "ignore"
                }
            },
            less = {
                validate = true,
                lint = {
                    unknownAtRules = "ignore"
                }
            }
        },
        filetypes = {
            "css", "scss", "less"
        }
    })

    -- JSON LSP with enhanced configuration
    lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            json = {
                validate = { enable = true },
                schemas = {
                    {
                        fileMatch = { "package.json" },
                        url = "https://json.schemastore.org/package.json"
                    },
                    {
                        fileMatch = { "tsconfig*.json" },
                        url = "https://json.schemastore.org/tsconfig.json"
                    },
                    {
                        fileMatch = { ".eslintrc.json", ".eslintrc" },
                        url = "https://json.schemastore.org/eslintrc.json"
                    },
                    {
                        fileMatch = { ".prettierrc", ".prettierrc.json" },
                        url = "https://json.schemastore.org/prettierrc.json"
                    }
                }
            }
        }
    })

    -- Tailwind CSS with enhanced configuration
    lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
            "html", "css", "scss", "sass", "less", "javascript", "javascriptreact", 
            "typescript", "typescriptreact", "vue", "svelte", "astro", "mdx"
        },
        init_options = {
            userLanguages = {
                eelixir = "html-eex",
                eruby = "erb"
            }
        },
        root_dir = lspconfig.util.root_pattern(
                "tailwind.config.js",
                "tailwind.config.cjs",
                "tailwind.config.mjs",
                "tailwind.config.ts",
                "postcss.config.js",
                "postcss.config.cjs",
                "postcss.config.mjs",
                "package.json",
                "node_modules"
        ),
        settings = {
            tailwindCSS = {
                classAttributes = { "class", "className", "classList", "ngClass" },
                lint = {
                    cssConflict = "warning",
                    invalidApply = "error",
                    invalidScreen = "error",
                    invalidVariant = "error",
                    invalidConfigPath = "error",
                    invalidTailwindDirective = "error",
                    recommendedVariantOrder = "warning"
                },
                validate = true,
                experimental = {
                    classRegex = {
                        "tw`([^`]*)",
                        'tw\\["([^"]*)',
                        "tw\\.\\w+`([^`]*)",
                        "tw\\(.*?\\)`([^`]*)",
                        "\\bcx\\s*\\(?`([^`]*)",
                        "\\bcx\\s*\\(\\w+\\s*,\\s*`([^`]*)",
                        "\\bclass\\s*:\\s*`([^`]*)",
                        "\\bclass\\s*:\\s*\\w+\\s*,\\s*`([^`]*)"
                    }
                }
            }
        }
    })

    -- Emmet Language Server
    lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
            "html", "css", "scss", "sass", "less", "javascript", "javascriptreact",
            "typescript", "typescriptreact", "vue", "svelte", "astro"
        }
    })

    -- ESLint Language Server
    lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            -- ESLint-specific keymaps
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ef", "<cmd>lua vim.lsp.buf.code_action({ apply = true })<CR>", 
                { noremap = true, silent = true, desc = "ESLint Fix" })
        end,
        settings = {
            eslint = {
                packageManager = "npm",
                useESLintClass = true,
                experimental = {
                    useFlatConfig = false
                },
                codeAction = {
                    disableRuleComment = {
                        enable = true,
                        location = "separateLine"
                    },
                    showDocumentation = {
                        enable = true
                    }
                },
                codeActionOnSave = {
                    enable = true,
                    mode = "all"
                },
                format = true,
                quiet = false,
                onIgnoredFiles = "off",
                options = {
                    configFile = ""
                },
                run = "onType",
                problems = {
                    shortenToSingleLine = false
                }
            }
        }
    })
end

return M