---
-- Go LSP configuration (gopls)
-- Mason package: gopls
local M = {}

function M.setup()
    local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_status_ok then
        vim.notify("lspconfig not available", vim.log.levels.WARN)
        return
    end

    local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if not cmp_nvim_lsp_status_ok then
        vim.notify("cmp_nvim_lsp not available", vim.log.levels.WARN)
        return
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Common on_attach function for gopls
    local function on_attach(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Buffer local mappings
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Standard LSP mappings
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
        
        -- Diagnostics
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
        
        -- Format on save
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
        
        -- Enable inlay hints
        if vim.lsp.inlay_hint then
            pcall(vim.lsp.inlay_hint, bufnr, true)
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
        require("profile.languages.go.mappings").lsp(bufnr)
    end

    -- Setup gopls with enhanced options
    lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {"gopls"},
        filetypes = {"go", "gomod", "gowork", "gotmpl"},
        root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    fieldalignment = true,
                    nilness = true,
                    shadow = true,
                    unusedwrite = true,
                    useany = true,
                    unusedvariable = true,
                },
                staticcheck = true,
                gofumpt = true,
                codelenses = {
                    gc_details = true,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                deepCompletion = true,
                fuzzyMatching = true,
            },
        },
    })
end

return M