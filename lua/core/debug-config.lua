return {
    -- LSP Debugging setup for Rust
    rust_analyzer = {
        cmd = { "rust-analyzer" },
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                -- Enable clippy on save
                checkOnSave = {
                    command = "clippy",
                    allFeatures = true,
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
                -- Debugging configurations
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                },
            },
        },
    },
}

