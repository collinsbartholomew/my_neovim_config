localM = {}

M.setup = function()
    -- Configure clangd extensions
    require("configs.cpp.lsp").setup()

    -- Configure CMake integration
    require("configs.cpp.cmake").setup()

    -- Set up code analysis and memory checks with overseer
    require("configs.cpp.overseer").setup()

    -- Set up treesitter tools
    require("configs.cpp.treesitter_tools").setup()

    -- Set up DAP
    require("configs.cpp.dap").setup()

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
    vim.keymap.set("n", "<leader>cl", "<cmd>CMakeClean<cr>", opts)

    -- Analysis keymaps
    vim.keymap.set("n", "<leader>dm", function()
        require("overseer").run_template({ name = "valgrind_check" })
    end, opts)

    -- Formatting is handled by tools/formatting.lua

    -- Auto create compile_commands.json symlink
    vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
            local compile_commands= vim.fn.findfile("compile_commands.json", "build;")
            if compile_commands ~= "" then
                local target = vim.fn.fnamemodify(compile_commands, ":p")
                local link = vim.fn.getcwd() .. "/compile_commands.json"
                vim.fn.system(string.format("ln -sf %s%s", target, link))
            end
        end,
    })
end

return M
