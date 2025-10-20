require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    java = { "google-java-format" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    -- Add more
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

return {}