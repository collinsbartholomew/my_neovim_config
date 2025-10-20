-- Toggleterm setup
if not pcall(require, 'toggleterm') then return end
require('toggleterm').setup({
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 3,
    highlights = {
      border = 'Normal',
      background = 'Normal',
    },
  },
})

local Terminal = require('toggleterm.terminal').Terminal
function _lazygit_toggle()
  Terminal:new({ cmd = 'lazygit', hidden = true }):toggle()
end
function _node_toggle()
  Terminal:new({ cmd = 'node', hidden = true }):toggle()
end

vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>tg', _lazygit_toggle, { desc = 'Toggle lazygit' })
vim.keymap.set('n', '<leader>tn', _node_toggle, { desc = 'Toggle node REPL' })

require('which-key').register({
  t = {
    name = 'Terminal',
    tt = 'Toggle terminal',
    tg = 'Toggle lazygit',
    tn = 'Toggle node REPL',
  },
}, { prefix = '<leader>' })
