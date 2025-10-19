return {
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("configs.cpp.lsp")
        end,
    },
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        ft = { "c", "cpp", "cmake" },
        config = function()
            require("configs.cpp.cmake")
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            require("configs.cpp.dap")
        end,
    },
    {
        "Badhi/nvim-treesitter-cpp-tools",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        ft = { "c", "cpp" },
        config = function()
            require("configs.cpp.treesitter_tools")
        end,
    },
    {
        "stevearc/overseer.nvim",
        ft = { "c", "cpp" },
        opts = {},
        config = function()
            require("configs.cpp.overseer").setup()
        end,
    },
}
