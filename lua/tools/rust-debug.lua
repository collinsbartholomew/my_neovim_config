local M = {}

-- Default test configuration
M.test_config = {
    name = "Rust Test Runner",
    type = "rust",
    request = "launch",
    stopOnEntry = false,
    showDisassembly = "never",
    sourceLanguages = {"rust"},
    -- Custom cargo test commands
    cargo = {
        -- Test runner args
        args = {
            "test",
            "--no-run",
            "--lib",
            "--message-format=json",
        },
        filter = {
            name = "${workspaceFolder}",
            kind = "lib",
        },
    },
}

-- Debug test configuration
M.debug_config = {
    name = "Debug Rust Program",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    showDisassembly = "never",
    sourceLanguages = {"rust"},
    -- Custom debug args
    program = function()
        -- Get the binary path from cargo metadata
        local metadata_json = vim.fn.system("cargo metadata --format-version 1")
        local metadata = vim.fn.json_decode(metadata_json)
        local target_dir = metadata.target_directory
        return target_dir .. "/debug/" .. vim.fn.fnamemodify(metadata.workspace_root, ":t")
    end,
    -- Environment setup
    env = {
        RUST_BACKTRACE = "1",
    },
}

-- Keymaps for test running
M.keymaps = {
    -- Run single test under cursor
    run_test = function()
        local line_nr = vim.api.nvim_win_get_cursor(0)[1]
        local test_name

        -- Find the test function name
        for i = line_nr, 1, -1 do
            local line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1]
            if line:match("#%[test%]") then
                local next_line = vim.api.nvim_buf_get_lines(0, i, i+1, false)[1]
                test_name = next_line:match("fn%s+([%w_]+)")
                break
            end
        end

        if test_name then
            vim.cmd(string.format("! cargo test %s", test_name))
        else
            vim.notify("No test found at cursor position", vim.log.levels.WARN)
        end
    end,

    -- Debug single test under cursor
    debug_test = function()
        local dap = require("dap")
        local line_nr = vim.api.nvim_win_get_cursor(0)[1]
        local test_name

        -- Find the test function name
        for i = line_nr, 1, -1 do
            local line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1]
            if line:match("#%[test%]") then
                local next_line = vim.api.nvim_buf_get_lines(0, i, i+1, false)[1]
                test_name = next_line:match("fn%s+([%w_]+)")
                break
            end
        end

        if test_name then
            local config = vim.deepcopy(M.test_config)
            config.args = config.args or {}
            table.insert(config.args, test_name)
            dap.run(config)
        else
            vim.notify("No test found at cursor position", vim.log.levels.WARN)
        end
    end,
}

function M.setup()
    -- Set up Rust debugging keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>rt", M.keymaps.run_test, opts)
    vim.keymap.set("n", "<leader>dt", M.keymaps.debug_test, opts)
    vim.keymap.set("n", "<leader>rr", ":RustRun<CR>", opts)
    vim.keymap.set("n", "<leader>ra", ":! cargo test<CR>", opts)

    -- Initialize DAP configurations
    local dap = require("dap")
    dap.configurations.rust = dap.configurations.rust or {}
    table.insert(dap.configurations.rust, M.test_config)
    table.insert(dap.configurations.rust, M.debug_config)
end

return M
