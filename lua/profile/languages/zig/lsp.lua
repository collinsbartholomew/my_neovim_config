-- added-by-agent: zig-setup 20251020
local M = {}

function M.setup()
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then
    vim.notify("lspconfig not available", vim.log.levels.WARN)
    return
  end

  -- Common on_attach function
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
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

  -- Try to get zls path from Mason first
  local zls_path = vim.fn.exepath('zls') -- default to PATH
  local mason_registry = require("mason-registry")
  if mason_registry.is_installed("zls") then
    local package = mason_registry.get_package("zls")
    zls_path = package:get_install_path() .. "/zls"
  end

  -- Setup zls with fallback options
  vim.lsp.start({
    name = 'zls',
    cmd = { zls_path },
    root_dir = vim.fs.dirname(vim.fs.find({'build.zig', 'zls.json'}, { upward = true })[1]),
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    settings = {
      zls = {
        enable_build_on_save = true,
        semantic_tokens = "full",
      }
    },
  })
end

return M
