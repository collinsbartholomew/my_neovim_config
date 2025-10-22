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

        -- Check if Dart SDK exists
        local dart_path = vim.fn.exepath("dart")
        if dart_path == "" then
            vim.notify("Dart SDK not found. Please install Flutter/Dart SDK.", vim.log.levels.ERROR)
            return
        end

        -- Fallback to dartls via nvim-lspconfig
        local lspconfig_status, lspconfig = pcall(require, "lspconfig")
        if lspconfig_status then
            lspconfig.dartls.setup({
                on_attach = function(client, bufnr)
                    -- Safe LSP keymaps
                    local function buf_set_keymap(...)
                        vim.api.nvim_buf_set_keymap(bufnr, ...)
                    end
                    local opts = { noremap = true, silent = true }

                    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
                    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

                    -- Enable inlay hints if available
                    pcall(function()
                        if client.supports_method("textDocument/inlayHint") then
                            vim.lsp.inlay_hint(bufnr, true)
                        end
                    end)
                end,
            })
        end
        return
    end

    -- Configure flutter-tools
    flutter_tools.setup({
        ui = {
            -- the border type to use for all floating windows, the same options/formats
            -- used for ":h nvim_open_win" e.g. "single" | "shadow" | { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
            border = "rounded",
            -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
            -- please note that this option is especially useful becase vim.notify breaks when running in snippets
            notification_style = 'native', -- 'native' | 'plugin'
        },
        debugger = {
            enabled = true,
            run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
            exception_breakpoints = {},
            register_configurations = function(paths)
                require("dap").configurations.dart = {
                    {
                        type = "dart",
                        request = "launch",
                        name = "Launch flutter",
                        program = "${workspaceFolder}/lib/main.dart",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "dart",
                        request = "attach",
                        name = "Attach to Flutter",
                        cwd = "${workspaceFolder}",
                    }
                }
            end,
        },
        dev_tools = {
            autostart = false, -- autostart devtools server if not detected
            auto_open_browser = false, -- Automatically opens devtools in the browser
        },
        outline = {
            open_cmd = "30vnew", -- command to use to open the outline buffer
            auto_open = false -- if true this will open the outline automatically when it is first populated
        },
        lsp = {
            color = { -- show the derived colours for dart variables
                enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
                background = false, -- highlight the background
                foreground = false, -- highlight the foreground
                virtual_text = true, -- show the highlight using virtual text
                virtual_text_str = "■", -- the virtual text character to highlight
            },
            on_attach = function(client, bufnr)
                -- Safe LSP keymaps
                local function buf_set_keymap(...)
                    vim.api.nvim_buf_set_keymap(bufnr, ...)
                end
                local opts = { noremap = true, silent = true }

                buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
                buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
                buf_set_keymap('n', '<leader>rf', '<Cmd>lua require("flutter-tools").reload()<CR>', opts)
                buf_set_keymap('n', '<leader>rr', '<Cmd>lua require("flutter-tools").runnables()<CR>', opts)

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
                }
            }
        },
        widget_guides = {
            enabled = true,
        },
        closing_tags = {
            highlight = "Comment", -- use Comment highlight group
            prefix = "// ", -- tag prefix
            enabled = true -- set to false to disable
        },
        dev_log = {
            open_cmd = "tabedit", -- command to use to open the log buffer
        },
        fvm = config.use_fvm or false, -- takes priority over path
    })
end

return M