-- added-by-agent: zig-setup 20251020
local M = {}

function M.setup()
    local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_ok then
        vim.notify("lspconfig not available", vim.log.levels.WARN)
        return
    end

    local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if not cmp_nvim_lsp_status_ok then
        vim.notify("cmp_nvim_lsp not available", vim.log.levels.WARN)
        return
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Common on_attach function
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
    end

    -- Try to get zls path from Mason first
    local zls_path = vim.fn.exepath('zls') -- default to PATH
    local mason_registry = require("mason-registry")
    if mason_registry.is_installed("zls") then
        local package = mason_registry.get_package("zls")
        zls_path = package:get_install_path() .. "/zls"
    end

    -- Setup zls with enhanced options
    lspconfig.zls.setup({
        cmd = { zls_path },
        root_dir = lspconfig.util.root_pattern('build.zig', 'zls.json', '.git'),
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            zls = {
                enable_build_on_save = true,
                semantic_tokens = "full",
                zig_lib_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/zls/bin/"),
                zig_exe_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/zls/bin/zig"),
            }
        },
    })
end

return M