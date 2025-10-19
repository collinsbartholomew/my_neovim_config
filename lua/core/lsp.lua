local M = {}

function M.setup()
    local lsp_zero = require('lsp-zero')
    local lspconfig = require('lspconfig')

    -- Configure diagnostics
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = true,  -- Enable live diagnostics
        underline = true,
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

    -- Setup handlers with proper borders
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "rounded",
        }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "rounded",
        }
    )

    -- Add completion capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
    if has_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    -- Configure servers with immediate startup
    local servers = {
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },
        tsserver = {
            init_options = {
                preferences = {
                    disableSuggestions = false,
                    includeCompletionsForModuleExports = true,
                },
            },
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
        },
    }

    -- Setup all servers with enhanced configuration
    for server, config in pairs(servers) do
        config.capabilities = vim.lsp.protocol.make_client_capabilities()
        config.flags = {
            debounce_text_changes = 150,
        }
        config.on_attach = function(client, bufnr)
            -- Setup autoformatting
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })
            end

            -- Setup keymaps
            require("core.keymaps").setup_lsp_keymaps(bufnr)

            -- Enable inlay hints if supported
            if client.supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(bufnr, true)
            end
        end

        lspconfig[server].setup(config)
    end

    -- Configure completion
    lsp_zero.preset({
        name = 'minimal',
        set_lsp_keymaps = true,
        manage_nvim_cmp = true,
        suggest_lsp_servers = false,
    })

    -- Configure autocompletion
    local cmp = require('cmp')
    local cmp_select = {behavior = cmp.SelectBehavior.Select}

    cmp.setup({
        sources = {
            {name = 'nvim_lsp', priority = 1000},
            {name = 'nvim_lua', priority = 800},
            {name = 'path', priority = 700},
            {name = 'luasnip', priority = 600, keyword_length = 2},
            {name = 'buffer', priority = 500, keyword_length = 3},
        },
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
        }),
        preselect = cmp.PreselectMode.None,
    })
end

return M
