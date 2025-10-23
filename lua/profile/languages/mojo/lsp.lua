---
-- Mojo LSP configuration
local M = {}

function M.setup()
    -- Configure mojo LSP through lsp-zero
    local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
    if not lsp_zero_status_ok then
        return
    end

    -- Load which-key
    local which_key_status_ok, which_key = pcall(require, "which-key")
    if not which_key_status_ok then
        return
    end

    -- Configure mojo LSP with lsp-zero
    lsp_zero.configure("mojo", {
        cmd = { "mojo-lsp-server" },
        filetypes = { "mojo", "🔥" },
        root_dir = require("lspconfig").util.root_pattern(".git", "main.mojo", "main.🔥"),
        settings = {
            mojo = {
                -- Add any specific Mojo LSP settings here
            }
        },
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
                    D = { vim.lsp.buf.declaration, "Go to declaration" },
                    d = { vim.lsp.buf.definition, "Go to definition" },
                    i = { vim.lsp.buf.implementation, "Go to implementation" },
                },
                K = { vim.lsp.buf.hover, "Show hover information" },
                ["<C-k>"] = { vim.lsp.buf.signature_help, "Show signature help" },
                ["<space>"] = {
                    name = "LSP",
                    D = { vim.lsp.buf.type_definition, "Go to type definition" },
                    rn = { vim.lsp.buf.rename, "Rename symbol" },
                    ca = { vim.lsp.buf.code_action, "Code actions" },
                    f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                    e = { vim.diagnostic.open_float, "Show diagnostics" },
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
            
            -- Diagnostics navigation
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            
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
            require("profile.languages.mojo.mappings").lsp(bufnr)
        end
    })
end

return M