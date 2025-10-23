-- LSP and Mason setup using lsp-zero
-- This file configures Language Server Protocol (LSP) clients with lsp-zero and Mason

-- Load lsp-zero
local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
if not lsp_zero_status_ok then
    vim.notify("lsp-zero is not available", vim.log.levels.WARN)
    return
end

-- Load which-key
local which_key_status_ok, which_key = pcall(require, "which-key")
if not which_key_status_ok then
    vim.notify("which-key is not available", vim.log.levels.WARN)
    return
end

-- Initialize lsp-zero
lsp_zero.preset("recommended") -- Use recommended preset for default settings

-- Load Mason (package manager for LSP servers, DAP adapters, and linters)
local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
    vim.notify("Mason is not available", vim.log.levels.WARN)
    return
end

-- Load Mason-lspconfig (integration between Mason and lspconfig)
local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
    vim.notify("Mason-lspconfig is not available", vim.log.levels.WARN)
    return
end

-- Initialize Mason
mason.setup({
    ui = {
        icons = {
            package_installed = "✓", -- Icon for installed packages
            package_pending = "➜", -- Icon for pending packages
            package_uninstalled = "✗", -- Icon for uninstalled packages
        },
    },
})

-- Configure lsp-zero on_attach with which-key integration
lsp_zero.on_attach(function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Attach nvim-navic for breadcrumbs and winbar
    local navic_status_ok, navic = pcall(require, "nvim-navic")
    if navic_status_ok then
        navic.attach(client, bufnr)
    else
        vim.notify("nvim-navic is not available", vim.log.levels.WARN)
    end

    -- Buffer local mappings with which-key
    local opts = { buffer = bufnr, noremap = true, silent = true }
    local wk_opts = { buffer = bufnr }

    -- Define LSP key mappings with which-key
    which_key.register({
        ["<leader>l"] = {
            name = "LSP",
            D = { vim.lsp.buf.declaration, "Go to declaration" },
            d = { vim.lsp.buf.definition, "Go to definition" },
            h = { vim.lsp.buf.hover, "Show hover information" },
            i = { vim.lsp.buf.implementation, "Go to implementation" },
            s = { vim.lsp.buf.signature_help, "Show signature help" },
            t = { vim.lsp.buf.type_definition, "Go to type definition" },
            r = { vim.lsp.buf.rename, "Rename symbol" },
            a = { vim.lsp.buf.code_action, "Code actions" },
            R = { vim.lsp.buf.references, "Find references" },
            f = {
                function()
                    vim.lsp.buf.format({ async = true })
                end,
                "Format buffer",
            },
            e = { vim.diagnostic.open_float, "Show diagnostics" },
            n = { vim.diagnostic.goto_next, "Next diagnostic" },
            p = { vim.diagnostic.goto_prev, "Previous diagnostic" },
            q = { vim.diagnostic.setloclist, "Diagnostics to location list" },
            w = {
                name = "Workspace",
                a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
                r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
                l = {
                    function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end,
                    "List workspace folders",
                },
            },
        },
    }, wk_opts)

    -- Fallback key mappings for compatibility
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
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "<space>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

    -- Format on save if server supports it
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
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
    if client.supports_method("textDocument/codeLens") then
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh()
            end,
        })
    end
end)

-- Define LSP servers to be installed and configured
local servers = {
    -- Lua language server configuration
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
                        [vim.fn.stdpath("config") .. "/lua"] = true,
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
    -- Rust analyzer configuration
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
    -- Go language server configuration
    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
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
    -- C/C++ language server configuration
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
    },
    -- QML language server configuration
    qmlls = {
        cmd = { "qmlls" },
        filetypes = { "qml", "qmlproject" },
    },
    -- Zig language server configuration
    zls = {},
    -- TypeScript/JavaScript language server configuration
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
    -- Python language server configuration
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
    -- Java language server configuration
    jdtls = {},
    -- C# language server configuration
    omnisharp = {
        cmd = { "omnisharp" },
        filetypes = { "cs", "vb" },
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
                EnableImportCompletion = true,
                EnableAsyncCompletion = true,
                DocumentAnalysisTimeoutMs = 30000,
            },
            OmniSharp = {
                UseModernNet = true,
                EnableDecompilationSupport = true,
                EnableLspDriver = true,
            },
        },
    },
    -- Mojo language server configuration
    mojo = {
        cmd = { "mojo-lsp-server" },
        filetypes = { "mojo", "🔥" },
        settings = {
            mojo = {},
        },
    },
    -- PHP language server configuration
    intelephense = {
        settings = {
            intelephense = {
                filetypes = { "php", "blade" },
                environment = {
                    phpVersion = "8.3",
                },
                completion = {
                    insertUseDeclaration = true,
                    fullyQualifyGlobalConstantsAndFunctions = false,
                    quoteStyle = "double",
                },
                format = {
                    enable = true,
                },
            },
        },
    },
}

-- Setup Mason-lspconfig with lsp-zero
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
        -- asm_lsp is configured in the asm module
        "omnisharp",
        "intelephense",
    },
    handlers = {
        -- Default handler for servers without custom settings
        lsp_zero.default_setup,
        -- Custom handlers for specific servers
        lua_ls = function()
            lsp_zero.configure("lua_ls", servers.lua_ls)
        end,
        rust_analyzer = function()
            lsp_zero.configure("rust_analyzer", servers.rust_analyzer)
        end,
        gopls = function()
            lsp_zero.configure("gopls", servers.gopls)
        end,
        clangd = function()
            lsp_zero.configure("clangd", servers.clangd)
        end,
        qmlls = function()
            lsp_zero.configure("qmlls", servers.qmlls)
        end,
        zls = function()
            lsp_zero.configure("zls", servers.zls)
        end,
        ts_ls = function()
            lsp_zero.configure("ts_ls", servers.ts_ls)
        end,
        pyright = function()
            lsp_zero.configure("pyright", servers.pyright)
        end,
        jdtls = function()
            lsp_zero.configure("jdtls", servers.jdtls)
        end,
        -- asm_lsp is configured in the asm module
        omnisharp = function()
            lsp_zero.configure("omnisharp", servers.omnisharp)
        end,
        mojo = function()
            lsp_zero.configure("mojo", servers.mojo)
        end,
        intelephense = function()
            lsp_zero.configure("intelephense", servers.intelephense)
        end,
    },
})

-- Setup lsp-zero
lsp_zero.setup()

-- Return empty table to satisfy module requirements
return {}