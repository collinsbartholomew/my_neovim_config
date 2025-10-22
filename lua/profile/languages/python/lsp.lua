---
-- Python LSP configuration (pyright)
-- Mason package: pyright
local M = {}

function M.setup()
    -- Ensure mason and mason-lspconfig are loaded
    local mason_ok, mason = pcall(require, "mason")
    local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
    local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

    if not (mason_ok and mason_lsp_ok and lspconfig_ok and cmp_nvim_lsp_status_ok) then
        return
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Setup mason
    mason.setup()

    -- Ensure Python-related LSP servers are installed
    mason_lspconfig.setup({
        ensure_installed = { "pyright" }
    })

    -- Configure pyright
    mason_lspconfig.setup_handlers({
        function(server_name)
            if server_name == "pyright" then
                lspconfig.pyright.setup({
                    capabilities = capabilities,
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "workspace",
                                useLibraryCodeForTypes = true,
                                typeCheckingMode = "basic",
                                autoImportCompletions = true,
                                -- Enable additional features
                                completeFunctionParens = true,
                                -- Auto-import settings
                                autoImportCompletions = true,
                                -- Diagnostics settings
                                diagnosticSeverityOverrides = {
                                    reportMissingTypeStubs = "information",
                                    reportUnknownParameterType = "none",
                                },
                            }
                        }
                    },
                    on_attach = function(client, bufnr)
                        -- Buffer local mappings
                        local function buf_set_keymap(...)
                            vim.api.nvim_buf_set_keymap(bufnr, ...)
                        end
                        local opts = { noremap = true, silent = true }

                        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
                        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
                        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
                        buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                        buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
                        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
                        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
                        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
                        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
                        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)
                        buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
                        buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
                        buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
                        buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

                        -- Format on save
                        if client.server_capabilities.documentFormattingProvider then
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.format({ bufnr = bufnr })
                                end,
                            })
                        end

                        -- Enable code lens if supported
                        if client.server_capabilities.codeLensProvider then
                            vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.codelens.refresh()
                                end,
                            })
                        end

                        -- Register language specific keymaps
                        require("profile.languages.python.mappings").lsp(bufnr)
                    end
                })
            end
        end
    })
end

return M