-- Enhanced LSP setup for full-stack web development
-- Primary: vtsls (faster TypeScript LSP), biome for linting/formatting
-- Optional: denols for Deno projects, ts_ls as fallback

local M = {}

local function safe_require(mod)
  local ok, ret = pcall(require, mod)
  return ok and ret or nil
end

local lspconfig = safe_require('lspconfig')
local mason = safe_require('mason')
local mason_lspconfig = safe_require('mason-lspconfig')
local cmp_nvim_lsp = safe_require('cmp_nvim_lsp')
local conform = safe_require('conform')

local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local function on_attach(client, bufnr)
  local function buf_set(key, fn, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set('n', key, fn, opts)
  end

  buf_set('gd', vim.lsp.buf.definition, { desc = 'LSP: goto definition' })
  buf_set('K', vim.lsp.buf.hover, { desc = 'LSP: hover' })
  buf_set('<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: rename' })
  buf_set('<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: code action' })

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end

mason.setup()
mason_lspconfig.setup({
  ensure_installed = { 'vtsls', 'biome', 'denols', 'tsserver' },
})

mason_lspconfig.setup_handlers({
  function(server_name)
    if server_name == 'vtsls' then
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          tsserver = {
            maxTsServerMemory = 8192,
          },
        },
      })
    elseif server_name == 'biome' then
      lspconfig.biome.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    elseif server_name == 'denols' then
      lspconfig.denols.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
      })
    elseif server_name == 'tsserver' then
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern('package.json'),
      })
    end
  end,
})

return M
