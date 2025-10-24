-- Mojo LSP configuration
local M = {}

function M.setup()
    -- Check if mojo-lsp-server is executable
    if vim.fn.executable("mojo-lsp-server") == 0 then
        vim.notify("Mojo LSP server not found. Please install mojo-lsp-server.", vim.log.levels.WARN)
        return
    end

    -- Load lsp-zero for capabilities and utilities
    local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
    if not lsp_zero_status_ok then
        vim.notify("lsp-zero not available", vim.log.levels.WARN)
        return
    end

    -- Load which-key
    local which_key_status_ok, which_key = pcall(require, "which-key")
    if not which_key_status_ok then
        vim.notify("which-key not available", vim.log.levels.WARN)
        return
    end

    -- Configure mojo LSP as a custom server with lsp-zero
    lsp_zero.configure("mojo", {
        cmd = { "mojo-lsp-server" },
        filetypes = { "mojo", "🔥" },
        root_dir = vim.fs.dirname(vim.fs.find({ ".git", "main.mojo", "main.🔥" }, { upward = true })[1]),
        settings = {
            mojo = {}, -- Add specific Mojo LSP settings here if needed
        },
        on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

            -- Attach nvim-navic for breadcrumbs and winbar
            local navic_status_ok, navic = pcall(require, "nvim-navic")
            if navic_status_ok then
                navic.attach(client, bufnr)
            else
                vim.notify("nvim-navic is not available", vim.log.levels.WARN)
            end

            -- Buffer local mappings with which-key
            local wk_opts = { buffer = bufnr }
            which_key.register({
                ["<leader>l"] = {
                    name = "LSP",
                    D = { vim.lsp.buf.declaration, "Go to declaration" },
                    d = { vim.lsp.buf.definition, "Go to definition" },
                    h = { vim.lsp.buf.hover, "Show hover information" },
                    i = { vim.lsp.buf.implementation, "Go to implementation" },
                    s = { vim.lsp.buf.signature_help, "Show signature help" },
                    t = { vim.lsp.buf.type_definition, "Go to type definition" },
                    r = { vim.lsp.buf.rename, "Rename symbol" },
                    a = { vim.lsp.buf.code_action, "Code actions" },
                    R = { vim.lsp.buf.references, "Find references" },
                    f = {
                        function()
                            vim.lsp.buf.format({ async = true })
                        end,
                        "Format buffer",
                    },
                    e = { vim.diagnostic.open_float, "Show diagnostics" },
                    n = { vim.diagnostic.goto_next, "Next diagnostic" },
                    p = { vim.diagnostic.goto_prev, "Previous diagnostic" },
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

            -- Format on save if supported
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            bufnr = bufnr,
                            filter = function(fclient)
                                return fclient.name == client.name
                            end,
                        })
                    end,
                })
            end

            -- Enable code lens if supported
            if client.supports_method("textDocument/codeLens") then
                vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.codelens.refresh()
                    end,
                })
            end

            -- Register language-specific keymaps (if any)
            local mojo_mappings_status_ok, mojo_mappings = pcall(require, "profile.languages.mojo.mappings")
            if mojo_mappings_status_ok then
                mojo_mappings.lsp(bufnr)
            end
        end,
        capabilities = lsp_zero.client_capabilities(),
    })
end

return M