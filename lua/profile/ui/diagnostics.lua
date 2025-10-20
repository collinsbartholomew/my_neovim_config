-- added-by-agent: rust-setup 20251020
-- Diagnostics UI: virtual text, float, trouble.nvim
local M = {}
function M.setup()
  vim.diagnostic.config({
    virtual_text = { prefix = '●', spacing = 2 },
    float = { border = 'rounded', source = 'always' },
    update_in_insert = false,
    severity_sort = true,
  })
  vim.o.updatetime = 300
  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  })
  require('trouble').setup({
    auto_open = false,
    auto_close = true,
    use_diagnostic_signs = true,
  })
end
return M
-- added-by-agent: rust-setup 20251020
-- Rust-specific UI: inlay hints, floating hovers, autocmds
local M = {}
function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == 'rust-analyzer' then
        pcall(function() vim.lsp.inlay_hint(args.buf, true) end)
      end
    end,
  })
  vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#888888', bg = 'NONE', italic = true })
end
return M

