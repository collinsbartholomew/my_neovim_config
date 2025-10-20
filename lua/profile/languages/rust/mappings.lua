-- added-by-agent: rust-setup 20251020
local M = {}
local wk = require('which-key')
function M.setup()
  wk.register({
    r = {
      name = 'Rust',
      rr = { function() require('rust-tools').runnables.runnables() end, 'Rust runnables' },
      rt = { function() require('neotest').run.run(vim.fn.expand('%')) end, 'Run tests in file' },
      rd = { function() require('dap').continue() end, 'Debug (DAP continue)' },
      rc = { '<cmd>RustClippy<CR>', 'Cargo clippy' },
      rf = { function() require('conform').format() end, 'Format buffer' },
    },
    d = {
      name = 'Debug',
      db = { function() require('dap').toggle_breakpoint() end, 'Toggle Breakpoint' },
      dc = { function() require('dap').continue() end, 'Continue' },
      do_ = { function() require('dap').step_over() end, 'Step Over' },
      di = { function() require('dap').step_into() end, 'Step Into' },
      du = { function() require('dapui').toggle() end, 'Toggle DAP UI' },
    },
    c = {
      name = 'Cargo',
      cb = { '<cmd>split | terminal cargo build<CR>', 'Cargo build' },
      ct = { '<cmd>split | terminal cargo test<CR>', 'Cargo test' },
      cr = { '<cmd>split | terminal cargo run<CR>', 'Cargo run' },
      ca = { '<cmd>RustAudit<CR>', 'Cargo audit' },
    },
  }, { prefix = '<leader>' })
end
function M.lsp(bufnr)
  wk.register({
    ['<leader>lh'] = { function() vim.lsp.buf.hover() end, 'Hover' },
    ['<leader>lr'] = { function() vim.lsp.buf.rename() end, 'Rename' },
    ['<leader>la'] = { function() vim.lsp.buf.code_action() end, 'Code Action' },
    ['<leader>ld'] = { function() vim.diagnostic.open_float() end, 'Diagnostics' },
    ['<leader>lf'] = { function() require('conform').format() end, 'Format' },
  }, { buffer = bufnr })
end
return M

