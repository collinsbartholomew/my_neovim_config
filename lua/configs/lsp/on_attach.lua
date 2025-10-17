--Unified on_attach for LSP clients (shared keymaps and integrations)
local M = {}

local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, silent = true }

    -- Client optimization examples
    if client.name == 'biome' then
        client.server_capabilities.completionProvider = false
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.diagnosticProvider = true
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
    elseif client.name == 'vtsls' then
client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    elseif client.name == 'html' and (vim.bo[bufnr].filetype:match('react') or vim.bo[bufnr].filetype:match('typescript')) then
        client.server_capabilities.completionProvider = false
    elseif client.name == 'emmet_ls' and (vim.bo[bufnr].filetype:match('typescript') or vim.bo[bufnr].filetype:match('javascript')) then
        client.server_capabilities.completionProvider = false
    elseif client.name == 'cssls'then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Core LSP mappings
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition,opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)

    -- Organize imports
    vim.keymap.set('n', '<leader>lo', function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply =true })
    end, vim.tbl_extend('force', opts, { desc = 'LSP Organize Imports' }))

    vim.keymap.set('n', '<leader>lf', function()
        if client.name == 'biome' then
            vim.lsp.buf.format({ async = true, name = 'biome' })
        else
            vim.lsp.buf.format({ async = true })
        end
    end, opts)

    -- Organize imports and ESLint fix on save for JS/TS projects
    if vim.bo[bufnr].filetype == 'javascript' or vim.bo[bufnr].filetype == 'javascriptreact' or vim.bo[bufnr].filetype == 'typescript' or vim.bo[bufnr].filetype == 'typescriptreact' then
        local group = vim.api.nvim_create_augroup('lsp_js_format_' .. bufnr, { clear = true })

        -- Helper torun organizeImports via codeAction synchronously
        local function organize_imports()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { 'source.organizeImports' } }
            local results = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params,1500)
            if not results then return end
            for _, res in pairs(results or {}) do
                for _, r in pairs(res or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
                    elseif r.command then
                       local cmd = type(r.command) == 'table' and r.command or r
                        pcall(vim.lsp.buf.execute_command, cmd)
                    end
                end
            end
        end

        -- Helper to run eslint --fix via either command or codeAction
        local function eslint_fix()
            --Prefer plugin command if available
            if vim.fn.exists(':EslintFixAll') == 2 then
                pcall(vim.cmd, 'EslintFixAll')
                return
            end
            -- Otherwise request code actions 'source.fixAll.eslint'
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { 'source.fixAll.eslint' } }
            local results = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 1500)
            if not results then return end
            for _, res in pairs(results or {}) dofor _, r in pairs(res or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
                    elseif r.command then
                        local cmd = type(r.command) == 'table' and r.command or r
                        pcall(vim.lsp.buf.execute_command, cmd)
                    end
                end
            end
        end

        -- Formaton save toggle (global)
        if _G.format_on_save == nil then _G.format_on_save = true end

        -- Buffer-local autocmd to run organize imports, eslint fix, then format
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            group= group,
            callback = function()
                -- Organize imports first
                pcall(organize_imports)
                -- Run eslint fix (if available)
                pcall(eslint_fix)
                -- Run formatting if enabled
                if _G.format_on_save then
                    local ok, conform = pcall(require, 'conform')
                    if ok then
                        pcall(conform.format, { async = false, lsp_fallback = true })
                    else
                        pcall(vim.lsp.buf.format, { bufnr = bufnr })
                    end
                end
            end,
        })
    end

    -- Advancedworkspace features
    vim.keymap.set('n', '<leader>lws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    -- LSP Control
    vim.keymap.set('n', '<leader>lI', '<cmd>LspInfo<cr>', { desc = 'LSP info' })
    vim.keymap.set('n', '<leader>lL', '<cmd>LspLog<cr>', { desc = 'LSP log' })
    vim.keymap.set('n', '<leader>lT', '<cmd>LspStart<cr>', { desc = 'LSP start' })
    vim.keymap.set('n', '<leader>lX', '<cmd>LspStop<cr>', { desc = 'LSP stop' })
    vim.keymap.set('n', '<leader>lR', '<cmd>LspRestart<cr>', { desc = 'LSP restart' })

    -- Inlay hints
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        --Enable inlay hints by default
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        vim.keymap.set('n', '<leader>lih', function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
            vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"))
        end, opts)
    end

    -- CodeLens
    if client.server_capabilities.codeLensProvider and vim.lsp.codelens then
        vim.lsp.codelens.refresh({ bufnr = bufnr })
        vim.keymap.set('n', '<leader>lcl', vim.lsp.codelens.run, opts)
        vim.keymap.set('n', '<leader>lcr', function()
            vim.lsp.codelens.refresh({ bufnr = bufnr})
        end, opts)

        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
        })
    end

   -- Document highlights
    if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references,
        })
    end

    -- Callhierarchy
    if client.server_capabilities.callHierarchyProvider then
        vim.keymap.set('n', '<leader>lci', vim.lsp.buf.incoming_calls, opts)
        vim.keymap.set('n', '<leader>lco', vim.lsp.buf.outgoing_calls, opts)
    end

    --Memory Safety Diagnostics placeholder
    vim.keymap.set('n', '<leader>lm', function()
        vim.notify("Running memory safety diagnostics...", vim.log.levels.INFO)
    end, { desc = "Memory safety diagnostics" })
end

M.on_attach = on_attach
return M

