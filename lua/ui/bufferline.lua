-- Lightweight bufferline configuration
-- Provides a setup() function and non-invasive keymaps for buffer navigation.
local M = {}

-- Default configuration (can be overridden by passing a table to setup)
local default_config = {
  options = {
    numbers = "ordinal",
    indicator = { style = 'underline' },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 30,
    max_prefix_length = 15,
    tab_size = 20,
    enforce_regular_tabs = false,
    view = 'tabs',
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_duplicate_prefix = false,
    persist_buffer_sort = true,
    separator_style = 'thin',
    diagnostics = 'nvim_lsp',
    offsets = { { filetype = 'neo-tree', text = 'File Explorer', text_align = 'center' } },
    sort_by = 'insert_after_current',
  },
}

-- Safe mapper helper to avoid noisy errors if keymap fails
local function safe_map(mode, lhs, rhs, opts)
  pcall(vim.keymap.set, mode, lhs, rhs, opts)
end

-- Setup function: call from your main config. Accepts an optional table to
-- override the default options (same shape as bufferline.setup).
function M.setup(user_opts)
  user_opts = user_opts or {}

  -- Require plugin lazily so missing plugin doesn't break Neovim startup
  local ok, bufferline = pcall(require, 'bufferline')
  if not ok or not bufferline then
    -- Plugin not installed; nothing to do.
    return
  end

  local cfg = vim.tbl_deep_extend('force', default_config, user_opts)
  bufferline.setup(cfg)

  -- Keymaps for buffer navigation (non-invasive, leader-based)
  local opts = { noremap = true, silent = true }
  -- Cycle buffers
  safe_map('n', '<leader>bn', '<cmd>BufferLineCycleNext<CR>', opts)
  safe_map('n', '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', opts)
  -- Pick buffer to go to / pick buffer to close
  safe_map('n', '<leader>bb', '<cmd>BufferLinePick<CR>', opts)
  safe_map('n', '<leader>bd', '<cmd>BufferLinePickClose<CR>', opts)
  -- Sort by file extension
  safe_map('n', '<leader>be', '<cmd>BufferLineSortByExtension<CR>', opts)
end

return M
