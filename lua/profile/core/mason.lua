-- added-by-agent: zig-setup 20251020
-- Core Mason configuration

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "zls",      -- Zig language server
        "lua_ls",   -- Lua
        "tsserver", -- TypeScript/JavaScript
        "gopls",    -- Go
        "rust_analyzer", -- Rust
        "clangd",   -- C/C++
        "qmlls",    -- QML (if available in registry)
        "omnisharp", -- C# (if available in registry)
        "jdtls",    -- Java (if available in registry)
        "html",     -- HTML
        "cssls",    -- CSS
        "jsonls",   -- JSON
        "tailwindcss", -- Tailwind CSS
        "pyright",  -- Python
    },
    automatic_installation = true,
})

require("mason-nvim-dap").setup({
    ensure_installed = {
        "codelldb",  -- For Zig debugging
        "netcoredbg", -- For C# debugging (if available in registry)
        "dart-debug-adapter", -- For Flutter/Dart debugging (if available in registry)
        "js-debug-adapter", -- For JavaScript/TypeScript debugging (if available in registry)
        "debugpy",   -- Python debugger
    },
    automatic_installation = true,
})
