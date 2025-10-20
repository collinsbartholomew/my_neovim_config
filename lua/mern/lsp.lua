local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- TypeScript/JavaScript LSP
  lspconfig.tsserver.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    end,
  })

  -- HTML LSP
  lspconfig.html.setup({
    capabilities = capabilities,
  })

  -- CSS LSP
  lspconfig.cssls.setup({
    capabilities = capabilities,
  })

  -- JSON LSP
  lspconfig.jsonls.setup({
    capabilities = capabilities,
  })

  -- Tailwind CSS
  lspconfig.tailwindcss.setup({
    capabilities = capabilities,
  })
end

return M