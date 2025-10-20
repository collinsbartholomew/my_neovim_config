-- added-by-agent: rust-setup 20251020
-- Mason: rust-analyzer
local M = {}
function M.setup()
  local rt = require('rust-tools')
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  rt.setup({
    server = {
      on_attach = function(client, bufnr)
        require('profile.languages.rust.mappings').lsp(bufnr)
        pcall(function() vim.lsp.inlay_hint(bufnr, true) end)
      end,
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
          cargo = { loadOutDirsFromCheck = true },
          procMacro = { enable = true },
          checkOnSave = { command = 'clippy' },
          inlayHints = { parameterHints = { enable = true }, typeHints = { enable = true } },
          assist = { importGranularity = 'module', importPrefix = 'by_self' },
        },
      },
    },
    tools = {
      inlay_hints = { auto = true, show_parameter_hints = true, parameter_hints_prefix = '<- ', other_hints_prefix = '=> ' },
      hover_actions = { border = 'rounded' },
      runnables = { use_telescope = true },
    },
    dap = { adapter = require('profile.languages.rust.debug').get_codelldb_adapter() },
  })
end
return M

