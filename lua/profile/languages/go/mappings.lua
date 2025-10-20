---
-- Go keymaps and which-key registration
local M = {}
local wk = require('which-key')
function M.setup()
  wk.register({
    g = {
      name = 'Go',
      gf = { '<cmd>lua require("conform").format()<CR>', 'Format Go buffer' },
      gi = { '<cmd>lua require("go.format").impl_interface()<CR>', 'Implement interface' },
    },
    r = {
      name = 'Run/Test',
      rt = { '<cmd>lua require("neotest").run.run(vim.fn.getcwd())<CR>', 'Run package tests' },
      rtf = { '<cmd>lua require("neotest").run.run()<CR>', 'Run test under cursor' },
      rr = { '<cmd>lua require("dap").continue()<CR>', 'DAP Continue/Run' },
      rd = { '<cmd>GoLint<CR>', 'Run Go Lint' },
      rf = { '<cmd>lua require("conform").format()<CR>', 'Format Go buffer' },
    },
    d = {
      name = 'Debug',
      db = { '<cmd>lua require("dap").toggle_breakpoint()<CR>', 'Toggle Breakpoint' },
      dc = { '<cmd>lua require("dap").continue()<CR>', 'Continue' },
      dv = { '<cmd>lua require("dap").step_over()<CR>', 'Step Over' },
      di = { '<cmd>lua require("dap").step_into()<CR>', 'Step Into' },
      du = { '<cmd>lua require("dapui").toggle()<CR>', 'Toggle DAP UI' },
    },
  }, { prefix = '<leader>' })
end
function M.lsp(bufnr)
  wk.register({
    ['<leader>lr'] = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
    ['<leader>la'] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
    ['<leader>ld'] = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostics' },
  }, { buffer = bufnr })
end
function M.dap()
  wk.register({
    ['<leader>db'] = { '<cmd>lua require("dap").toggle_breakpoint()<CR>', 'Toggle Breakpoint' },
    ['<leader>dc'] = { '<cmd>lua require("dap").continue()<CR>', 'Continue' },
    ['<leader>do'] = { '<cmd>lua require("dap").step_over()<CR>', 'Step Over' },
    ['<leader>di'] = { '<cmd>lua require("dap").step_into()<CR>', 'Step Into' },
    ['<leader>du'] = { '<cmd>lua require("dapui").toggle()<CR>', 'Toggle DAP UI' },
  })
end
return M

