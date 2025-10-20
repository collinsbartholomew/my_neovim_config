-- Python setup module
local M = {}

function M.setup()
  -- Load all Python modules
  local python_modules = {
    "python.lsp",
    "python.dap",
    "python.test",
    "python.tools"
  }

  for _, module in ipairs(python_modules) do
    local status_ok, mod = pcall(require, module)
    if status_ok and mod and type(mod.setup) == "function" then
      mod.setup()
    end
  end
end

return M