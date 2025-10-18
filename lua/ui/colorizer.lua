-- Modern color picker and preview integration (moved from configs.ui.colorizer)
local M = {}
local _setup_done = false

function M.setup()
  if _setup_done then return end
  _setup_done = true

  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    vim.notify("nvim-colorizer not available", vim.log.levels.WARN)
    return
  end

  colorizer.setup({
    filetypes = {
      "css",
      "scss",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "lua",
      "vim",
      "conf",
      "config",
    },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = true,
      AARRGGBB = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = "background",
      tailwind = "both",
      sass = { enable = true, parsers = { "css" } },
      virtualtext = "■",
      always_update = false,
    },
    buftypes = {},
  })

  -- Setup colorizer keymaps
  vim.keymap.set("n", "<leader>ct", "<cmd>ColorizerToggle<cr>", { desc = "Colorizer toggle" })
  vim.keymap.set("n", "<leader>cr", "<cmd>ColorizerReloadAllBuffers<cr>", { desc = "Colorizer reload" })
end

return M
