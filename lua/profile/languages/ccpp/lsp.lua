-- added-by-agent: ccpp-setup 20251020
-- mason: clangd
-- manual: sudo pacman -S --needed clang-tools-extra

local M = {}

function M.setup()
    local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_ok then
        vim.notify("lspconfig not available", vim.log.levels.WARN)
        return
    end

    local utils = require("profile.core.utils")

    -- Common on_attach function
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings
        local opts = { buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)

        -- Enable inlay hints if supported
        if vim.lsp.inlay_hint then
            pcall(vim.lsp.inlay_hint, bufnr, true)
        end

        -- Format on save if supported
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end
            })
        end

        -- Check for compile_commands.json
        vim.defer_fn(function()
            local root = vim.fn.finddir('.git/..', vim.fn.expand('%:p:h') .. ';')
            if root == '' then
                root = vim.fn.getcwd()
            end

            local compile_commands = vim.fn.findfile('compile_commands.json', root .. '/**1')
            if compile_commands == '' then
                vim.notify(
                        "No compile_commands.json found. Use :MakeCompileDB to create one.",
                        vim.log.levels.WARN
                )
            end
        end, 1000)
    end

    -- Try to get clangd path from Mason first
    local clangd_path = vim.fn.exepath('clangd') -- default to PATH
    local mason_registry = require("mason-registry")
    if mason_registry.is_installed("clangd") then
        local package = mason_registry.get_package("clangd")
        clangd_path = package:get_install_path() .. "/clangd"
    end

    -- Setup clangd with recommended flags
    lspconfig.clangd.setup({
        cmd = {
            clangd_path,
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=never",
            "--cross-file-rename"
        },
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        root_dir = lspconfig.util.root_pattern(
                'compile_commands.json',
                'compile_flags.txt',
                '.git'
        ),
    })
end

return M