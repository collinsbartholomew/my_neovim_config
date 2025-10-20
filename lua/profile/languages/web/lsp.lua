-- added-by-agent: web-setup 20251020-173000
-- mason: tsserver, tailwindcss-language-server, prettier, eslint
-- manual: node.js installation required

local M = {}

function M.setup()
  local lspconfig_status, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_status then
    vim.notify("lspconfig not available for web setup", vim.log.levels.WARN)
    return
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_nvim_lsp_status then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

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
      
      -- Enable inlay hints if available
      pcall(function() 
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint(bufnr, true)
        end
      end)
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
    filetypes = { 
      "html", "css", "scss", "javascript", "javascriptreact", "typescript", 
      "typescriptreact", "vue", "svelte"
    },
    init_options = {
      userLanguages = {
        eelixir = "html-eex",
        eruby = "erb"
      }
    },
    root_dir = lspconfig.util.root_pattern(
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "package.json",
      "node_modules"
    ),
    settings = {
      tailwindCSS = {
        classAttributes = { "class", "className", "classList", "ngClass" },
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidScreen = "error",
          invalidVariant = "error",
          invalidConfigPath = "error",
          invalidTailwindDirective = "error",
          recommendedVariantOrder = "warning"
        },
        validate = true
      }
    }
  })
end

return M