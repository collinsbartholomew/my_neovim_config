-- added-by-agent: ccpp-setup 20251020
-- mason: clangd
-- manual: sudo pacman -S --needed clang-tools-extra

local M = {}

function M.setup()
    -- Ensure clangd is installed
    local mlsp_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if mlsp_status_ok then
        mason_lspconfig.ensure_installed({ "clangd" })
    end

    -- Configure clangd through lsp-zero
    local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
    if not lsp_zero_status_ok then
        return
    end

    -- Load which-key
    local which_key_status_ok, which_key = pcall(require, "which-key")
    if not which_key_status_ok then
        return
    end

    -- Configure clangd with lsp-zero
    lsp_zero.configure("clangd", {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=never",
            "--cross-file-rename"
        },
        root_dir = require("lspconfig").util.root_pattern(
                'compile_commands.json',
                'compile_flags.txt',
                '.git'
        ),
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
                ["<C-k>"] = { vim.lsp.buf.signature_help, "Show signature help" },
                ["<space>"] = {
                    name = "LSP",
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                },
            }, wk_opts)
            
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
    })
end

return M