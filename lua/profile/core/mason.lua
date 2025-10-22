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
        "zls", -- Zig language server
        "lua_ls", -- Lua
        "ts_ls", -- TypeScript/JavaScript
        "gopls", -- Go
        "rust_analyzer", -- Rust
        "clangd", -- C/C++
        "qmlls", -- QML (if available in registry)
        "omnisharp", -- C# (if available in registry)
        "jdtls", -- Java (if available in registry)
        "html", -- HTML
        "cssls", -- CSS
        "jsonls", -- JSON
        "tailwindcss", -- Tailwind CSS
        "emmet_ls", -- Emmet
        "eslint", -- ESLint
        "pyright", -- Python
    },
    automatic_installation = true,
})

require("mason-nvim-dap").setup({
    ensure_installed = {
        "codelldb", -- For Zig debugging
        "netcoredbg", -- For C# debugging (if available in registry)
        "dart-debug-adapter", -- For Flutter/Dart debugging (if available in registry)
        "js-debug-adapter", -- For JavaScript/TypeScript debugging (if available in registry)
        "debugpy", -- Python debugger
        "local-lua-debugger-vscode", -- Lua debugger
    },
    automatic_installation = true,
})

require("mason-tool-installer").setup({
    ensure_installed = {
        "stylua", -- Lua formatter
        "luacheck", -- Lua linter
        "prettier", -- JavaScript/TypeScript/HTML/CSS formatter
        "eslint", -- JavaScript/TypeScript linter
        "stylelint", -- CSS linter
    },
    automatic_installation = true,
})
