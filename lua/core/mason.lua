require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "tsserver",
    "eslint",
    "html",
    "cssls",
    "tailwindcss",
    "jsonls",
  },
})

-- Only setup mason-nvim-dap if the module is available
local mason_nvim_dap_status, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if mason_nvim_dap_status then
  mason_nvim_dap.setup({
    ensure_installed = {
      "js-debug-adapter",
    },
  })
end