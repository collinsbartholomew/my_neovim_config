-- added-by-agent: web-setup 20251020-173000
-- mason: ts_ls, tailwindcss-language-server, prettier, eslint
-- manual: node.js installation required

local M = {}

function M.setup()
    -- Ensure web-related LSPs are installed
    local mlsp_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if mlsp_status_ok then
        mason_lspconfig.ensure_installed({ 
            "ts_ls", 
            "html", 
            "cssls", 
            "jsonls", 
            "tailwindcss",
            "emmet_ls",
            "eslint"
        })
    end

    -- Configure web LSPs through lsp-zero
    local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
    if not lsp_zero_status_ok then
        return
    end

    -- Load which-key
    local which_key_status_ok, which_key = pcall(require, "which-key")
    if not which_key_status_ok then
        return
    end

    -- Configure TypeScript/JavaScript LSP with enhanced configuration
    lsp_zero.configure("ts_ls", {
        init_options = {
            plugins = {
                {
                    name = "@vue/typescript-plugin", -- Vue TypeScript
                    location = "local",
                    languages = { "vue" }, -- Apply toVue files
                },
            },
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
        },
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
            
            -- Buffer local mappings with which-key
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local wk_opts = { buffer = bufnr }

            -- Define LSP key mappings with which-key (maintaining existing functionality)
            which_key.register({
                g = {
                    d = { vim.lsp.buf.definition, "Go to definition" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<leader>"] = {
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                },
            }, wk_opts)
            
            -- Enable inlay hints if available
            pcall(function()
                if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint(bufnr, true)
                end
            end)
        end
    })

    -- HTML LSP with enhanced configuration
    lsp_zero.configure("html", {
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
        },
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
            
            -- Buffer local mappings with which-key
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local wk_opts = { buffer = bufnr }

            -- Define LSP key mappings with which-key (maintaining existing functionality)
            which_key.register({
                g = {
                    d = { vim.lsp.buf.definition, "Go to definition" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<leader>"] = {
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                },
            }, wk_opts)
        end
    })

    -- CSS LSP with enhanced configuration
    lsp_zero.configure("cssls", {
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
        },
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
            
            -- Buffer local mappings with which-key
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local wk_opts = { buffer = bufnr }

            -- Define LSP key mappings with which-key (maintaining existing functionality)
            which_key.register({
                g = {
                    d = { vim.lsp.buf.definition, "Go to definition" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<leader>"] = {
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                },
            }, wk_opts)
        end
    })

    -- JSON LSP with enhanced configuration
    lsp_zero.configure("jsonls", {
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
        },
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
            
            -- Buffer local mappings with which-key
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local wk_opts = { buffer = bufnr }

            -- Define LSP key mappings with which-key (maintaining existing functionality)
            which_key.register({
                g = {
                    d = { vim.lsp.buf.definition, "Go to definition" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<leader>"] = {
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                },
            }, wk_opts)
        end
    })

    -- Tailwind CSS with enhanced configuration
    lsp_zero.configure("tailwindcss", {
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
        root_dir = require("lspconfig").util.root_pattern(
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
                }
            }
        },
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
            
            -- Buffer local mappings with which-key
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local wk_opts = { buffer = bufnr }

            -- Define LSP key mappings with which-key (maintaining existing functionality)
            which_key.register({
                g = {
                    d = { vim.lsp.buf.definition, "Go to definition" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<leader>"] = {
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                },
            }, wk_opts)
        end
    })

    -- Emmet LSP
    lsp_zero.configure("emmet_ls", {
        filetypes = {
            "html", "css", "scss", "sass", "less", "javascript", "javascriptreact",
            "typescript", "typescriptreact", "vue", "svelte"
        },
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
        end
    })

    -- ESLint LSP
    lsp_zero.configure("eslint", {
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
            
            -- Buffer local mappings with which-key
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local wk_opts = { buffer = bufnr }

            -- Define LSP key mappings with which-key (maintaining existing functionality)
            which_key.register({
                g = {
                    d = { vim.lsp.buf.definition, "Go to definition" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<leader>"] = {
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                },
            }, wk_opts)
        end
    })
end

return M