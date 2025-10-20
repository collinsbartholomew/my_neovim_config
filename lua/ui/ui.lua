-- UI configuration for Python development
local M = {}

function M.setup()
  -- Setup for Python-specific UI enhancements
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    return
  end

  -- Python keymaps
  which_key.add({
    { "<leader>p", group = "Python" },
    { "<leader>pd", "<cmd>lua require('dap-python').test_method()<cr>", desc = "Debug method" },
    { "<leader>pf", "<cmd>lua require('dap-python').test_class()<cr>", desc = "Debug class" },
    { "<leader>ps", "<cmd>lua require('dap-python').debug_selection()<cr>", desc = "Debug selection" },
  })

  -- Test keymaps
  which_key.add({
    { "<leader>t", group = "Test" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run file tests" },
    { "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
    { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Show test output" },
    { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle test summary" },
  })
end

return M