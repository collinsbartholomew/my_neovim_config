return {
    {
        "simrat39/rust-tools.nvim",
        ft = { "rust" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("langs.rust").setup()
        end,
    },
    {
        "saecki/crates.nvim",
        ft = { "toml" },
        config = function()
            require("langs.rust.crates").setup()
        end,
    },
}

