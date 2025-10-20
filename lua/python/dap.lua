-- Python DAP configuration
local M = {}

function M.setup()
  local dap_ok, dap = pcall(require, "dap")
  local dapui_ok, dapui = pcall(require, "dapui")
  local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
  
  if not (dap_ok and dapui_ok and mason_dap_ok) then
    return
  end

  -- Setup mason-nvim-dap
  mason_dap.setup({
    ensure_installed = { "debugpy" }
  })

  -- Setup dap-ui
  dapui.setup()

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
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" }
  }

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
  }
end

return M