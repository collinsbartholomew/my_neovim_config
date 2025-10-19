return {
    -- Web Development
    {
        "pmizio/typescript-tools.nvim",
        ft = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {},
    },

    {
        "vuki656/package-info.nvim",
        event = "BufRead package.json",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            hide_up_to_date = true,
            package_manager = "npm",
        },
    },

    -- Python Development
    {
        "linux-cultist/venv-selector.nvim",
        ft = "python",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap-python",
        },
        opts = {
            name = {
                "venv",
                ".venv",
                "env",
                ".env",
            },
            auto_refresh = true,
        },
        keys = {
            { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
        },
    },

    -- Flutter/Dart Development
    {
        "akinsho/flutter-tools.nvim",
        ft = "dart",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
        },
        config = function()
            require("langs.mobile.flutter-tools").setup()
        end,
    },

    -- Docker and Infrastructure
    {
        "https://codeberg.org/esensar/nvim-dev-container",
        dependencies = "nvim-treesitter/nvim-treesitter",
        lazy = true,
        cmd = {
            "DevcontainerStart",
            "DevcontainerStop",
            "DevcontainerBuild",
            "DevcontainerAttach",
            "DevcontainerEdit",
            "DevcontainerImageRun",
        },
        config = function()
            require("devcontainer").setup({
                attach_mounts = {
                    always = true,
                    neovim_config = {
                        enabled = true,
                        options = { "readonly" },
                    },
                    neovim_data = {
                        enabled = true,
                        options = {},
                    },
                },
            })
        end,
    },

    -- Markdown and Documentation
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            {
                "<leader>cp",
                ft = "markdown",
                "<cmd>MarkdownPreviewToggle<cr>",
                desc = "Markdown Preview",
            },
        },
        config = function()
            vim.cmd([[do FileType]])
        end,
    },
}
