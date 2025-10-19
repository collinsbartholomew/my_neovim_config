local M = {}

M.setup = function()
    -- Plugin setup for go.nvim
    require("go").setup({
        -- Core features
        goimport = 'gopls',
        fillstruct = 'gopls',
        test_runner = 'richgo',
        dap_debug = true,
        dap_debug_keymap = false, -- use our unified DAP keymaps
        luasnip = true,

        -- LSP configuration
        lsp_cfg = {
            settings = {
                gopls = {
                    analyses = {
                        nilness = true,
                        shadow = true,
                        unusedparams = true,
                        unusedwrite = true,
                    },
                    staticcheck = true,
                    usePlaceholders = true,
                    completeUnimported = true,
                    semanticTokens = true,
                    codelenses = {
                        gc_details = true,
                        generate = true,
                        regenerate_cgo = true,
                        test = true,
                        tidy = true,
                        vendor = true,
                        upgrade_dependency = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                },
            },
        },

        -- Testing configuration
        test_flags = {
            "-v",
            "-count=1",
        },

        -- UI configuration
        icons = true,
        sign_priority = 10,
        float_win_opts = {
            border = 'rounded',
        },
    })

    -- Setup testing with neotest-go
    require("neotest").setup({
        adapters = {
            require("neotest-go")({
                experimental = {
                    test_table = true,
                },
                args = { "-count=1", "-timeout=60s" }
            })
        }
    })

    -- Keymaps
    local opts = { noremap = true, silent = true }

    -- LSP keymaps
    vim.keymap.set("n", "<leader>gi", "<cmd>GoImplements<CR>", opts)
    vim.keymap.set("n", "<leader>gf", "<cmd>GoFillStruct<CR>", opts)
    vim.keymap.set("n", "<leader>ge", "<cmd>GoIfErr<CR>", opts)
    vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<CR>", opts)
    vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", opts)
    vim.keymap.set("n", "<leader>gtf", "<cmd>GoTestFile<CR>", opts)
    vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", opts)
    vim.keymap.set("n", "<leader>gca", "<cmd>GoCoverage -a<CR>", opts)
    vim.keymap.set("n", "<leader>gl", "<cmd>GoLint<CR>", opts)
    vim.keymap.set("n", "<leader>gdd", "<cmd>GoDoc<CR>", opts)

    -- Auto commands
    local group = vim.api.nvim_create_augroup("GoFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
            require("go.format").goimport()
        end,
        group = group,
    })
end

return M
