-- added-by-agent: web-setup 20251020-173000
-- mason: js-debug-adapter
-- manual: node.js installation required

local M = {}

function M.setup()
  local dap_status, dap = pcall(require, "dap")
  if not dap_status then
    vim.notify("nvim-dap not available for web debug setup", vim.log.levels.WARN)
    return
  end

  local dapui_status, dapui = pcall(require, "dapui")
  if dapui_status then
    dapui.setup()
  end

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

  dap.adapters["node"] = {
    type = "executable",
    command = "node",
    args = {
      vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "8123"
    }
  }

  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    }
  }

  dap.configurations.typescript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    }
  }

  -- Keymaps
  vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { silent = true })
  vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", { silent = true })
  vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", { silent = true })
  vim.keymap.set("n", "<F12>", ":DapStepOut<CR>", { silent = true })
  vim.keymap.set("n", "<leader>b", ":DapToggleBreakpoint<CR>", { silent = true })
  vim.keymap.set("n", "<leader>B", ":DapSetBreakpoint<CR>", { silent = true })
  
  if dapui_status then
    vim.keymap.set("n", "<leader>du", ":DapUiToggle<CR>", { silent = true })
  end
end

return M