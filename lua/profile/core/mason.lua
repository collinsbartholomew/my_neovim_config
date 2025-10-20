---
-- Mason ensure_installed for Go tools
local mason_registry = require('mason-registry')
local ensure = {
  'gopls', 'delve', 'gofumpt', 'goimports', 'staticcheck',
}
for _, pkg in ipairs(ensure) do
  local p = mason_registry.get_package(pkg)
  if not p:is_installed() then p:install() end
end
---
-- Go UI/diagnostic tweaks
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
    pattern = '*.go',
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  })
end
return M

