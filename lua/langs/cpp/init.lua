local M = {}

M.setup = function()
    -- Configure clangd extensions
    local clangd_capabilities = require("cmp_nvim_lsp").default_capabilities()
    clangd_capabilities.offsetEncoding = { "utf-16" }

    require("clangd_extensions").setup({
        server = {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=never",
                "--completion-style=detailed",
                "--cross-file-rename",
                "--enable-config",
                "--pch-storage=memory",
                "--header-insertion-decorators",
                "--all-scopes-completion",
                "--offset-encoding=utf-16",
            },
            capabilities = clangd_capabilities,
            on_attach = function(_, bufnr)
                -- Enable inlay hints
                require("clangd_extensions.inlay_hints").setup_autocmd()
                require("clangd_extensions.inlay_hints").set_inlay_hints()

                -- Buffer-local keymaps
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
                vim.keymap.set("n", "<leader>cs", "<cmd>ClangdSymbolInfo<cr>", opts)
                vim.keymap.set("n", "<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", opts)
                vim.keymap.set("n", "<leader>cm", "<cmd>ClangdMemoryUsage<cr>", opts)
                vim.keymap.set("n", "gh", "<cmd>ClangdSwitchSourceHeader<cr>", opts)

                -- LSP keymaps
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
        },
    })

    -- Configure CMake integration
    require("cmake-tools").setup({
        cmake_command = "cmake",
        cmake_build_directory = "build",
        cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_console_size = 10,
        cmake_show_console = "always",
        cmake_variants_message = {
            short = { show = true },
            long = { show = true, max_length = 40 },
        },
    })

    -- Set up code analysis and memory checks with overseer
    require("overseer").setup({
        templates = { "builtin", "cpp_build" },
        task_list = {
            direction = "right",
            width = 60,
            min_width = 10,
            max_width = 80,
            default_detail = 1,
            initial_detail = 1,
        },
    })

    -- Register memory check tasks
    local overseer = require("overseer")
    overseer.register_template({
        name = "valgrind_check",
        builder = function()
            local file = vim.fn.expand("%:p")
            return {
                cmd = { "valgrind" },
                args = { "--leak-check=full", "--show-leak-kinds=all", "--track-origins=yes", file },
                components = { { "on_output_quickfix", set_diagnostics = true }, "default" },
            }
        end,
        condition = { filetype = { "c", "cpp" } },
    })

    -- Set up keymaps
    local opts = { noremap = true, silent = true }

    -- CMake keymaps
    -- CMake commands under make/build prefix
    vim.keymap.set("n", "<leader>mg", "<cmd>CMakeGenerate<cr>", opts)
    vim.keymap.set("n", "<leader>mb", "<cmd>CMakeBuild<cr>", opts)
    vim.keymap.set("n", "<leader>mr", "<cmd>CMakeRun<cr>", opts)

    -- C++-specific commands under cpp prefix
    vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
    vim.keymap.set("n", "<leader>ci", "<cmd>ClangdSymbolInfo<cr>", opts)
    vim.keymap.set("n", "<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", opts)
    vim.keymap.set("n", "<leader>cm", "<cmd>ClangdMemoryUsage<cr>", opts)
    vim.keymap.set("n", "<leader>cd", "<cmd>CMakeDebug<cr>", opts)
    vim.keymap.set("n", "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", opts)
    vim.keymap.set("n", "<leader>cl", "<cmd>CMakeClean<cr>", opts)

    -- Analysis keymaps
    vim.keymap.set("n", "<leader>dm", function()
        overseer.run_template({ name = "valgrind_check" })
    end, opts)

    -- Formatting is handled by tools/formatting.lua

    -- Auto create compile_commands.json symlink
    vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
            local compile_commands = vim.fn.findfile("compile_commands.json", "build;")
            if compile_commands ~= "" then
                local target = vim.fn.fnamemodify(compile_commands, ":p")
                local link = vim.fn.getcwd() .. "/compile_commands.json"
                vim.fn.system(string.format("ln -sf %s %s", target, link))
            end
        end,
    })
end

return M
