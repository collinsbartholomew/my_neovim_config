-- Python test configuration
local M = {}

function M.setup()
  local neotest_ok, neotest = pcall(require, "neotest")
  local neotest_python_ok = pcall(require, "neotest-python")
  
  if not (neotest_ok and neotest_python_ok) then
    return
  end

  -- Setup neotest with python adapter
  neotest.setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
      }),
    },
  })
end

return M