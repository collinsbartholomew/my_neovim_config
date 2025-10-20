local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")

mason.setup()
mason_lsp.setup({
  ensure_installed = { "lua_ls", "pyright", "jdtls", "tsserver", "clangd", "gopls" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

mason_lsp.setup_handlers({
  function(server)
    lspconfig[server].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        require("nvim-navic").attach(client, bufnr)
        -- Other on_attach logic
      end,
    })
  end,
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
      },
    })
  end,
  ["jdtls"] = function()
    lspconfig.jdtls.setup({
      capabilities = capabilities,
      -- Additional Java config if needed
    })
  end,
  -- Add more specific setups
})

return {} -- For config function