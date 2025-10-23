---
-- C# language support (omnisharp)
-- Mason package: omnisharp
local M = {}

function M.setup(config)
    config = config or {}

    -- Ensure omnisharp is installed
    local mlsp_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if mlsp_status_ok then
        mason_lspconfig.ensure_installed({ "omnisharp" })
    end

    -- Configure omnisharp through lsp-zero
    local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
    if not lsp_zero_status_ok then
        return
    end

    -- Load which-key
    local which_key_status_ok, which_key = pcall(require, "which-key")
    if not which_key_status_ok then
        return
    end

    -- Set default cmd
    local cmd = { "omnisharp" }

    -- Override cmd if provided in config
    if config.cmd then
        cmd = config.cmd
    end

    lsp_zero.configure("omnisharp", {
        cmd = cmd,
        filetypes = { "cs", "vb" },
        root_dir = require("lspconfig").util.root_pattern(".sln", ".csproj", "global.json", ".git"),
        on_attach = function(client, bufnr)
            -- Use lsp-zero's recommended preset for keybindings
            lsp_zero.buffer_autoapi()
            
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Buffer local mappings with which-key
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local wk_opts = { buffer = bufnr }

            -- Define LSP key mappings with which-key (maintaining existing functionality)
            which_key.register({
                g = {
                    d = { vim.lsp.buf.definition, "Go to definition" },
                    i = { vim.lsp.buf.implementation, "Go to implementation" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<leader>"] = {
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    D = { vim.lsp.buf.type_definition, "Go to type definition" },
                    l = {
                        name = "LSP",
                        d = { vim.diagnostic.open_float, "Show diagnostics" },
                        f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                        s = { vim.lsp.buf.document_symbol, "Document symbol" },
                        w = { vim.lsp.buf.workspace_symbol, "Workspace symbol" },
                    },
                    q = { vim.diagnostic.setloclist, "Diagnostics to location list" },
                },
            }, wk_opts)
            
            -- Diagnostics navigation
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            
            -- Enable inlay hints if available
            pcall(function()
                if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint(bufnr, true)
                end
            end)

            -- Format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })
            end

            -- Register language specific keymaps
            require("profile.languages.csharp.mappings").lsp(bufnr)
        end,
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
                AnalyzersSupport = true,
                EnableImportCompletion = true,
                EnableAsyncCompletion = true,
                DocumentAnalysisTimeoutMs = 30000,
            },
            OmniSharp = {
                UseModernNet = true,
                EnableDecompilationSupport = true,
                EnableLspEditorSupport = true,
                EnableCSharp7Support = true,
                EnableCSharp8Support = true,
                EnableCSharp9Support = true,
                EnableCSharp10Support = true,
                EnableCSharp11Support = true,
            }
        },
    })
end

return M