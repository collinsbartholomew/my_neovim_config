-- LSP and Mason setup
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lsp_zero = require('lsp-zero').preset({
  name = 'recommended',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    'clangd', 'clang-format', 'clang-tidy', 'codelldb',
    'rust-analyzer', 'rustfmt',
    'gopls', 'goimports', 'delve',
    'tsserver', 'eslint', 'prettier', 'tailwindcss-language-server',
    'dartls', 'jdtls', 'omnisharp', 'zls', 'asm-lsp', 'lua-language-server',
  },
})

lsp_zero.on_attach(function(client, bufnr)
  -- Formatting on save
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end)

lsp_zero.setup_servers({
  'clangd', 'rust_analyzer', 'gopls', 'tsserver', 'tailwindcss', 'eslint', 'dartls', 'jdtls', 'omnisharp', 'zls', 'asm_lsp', 'lua_ls',
})

lsp_zero.setup()

-- Modern UI for hover, signatureHelp, diagnostics
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
vim.diagnostic.config({ float = { border = 'rounded' } })
