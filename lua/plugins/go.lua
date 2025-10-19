return {
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod", "gowork", "gotmpl" },
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest",
            "nvim-neotest/neotest-go",
        },
        build = ':lua require("go.install").update_all_sync()',
        config = function()
            require("langs.go.neotest").setup()
            require("go").setup({
                -- Golang configuration
                go = "go",
                goimport = "gopls",
                fillstruct = "gopls",
                gofmt = "gofumpt",
                max_line_len = 120,
                tag_transform = false,
                test_template = "",
                test_dir = "",
                comment_placeholder = "",
                icons = { breakpoint = "🔴", currentpos = "🔷" },
                verbose = false,
                lsp_cfg = false,
                lsp_gofumpt = true,
                lsp_on_attach = false,
                gopls_remote_auto = true,
                gofmt_on_save = true,
                lsp_document_formatting = true,
                lsp_inlay_hints = {
                    enable = true,
                    only_current_line = false,
                    show_variable_name = true,
                },
                trouble = true,
                test_runner = "go",
                run_in_floaterm = false,
                dap_debug = true,
                dap_debug_gui = true,
                dap_debug_keymap = true,
                luasnip = true,
            })
        end,
    }
}
