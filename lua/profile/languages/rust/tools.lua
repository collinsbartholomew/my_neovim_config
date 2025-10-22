-- added-by-agent: rust-setup 20251020
-- Mason: rustfmt (if available)
-- Manual: rustup component add rustfmt clippy
local M = {}

function M.setup()
    -- Using centralized conform.lua configuration for formatting
    
    -- Helper function to run commands in a terminal buffer
    local function run_in_term(cmd, title)
        vim.cmd("botright new")
        local buf = vim.api.nvim_get_current_buf()
        local chan = vim.api.nvim_open_term(buf, {})
        vim.api.nvim_buf_set_name(buf, title)
        vim.fn.jobstart(cmd, {
            on_stdout = function(_, data)
                data = table.concat(data, "\n")
                vim.api.nvim_chan_send(chan, data)
            end,
            on_stderr = function(_, data)
                data = table.concat(data, "\n")
                vim.api.nvim_chan_send(chan, data)
            end,
            stdout_buffered = true,
            stderr_buffered = true,
        })
    end

    -- Cargo commands
    vim.api.nvim_create_user_command("CargoBuild", function()
        local args = vim.fn.input("Build args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo build %s", args) },
            "[Cargo Build]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoRun", function()
        local args = vim.fn.input("Run args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo run %s", args) },
            "[Cargo Run]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoTest", function()
        local args = vim.fn.input("Test args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo test %s", args) },
            "[Cargo Test]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoCheck", function()
        local args = vim.fn.input("Check args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo check %s", args) },
            "[Cargo Check]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoClippy", function()
        local args = vim.fn.input("Clippy args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo clippy %s", args) },
            "[Cargo Clippy]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoDoc", function()
        run_in_term(
            { "sh", "-c", "cargo doc --open" },
            "[Cargo Doc]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoAudit", function()
        run_in_term(
            { "sh", "-c", "cargo audit" },
            "[Cargo Audit]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoExpand", function()
        local args = vim.fn.input("Expand args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo expand %s", args) },
            "[Cargo Expand]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoFmt", function()
        local args = vim.fn.input("Fmt args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo fmt %s", args) },
            "[Cargo Fmt]"
        )
    end, {})

    vim.api.nvim_create_user_command("CargoBench", function()
        local args = vim.fn.input("Bench args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo bench %s", args) },
            "[Cargo Bench]"
        )
    end, {})

    -- Memory analysis
    vim.api.nvim_create_user_command("CargoValgrind", function()
        local args = vim.fn.input("Valgrind args: ", "")
        run_in_term(
            { "sh", "-c", string.format("cargo valgrind %s", args) },
            "[Cargo Valgrind]"
        )
    end, {})

    -- Coverage
    vim.api.nvim_create_user_command("CargoCoverage", function()
        run_in_term(
            { "sh", "-c", "cargo llvm-cov --html && xdg-open target/llvm-cov/html/index.html" },
            "[Cargo Coverage]"
        )
    end, {})

    -- Setup crates.nvim for dependency management
    local crates_status_ok, crates = pcall(require, 'crates')
    if crates_status_ok then
        crates.setup({
            src = {
                cmp = {
                    enabled = true,
                },
            },
            null_ls = {
                enabled = false,
            },
            popup = {
                autofocus = true,
                border = "rounded",
            },
        })
        
        -- Show crates info in TOML files
        vim.api.nvim_create_autocmd('BufEnter', {
            pattern = 'Cargo.toml',
            callback = function()
                crates.show()
            end,
        })
    end
end

return M