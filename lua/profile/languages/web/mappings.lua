-- added-by-agent: web-setup 20251020-173000
-- mason: none
-- manual: none

local M = {}

function M.setup()
  local which_key_status, which_key = pcall(require, "which-key")
  if not which_key_status then
    vim.notify("which-key not available for web mappings", vim.log.levels.WARN)
    return
  end

  which_key.register({
    w = {
      name = "Web",
      i = { "<cmd>PnpmInstall<cr>", "Install dependencies (pnpm)" },
      I = { "<cmd>NpmInstall<cr>", "Install dependencies (npm)" },
      d = { "<cmd>StartDevPnpm<cr>", "Start dev server (pnpm)" },
      D = { "<cmd>StartDev<cr>", "Start dev server (npm)" },
      f = { "<cmd>WebFormat<cr>", "Format code" },
    },
    d = {
      name = "Debug",
      t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
      b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
      c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
      C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
      d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
      g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
      i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
      o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
      u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
      p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
      r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
      s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
      q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
      U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    },
  }, { prefix = "<leader>" })
end

return M