local M = {}

function M.setup()
    -- Set up rust-analyzer with modern configuration
    require("lspconfig").rust_analyzer.setup({
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_self",
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
                check = {
                    command = "clippy",
                    extraArgs = { "--", "-W", "clippy::all" },
                },
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                },
            },
        },
        capabilities = (function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.experimental = {
                serverStatusNotification = true,
            }
            return capabilities
        end)(),
    })
end

return M
