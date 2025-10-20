-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "copilot" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

cmp.setup.filetype({
  rust = {
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'crates' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'luasnip' },
    }),
  },
  ['toml'] = {
    sources = cmp.config.sources({
      { name = 'crates' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'luasnip' },
    }),
  },
})