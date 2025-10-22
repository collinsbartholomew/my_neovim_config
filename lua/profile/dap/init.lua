-- nvim-dap setup
local dap = require('dap')
local dapui = require("dapui")
local mason_dap = require("mason-nvim-dap")

mason_dap.setup({
    ensure_installed = { "python", "java", "js", "cppdbg", "delve" },
    automatic_installation = true,
})

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

-- Adapters configs
-- Python
dap.adapters.python = { type = "executable", command = "python", args = { "-m", "debugpy", "adapter" } }

-- Lua
dap.adapters["local-lua"] = {
  type = 'executable',
  command = 'local-lua-debugger-vscode',
  args = { '${port}' }
}

dap.configurations.lua = {
  {
    type = 'local-lua',
    request = 'launch',
    name = "Debug Lua",
    program = "${file}",
    lua = "lua",
    stopOnEntry = false,
  }
}

-- Java (assumes vscode-java-debug installed via mason or manually)
-- More configs as needed

-- TODO: Configure codelldb, delve, java-debug, netcoredbg, python adapters
-- Example: Rust/C++
dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
    },
}
-- Example: Go
dap.adapters.go = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
    },
}

return {}