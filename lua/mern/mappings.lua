local M = {}

function M.setup()
  local ok, which_key = pcall(require, "which-key")
  if not ok then
    return
  end

  which_key.register({
    f = {
      name = "File",
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    },
    e = {
      name = "Edit",
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    },
    g = {
      name = "Git",
      s = { "<cmd>Git<cr>", "Git Status" },
      c = { "<cmd>Git commit<cr>", "Git Commit" },
      p = { "<cmd>Git push<cr>", "Git Push" },
    },
    l = {
      name = "LSP",
      d = { "<cmd>Telescope diagnostics<cr>", "Document Diagnostics" },
      w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
      i = { "<cmd>LspInfo<cr>", "Lsp Info" },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
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