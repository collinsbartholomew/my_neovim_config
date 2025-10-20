-- added-by-agent: csharp-setup 20251020-153000
-- mason: none
-- manual: none

local M = {}

function M.setup()
  local whichkey_ok, wk = pcall(require, "which-key")
  if not whichkey_ok then
    vim.notify("which-key not available for C# mappings", vim.log.levels.WARN)
    return
  end

  wk.register({
    c = {
      name = "C#",
      b = { "<cmd>DotnetBuild<cr>", "Build project" },
      t = { "<cmd>DotnetTest<cr>", "Run tests" },
      r = { "<cmd>DotnetRun<cr>", "Run project" },
      f = { "<cmd>DotnetFormat<cr>", "Format code" },
    },
    d = {
      name = "Debug",
      d = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
      b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
      r = { "<cmd>lua require'dap'.restart()<cr>", "Restart" },
      s = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
      i = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
      o = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
      u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    },
    o = {
      name = "OmniSharp",
      r = { "<cmd>OmniReload<cr>", "Reload OmniSharp" },
      p = { "<cmd>lua require('telescope.builtin').find_files({prompt_title='Projects', cwd=vim.fn.getcwd(), hidden=false})<cr>", "Pick project" },
    },
  }, { prefix = "<leader>" })
end

return M