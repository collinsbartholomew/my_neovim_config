-- Keymaps and which-key setup
vim.g.mapleader = ' '
local wk = require('which-key')
wk.register({
  f = { name = 'Telescope', ff = 'Find Files', fg = 'Live Grep', fb = 'Buffers', fh = 'Help Tags' },
  g = { name = 'Git' },
  l = { name = 'LSP', la = 'Code Action', lr = 'Rename', ld = 'Diagnostics' },
  d = { name = 'Debug' },
  t = { name = 'Theme/UI', tt = 'Toggle Theme', tr = 'Toggle Transparency' },
  b = { name = 'Buffers' },
}, { prefix = '<leader>' })

