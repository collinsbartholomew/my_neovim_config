-- Autocmds
local autocmd = vim.api.nvim_create_autocmd

-- Auto format on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function() vim.lsp.buf.format({ async = false }) end,
})

-- Lint on write
autocmd({ "BufWritePost" }, {
  callback = function() require("lint").try_lint() end,
})

-- Highlight yank
autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 }) end,
})

-- Auto close tree if last window
autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, false) end
    end
  end
})

-- Restore session
autocmd("VimEnter", {
  callback = function() require("persistence").load() end,
  nested = true,
})

-- Auto pairs and tags
autocmd("FileType", {
  pattern = { "html", "javascript", "typescript", "jsx", "tsx" },
  callback = function()
    require("nvim-autopairs").setup()
    require("nvim-ts-autotag").setup()
  end,
})

-- Fold with UFO
autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    require("ufo").setup()
  end,
})