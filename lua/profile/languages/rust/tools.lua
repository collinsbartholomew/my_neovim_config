-- added-by-agent: rust-setup 20251020
-- Mason: rustfmt (if available)
-- Manual: rustup component add rustfmt clippy
local M = {}
function M.setup()
  require('conform').setup({
    formatters_by_ft = { rust = { 'rustfmt' } },
    format_on_save = function(bufnr)
      return vim.bo[bufnr].filetype == 'rust'
    end,
  })
  vim.api.nvim_create_user_command('RustAudit', function()
    vim.cmd('split | terminal cargo audit')
  end, {})
  vim.api.nvim_create_user_command('RustClippy', function()
    vim.cmd('split | terminal cargo clippy --workspace --all-targets -- -D warnings')
  end, {})
  require('crates').setup({ src = { cmp = { enabled = true } } })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'toml',
    callback = function()
      require('crates').show()
    end,
  })
end
return M

