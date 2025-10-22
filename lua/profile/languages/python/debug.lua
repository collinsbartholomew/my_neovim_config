---
-- Python DAP configuration (debugpy)
-- Mason package: debugpy
local M = {}

function M.setup()
    local dap_ok, dap = pcall(require, "dap")
    local dapui_ok, dapui = pcall(require, "dapui")
    local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
    local virt_text_status_ok, virt_text = pcall(require, "nvim-dap-virtual-text")

    if not (dap_ok and dapui_ok and mason_dap_ok) then
        return
    end

    --Setup mason-nvim-dap
    mason_dap.setup({
        ensure_installed = { "debugpy" }
    })

    -- Setup dap-ui
    dapui.setup({
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.25 },
                    {id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                position = "left",
                size = 40,
            },
            {
elements = {
                    { id = "repl", size = 0.5 },
                    { id = "console", size = 0.5 },
                },
                position = "bottom",
                size = 10,
            },
        },
    })

    -- Setup virtual text if available
    if virt_text_status_ok then
        virt_text.setup({
            display_callback = function(variable)
                return string.format("%s = %s", variable.name, variable.value)
            end,
        })
    end

    -- Register dapui hooks
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- Python debugger configuration
    dap.adapters.python = {
        type= "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" }
    }

    -- Enhanced Python debug configurations
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            python = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    return venv_path .. "/bin/python"
                else
                    return "python"
                end
            end,
        },
        {
            type = "python",
            request = "launch",
name = "Launch module",
            module = function()
                return vim.fn.input("Module: ", "", "file")
            end,
            python = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    return venv_path .. "/bin/python"
                else
return "python"
                end
            end,
        },
        {
            type = "python",
            request = "launch",
            name = "Launch Flask",
            module = "flask",
            env = {
                FLASK_APP = function()
                    return vim.fn.input("Flask App: ", "app.py", "file")
                end,
                FLASK_ENV = "development",
                FLASK_DEBUG = "1",
            },
            python = function()
                localvenv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    return venv_path .. "/bin/python"
                else
                    return "python"
                end
            end,
        },
        {
            type = "python",
            request = "launch",
            name = "Launch FastAPI",
            module = "uvicorn",
            args = { "main:app", "--reload" },
            python = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    return venv_path .. "/bin/python"
                else
                    return "python"
               end
            end,
        },
        {
            type = "python",
            request = "launch",
            name = "Launch Django",
            program = function()
                return vim.fn.input("Manage.py path: ", "manage.py", "file")
            end,
            args = { "runserver" },
            python = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    return venv_path.. "/bin/python"
                else
                    return "python"
                end
            end,
        },
        {
            type = "python",
            request = "launch",
            name = "Launch pytest",
            module = "pytest",
            args = { "-x", "-v", "${file}" },
            python = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    return venv_path .. "/bin/python"
                else
                    return "python"
                end
            end,
        },
        {
            type = "python",
            request = "attach",
            name = "Attach to process",
            connect = {
                host = "127.0.0.1",
                port = 5678,
            },
            python = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    return venv_path .. "/bin/python"
                else
                    return "python"
                end
            end,
        },
   }

    require('profile.languages.python.mappings').dap()
end

return M