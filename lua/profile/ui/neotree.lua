-- Neo-tree setup
if not pcall(require, 'neo-tree') then return end
require('neo-tree').setup({
  close_if_last_window = true,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = true,
    hijack_netrw_behavior = 'open_default',
  },
  window = {
    position = 'left',
    width = 32,
    mappings = {
      ['<space>'] = 'none',
    },
  },
})

vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
require('which-key').register({ e = 'Toggle Neo-tree' }, { prefix = '<leader>' })

-- Undotree setup
local status_ok, undotree = pcall(require, 'undotree')
if not status_ok then return end

-- Recommended options
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_SplitWidth = 40
vim.g.undotree_DiffpanelHeight = 12

-- Keymap and which-key registration
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle Undotree' })
local wk = require('which-key')
wk.register({ u = 'Toggle Undotree' }, { prefix = '<leader>' })
