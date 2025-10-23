-- added-by-agent: flutter-setup 20251020-160000
-- mason: dart-debug-adapter
-- manual: flutter/dart/fvm install commands listed in README

local M = {}

function M.setup(config)
    config = config or {}

    -- Try to load flutter-tools
    local flutter_tools_status, flutter_tools = pcall(require, "flutter-tools")
    if not flutter_tools_status then
        vim.notify("flutter-tools.nvim not found. Falling back to dartls.", vim.log.levels.WARN)

        -- Ensure dartls is installed
        local mlsp_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
        if mlsp_status_ok then
            mason_lspconfig.ensure_installed({ "dartls" })
        end

        -- Configure dartls through lsp-zero
        local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
        if not lsp_zero_status_ok then
            return
        end

        -- Load which-key
        local which_key_status_ok, which_key = pcall(require, "which-key")
        if not which_key_status_ok then
            return
        end

        -- Configure dartls with lsp-zero
        lsp_zero.configure("dartls", {
            on_attach = function(client, bufnr)
                -- Use lsp-zero's recommended preset for keybindings
                lsp_zero.buffer_autoapi()
                
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
                        f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                        D = { vim.lsp.buf.type_definition, "Go to type definition" },
                        l = {
                            name = "LSP",
                            d = { vim.lsp.buf.definition, "Go to definition" },
                            h = { vim.lsp.buf.hover, "Show hover information" },
                            i = { vim.lsp.buf.implementation, "Go to implementation" },
                            s = { vim.lsp.buf.signature_help, "Show signature help" },
                            r = { vim.lsp.buf.rename, "Rename symbol" },
                            a = { vim.lsp.buf.code_action, "Code actions" },
                        },
                        w = { 
                            name = "Workspace",
                            t = { "<Cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols" },
                        },
                        t = { "<Cmd>lua require(\"flutter-tools\").reload()<CR>", "Reload Flutter tools" },
                        O = { "<Cmd>lua require(\"flutter-tools\").outline()<CR>", "Show Flutter outline" },
                    },
                    fr = { "<Cmd>lua require(\"flutter-tools\").run()<CR>", "Run Flutter app" },
                    fd = { "<Cmd>FlutterDevices<CR>", "Show Flutter devices" },
                    fe = { "<Cmd>FlutterEmulators<CR>", "Show Flutter emulators" },
                }, wk_opts)
                
                -- Enable inlay hints if available
                pcall(function()
                    if client.supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint(bufnr, true)
                    end
                end)
            end,
            init_options = {
                closingLabels = true,
                flutterOutline = true,
                onlyAnalyzeProjectsWithOpenFiles = false,
                suggestFromUnimportedLibraries = true,
                updateImportsOnRename = true,
            },
            settings = {
                dart = {
                    completeFunctionCalls = true,
                    showTodos = true,
                    lineLength = 80,
                }
            }
        })
        return
    end

    -- Configure flutter-tools with lsp-zero integration
    flutter_tools.setup({
        ui = {
            border = "rounded",
            notification_style = 'native',
        },
        debugger = {
            enabled = true,
            run_via_dap = true,
            exception_breakpoints = {},
        },
        dev_tools = {
            autostart = false,
            auto_open_browser = false,
        },
        outline = {
            open_cmd = "30vnew",
            auto_open = false
        },
        lsp = {
            color = {
                enabled = true,
                background = false,
                foreground = false,
                virtual_text = true,
                virtual_text_str = "■",
            },
            on_attach = function(client, bufnr)
                -- Use lsp-zero's recommended preset for keybindings
                local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
                if lsp_zero_status_ok then
                    lsp_zero.buffer_autoapi()
                end
                
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
                        f = { function() vim.lsp.buf.format { async = true } end, "Format buffer" },
                        D = { vim.lsp.buf.type_definition, "Go to type definition" },
                        l = {
                            name = "LSP",
                            d = { vim.lsp.buf.definition, "Go to definition" },
                            h = { vim.lsp.buf.hover, "Show hover information" },
                            i = { vim.lsp.buf.implementation, "Go to implementation" },
                            s = { vim.lsp.buf.signature_help, "Show signature help" },
                            r = { vim.lsp.buf.rename, "Rename symbol" },
                            a = { vim.lsp.buf.code_action, "Code actions" },
                        },
                        w = { 
                            name = "Workspace",
                            t = { "<Cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols" },
                        },
                        t = { "<Cmd>lua require(\"flutter-tools\").reload()<CR>", "Reload Flutter tools" },
                        O = { "<Cmd>lua require(\"flutter-tools\").outline()<CR>", "Show Flutter outline" },
                    },
                    fr = { "<Cmd>lua require(\"flutter-tools\").run()<CR>", "Run Flutter app" },
                    fd = { "<Cmd>FlutterDevices<CR>", "Show Flutter devices" },
                    fe = { "<Cmd>FlutterEmulators<CR>", "Show Flutter emulators" },
                }, wk_opts)
                
                -- Enable inlay hints if available
                pcall(function()
                    if client.supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint(bufnr, true)
                    end
                end)
            end,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            settings = {
                showTodos = true,
                completeFunctionCalls = true,
                analysisExcludedFolders = {
                    vim.fn.expand("$HOME/.pub-cache"),
                    vim.fn.expand("$HOME/AppData/Local/Pub/Cache"), -- windows
                    vim.fn.expand("$HOME/Library/Application Support/Pub/Cache"), -- macos
                },
                dart = {
                    lineLength = 80,
                    enableSdkFormatter = true,
                    completeFunctionCalls = true,
                    showTodos = true,
                }
            }
        },
        widget_guides = {
            enabled = true,
        },
        closing_tags = {
            highlight = "Comment",
            prefix = "// ",
            enabled = true
        },
        dev_log = {
            open_cmd = "tabedit",
        },
        fvm = config.use_fvm or false,
    })
end

return M