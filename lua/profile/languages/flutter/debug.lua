-- added-by-agent: flutter-setup 20251020-160000
-- mason: dart-debug-adapter
-- manual: flutter/dart/fvm install commands listed in README

local M = {}

function M.setup(config)
  config = config or {}
  
  local dap_status, dap = pcall(require, "dap")
  if not dap_status then
    vim.notify("nvim-dap not available for Flutter debug setup", vim.log.levels.WARN)
    return
  end
  
  -- Locate dart-debug-adapter
  local adapter_cmd = nil
  
  -- Prefer Mason registry
  local mason_registry_status, mason_registry = pcall(require, "mason-registry")
  if mason_registry_status and mason_registry.is_installed("dart-debug-adapter") then
    local pkg = mason_registry.get_package("dart-debug-adapter")
    local install_path = pkg:get_install_path()
    adapter_cmd = install_path .. "/dart-debug-adapter"
  end
  
  -- Else check exepath
  if not adapter_cmd or vim.fn.executable(adapter_cmd) == 0 then
    local system_adapter = vim.fn.exepath("dart-debug-adapter")
    if system_adapter ~= "" then
      adapter_cmd = system_adapter
    end
  end
  
  -- Else check environment variable
  if not adapter_cmd or vim.fn.executable(adapter_cmd) == 0 then
    local env_adapter = os.getenv("DART_DEBUG_ADAPTER_PATH")
    if env_adapter and vim.fn.executable(env_adapter) == 1 then
      adapter_cmd = env_adapter
    end
  end
  
  -- If still not found, warn user
  if not adapter_cmd or vim.fn.executable(adapter_cmd) == 0 then
    vim.notify(
      "dart-debug-adapter not found. Please install via Mason or set DART_DEBUG_ADAPTER_PATH.",
      vim.log.levels.WARN
    )
    return
  end
  
  -- Register adapter
  dap.adapters.dart = {
    type = "executable",
    command = adapter_cmd,
    args = { "--debugger_port=12345" }
  }
  
  -- Set configurations
  dap.configurations.dart = {
    {
      type = "dart",
      request = "launch",
      name = "Launch Flutter",
      program = "${workspaceFolder}/lib/main.dart",
      cwd = "${workspaceFolder}",
    },
    {
      type = "dart",
      request = "attach",
      name = "Attach to Flutter",
      cwd = "${workspaceFolder}",
    }
  }
  
  dap.configurations.flutter = dap.configurations.dart
end

return M