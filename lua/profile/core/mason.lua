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
    },
    automatic_installation = true,
})

require("mason-nvim-dap").setup({
    ensure_installed = {
        "codelldb",  -- For Zig debugging
    },
    automatic_installation = true,
})
