-- Trouble UI configuration (moved from configs.ui.trouble)
local M = {}
local _setup_done = false

function M.setup()
  if _setup_done then return end
  _setup_done = true

  local ok, trouble = pcall(require, 'trouble')
  if not ok then
    vim.notify('trouble.nvim not available', vim.log.levels.WARN)
    return {}
  end

  trouble.setup({
    position = 'bottom',
    height = 10,
    icons = true,
    mode = 'workspace_diagnostics',
    fold_open = 'open',
    fold_closed = 'close',
    action_keys = {
      close = 'q',
      cancel = '<esc>',
      refresh = 'r',
      jump = { '<cr>', 'o' },
    },
  })

  -- keymaps (idempotent)
  pcall(function()
    vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>xX', '<cmd>TroubleToggle document_diagnostics<cr>', { desc = 'Buffer Diagnostics' })
  end)
end

return M
