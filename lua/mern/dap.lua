local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  -- Setup dap-ui
  dapui.setup()

  -- Setup js-debug-adapter
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = 8123,
    executable = {
      command = "js-debug-adapter",
      args = { "8123" },
    },
  }

  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }

  dap.configurations.typescript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }

  -- Keymaps
  vim.keymap.set("n", "<F5>", ":DapContinue<CR>")
  vim.keymap.set("n", "<F10>", ":DapStepOver<CR>")
  vim.keymap.set("n", "<F11>", ":DapStepInto<CR>")
  vim.keymap.set("n", "<F12>", ":DapStepOut<CR>")
  vim.keymap.set("n", "<leader>b", ":DapToggleBreakpoint<CR>")
  vim.keymap.set("n", "<leader>B", ":DapSetBreakpoint<CR>")
end

return M