-- added-by-agent: ccpp-setup 20251020
-- mason: none
-- manual: Requires Qt installation with qmlls in PATH or QT_QMLLS_BIN set

local M = {}

function M.setup()
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then
    vim.notify("lspconfig not available", vim.log.levels.WARN)
    return
  end

  local utils = require("profile.core.utils")

  -- Get qmlls path from env or default to PATH
  local qmlls_cmd = vim.env.QT_QMLLS_BIN or "qmlls"

  -- Common on_attach function
  local on_attach = function(client, bufnr)
    -- Buffer local mappings
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)

    -- Format on save if supported
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      })
    end
  end

  lspconfig.qmlls.setup({
    cmd = { qmlls_cmd },
    filetypes = { "qml", "qmlproject" },
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    settings = {
      enableBuildOnSave = true,
      importPaths = {
        -- Users should customize these paths based on their Qt installation
        -- Example: "/usr/lib/qt6/qml"
      }
    }
  })
end

return M
