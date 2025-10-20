-- LSP and Mason setup
-- added-by-agent: zig-setup 20251020
local status_ok, mason = pcall(require, 'mason')
if not status_ok then
  vim.notify('Mason is not available', vim.log.levels.WARN)
  return
end

local status_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok then
  vim.notify('Mason-lspconfig is not available', vim.log.levels.WARN)
  return
end

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  vim.notify('cmp_nvim_lsp is not available', vim.log.levels.WARN)
  return
end

-- LSP capabilities with nvim-cmp
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  cmp_nvim_lsp.default_capabilities()
)

-- Common on_attach function for LSP
local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Buffer local mappings
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

  -- Format on save if server supports it
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end
    })
  end
end

-- Initialize Mason
mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
    'gopls',
    'clangd',
    'zls',
    'tsserver',
  },
  automatic_installation = true,
})

-- Configure specific language servers
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  },
  rust_analyzer = {},
  gopls = {},
  clangd = {},
  zls = {
    settings = {
      enable_build_on_save = true,
      semantic_tokens = "full",
      zig_lib_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/zls/bin/"),
      zig_exe_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/zls/bin/zls"),
    }
  },
  tsserver = {},
}

-- Setup each language server
for server_name, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities = capabilities
  vim.lsp.start(vim.tbl_extend("force", {
    name = server_name,
    cmd = vim.lsp.get_config(server_name).cmd,
  }, config))
end

-- Initialize cmp
local cmp = require('cmp')
local cmp_format = lsp_zero.cmp_format()

cmp.setup({
  formatting = cmp_format,
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
    {name = 'buffer'},
    {name = 'path'},
  },
})
