local dap = require("dap")
local dapui = require("dapui")
local mason_dap = require("mason-nvim-dap")

mason_dap.setup({
  ensure_installed = { "python", "java", "js", "cppdbg", "delve" },
  automatic_installation = true,
})

dapui.setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- Adapters configs
-- Python
dap.adapters.python = { type = "executable", command = "python", args = { "-m", "debugpy", "adapter" } }

-- Java (assumes vscode-java-debug installed via mason or manually)
-- More configs as needed

return {}