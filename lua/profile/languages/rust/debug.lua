-- added-by-agent: rust-setup 20251020
-- Mason: codelldb
local M = {}

local function get_codelldb_paths()
    local mason_registry = require('mason-registry')
    local ok, pkg = pcall(mason_registry.get_package, 'codelldb')
    if not ok then
        return nil
    end
    local install_path = pkg:get_install_path()
    
    -- Platform specific paths
    local adapter
    local liblldb
    
    if vim.fn.has("mac") == 1 then
        adapter = install_path .. '/extension/adapter/codelldb'
        liblldb = install_path .. '/extension/lldb/lib/liblldb.dylib'
    elseif vim.fn.has("unix") == 1 then
        adapter = install_path .. '/extension/adapter/codelldb'
        liblldb = install_path .. '/extension/lldb/lib/liblldb.so'
    elseif vim.fn.has("win32") == 1 then
        adapter = install_path .. '/extension/adapter/codelldb.exe'
        liblldb = install_path .. '/extension/lldb/bin/liblldb.dll'
    end
    
    return adapter, liblldb
end

function M.get_codelldb_adapter()
    local adapter, liblldb = get_codelldb_paths()
    if not adapter then
        return nil
    end
    return require('rust-tools.dap').get_codelldb_adapter(adapter, liblldb)
end

function M.setup()
    local dap_status_ok, dap = pcall(require, 'dap')
    if not dap_status_ok then
        vim.notify("nvim-dap not available", vim.log.levels.WARN)
        return
    end

    local adapter, liblldb = get_codelldb_paths()
    if not adapter then
        vim.notify("codelldb not found in Mason", vim.log.levels.WARN)
        return
    end

    dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
            command = adapter,
            args = { '--port', '${port}' },
            detached = true,
        },
    }

    -- Enhanced Rust debug configurations
    dap.configurations.rust = {
        {
            name = 'Launch file',
            type = 'codelldb',
            request = 'launch',
            program = function()
                -- Try to find the executable based on current file
                local cargo_toml = vim.fn.findfile('Cargo.toml', '.;')
                if cargo_toml ~= '' then
                    local cargo_dir = vim.fn.fnamemodify(cargo_toml, ':p:h')
                    local manifest = vim.fn.readfile(cargo_toml)
                    local package_name = 'debug'
                    for _, line in ipairs(manifest) do
                        local name = string.match(line, '^name%s*=%s*["\'](.+)["\']')
                        if name then
                            package_name = name
                            break
                        end
                    end
                    return vim.fn.input('Path to executable: ', cargo_dir .. '/target/debug/' .. package_name, 'file')
                else
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = function()
                return vim.split(vim.fn.input('Arguments: ', ""), " ")
            end,
        },
        {
            name = 'Debug executable',
            type = 'codelldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
        },
        {
            name = 'Debug unit tests',
            type = 'codelldb',
            request = 'launch',
            program = function()
                local cargo_cmd = string.format(
                    "cargo test --no-run --message-format=json 2>/dev/null | jq -r 'select(.profile.test == true) | .filenames[]' | head -n1"
                )
                local handle = io.popen(cargo_cmd)
                if handle then
                    local result = handle:read("*a")
                    handle:close()
                    if result and result ~= "" then
                        return vim.trim(result)
                    end
                end
                return vim.fn.input('Path to test executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = function()
                return { "--nocapture" }
            end,
        },
        {
            name = 'Attach to process',
            type = 'codelldb',
            request = 'attach',
            pid = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
        },
    }

    -- Setup DAP UI if available
    local dapui_status_ok, dapui = pcall(require, 'dapui')
    if dapui_status_ok then
        dapui.setup()
        
        -- Auto-open DAP UI when debug session starts
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end

        -- Auto-close DAP UI when debug session ends
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end

    -- Setup virtual text if available
    local virt_text_status_ok, virt_text = pcall(require, 'nvim-dap-virtual-text')
    if virt_text_status_ok then
        virt_text.setup()
    end
end

return M