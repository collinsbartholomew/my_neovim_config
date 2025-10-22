---
-- Assembly debugging configuration
local M = {}

function M.setup()
    local dap_ok, dap = pcall(require, "dap")
    if not dap_ok then
        return
    end

    -- GDB adapter for assembly debugging
    dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--quiet", "--interpreter=dap" }
    }

    -- LLDB adapter for assembly debugging
    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb"
    }

    -- Assembly debug configurations
    dap.configurations.asm = {
        {
            name = "Launch Assembly (GDB)",
            type = "gdb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
        },
        {
            name = "Launch Assembly (LLDB)",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
        {
            name = "Attach to process (GDB)",
            type = "gdb",
            request = "attach",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            pid = function()
                return tonumber(vim.fn.input('Process ID: '))
            end,
            cwd = "${workspaceFolder}",
        },
    }

    -- Register DAP virtual text
    local dapui_ok, dapui = pcall(require, "dapui")
    if dapui_ok then
        dapui.setup()
        
        local dapvt_ok, virt_text = pcall(require, "nvim-dap-virtual-text")
        if dapvt_ok then
            virt_text.setup()
        end
    end

    -- Custom functions for assembly debugging
    _G.assembly = {
        -- Function to set up register view
        setup_registers = function()
            local widgets = require('dap.ui.widgets')
            local sidebar = widgets.sidebar(widgets.scopes)
            sidebar.open()
        end,

        -- Function to disassemble current function
        disassemble = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
            if filetype ~= 'asm' then
                print("Not in an assembly file")
                return
            end
            
            local filename = vim.api.nvim_buf_get_name(bufnr)
            local basename = vim.fn.fnamemodify(filename, ":r")
            local output = basename .. "_disasm.asm"
            
            vim.fn.jobstart({"objdump", "-d", filename, "-o", output}, {
                on_exit = function()
                    print("Disassembled to " .. output)
                end
            })
        end
    }
end

return M