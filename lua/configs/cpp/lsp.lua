local M = {}

function M.setup()
    -- Configure clangd extensions
    local clangd_capabilities = require("cmp_nvim_lsp").default_capabilities()
    clangd_capabilities.offsetEncoding = { "utf-16" }

    require("clangd_extensions").setup({
        server = {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=never",
                "--completion-style=detailed",
                "--cross-file-rename",
                "--enable-config",
                "--pch-storage=memory",
                "--header-insertion-decorators",
                "--all-scopes-completion",
                "--offset-encoding=utf-16",
            },
            capabilities = clangd_capabilities,
            on_attach = function(_, bufnr)
                -- Enable inlay hints
                require("clangd_extensions.inlay_hints").setup_autocmd()
                require("clangd_extensions.inlay_hints").set_inlay_hints()

                -- Buffer-local keymaps
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
                vim.keymap.set("n", "<leader>cs", "<cmd>ClangdSymbolInfo<cr>", opts)
                vim.keymap.set("n", "<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", opts)
                vim.keymap.set("n", "<leader>cm", "<cmd>ClangdMemoryUsage<cr>", opts)
                vim.keymap.set("n", "gh", "<cmd>ClangdSwitchSourceHeader<cr>", opts)

                -- LSP keymaps
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
        },
    })
end

return M