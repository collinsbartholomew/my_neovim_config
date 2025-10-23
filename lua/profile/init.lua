--Main profile configuration loader
-- This file loads all the modular configurations in the profile directory

-- Load core configurations
require("profile.core.options")   -- Basic editor options
require("profile.core.autocmds")  -- Autocommands
require("profile.core.keymaps")   -- Keymaps and which-keysetup
require("profile.core.functions") -- Custom functions
require("profile.core.utils")     -- Utility functions
require("profile.core.mason")     -- Mason package manager

-- Load completion engine
require("profile.completion.cmp")

--Load debugging support
require("profile.dap.init")

-- Load LSP configurations
require("profile.lsp.lspconfig")

-- Load null-ls configurations
require("profile.null_ls.init")

-- Load tools configurations
require("profile.tools.conform")
require("profile.tools.lint")
pcall(function() require("profile.tools.copilot").setup() end)
require("profile.tools.neotest")

-- Load UI configurations
require("profile.ui.init")

-- Load language-specific configurations
require("profile.languages.asm")
require("profile.languages.ccpp")
require("profile.languages.csharp")
require("profile.languages.dbs")
require("profile.languages.flutter")
require("profile.languages.go")
require("profile.languages.java")
require("profile.languages.lua")
require("profile.languages.mojo")
require("profile.languages.python")
require("profile.languages.rust")
require("profile.languages.web")
require("profile.languages.zig")
require("profile.languages.php")  -- PHP languagesupport

-- Load Treesitter configuration
require("profile.treesitter")

-- Initialize language modules
pcall(function() require("profile.languages.asm").setup() end)
pcall(function() require("profile.languages.ccpp").setup() end)
pcall(function() require("profile.languages.csharp").setup() end)
pcall(function() require("profile.languages.dbs").setup() end)
pcall(function() require("profile.languages.flutter").setup() end)
pcall(function() require("profile.languages.go").setup() end)
pcall(function() require("profile.languages.java").setup() end)
pcall(function() require("profile.languages.lua").setup() end)
pcall(function() require("profile.languages.mojo").setup() end)
pcall(function() require("profile.languages.python").setup() end)
pcall(function() require("profile.languages.rust").setup() end)
pcall(function() require("profile.languages.web").setup() end)
pcall(function() require("profile.languages.zig").setup() end)
pcall(function() require("profile.languages.php").setup() end)  -- Initialize PHP support

-- Setup mason tool installer
require("mason-tool-installer").setup({
    ensure_installed = {
        -- Formatters
        "stylua",
        "prettier",
        "black",
        "clang-format",
        "rustfmt",
        "shfmt",
        "google-java-format",
        "phpcbf",
        
        -- Linters
        "luacheck",
        "eslint_d",
        "ruff",
        -- "clang-tidy",
        "phpstan",
        
        -- LSPs
        "lua_ls",
        "ts_ls",
        "pyright",
        "clangd",
        "rust_analyzer",
        "gopls",
        "intelephense",
        
        -- DAPs
        "php-debug-adapter",
        
        -- Others
        "asm-lsp",
        "asmfmt",
    },
    auto_update = true,
    run_on_start = true,
})