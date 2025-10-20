-- Undotree setup
if not pcall(require, 'undotree') then return end
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_SplitWidth = 40
vim.g.undotree_DiffpanelHeight = 12

vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle Undotree' })
require('which-key').register({ u = 'Toggle Undotree' }, { prefix = '<leader>' })

