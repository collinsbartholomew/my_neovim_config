-- added-by-agent: ui-enhancement 20251020
-- Configuration for indentation and focus features

local M = {}

function M.setup()
  -- Set up indent-blankline with modern indent guides
  require("ibl").setup({
    indent = {
      char = "│",
      highlight = "IblIndent",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      highlight = "IblScope",
    },
    exclude = {
      filetypes = {
        "help",
        "terminal",
        "dashboard",
        "mason",
        "notify",
      },
    },
  })

  -- Configure zen-mode and twilight for focus mode
  require("zen-mode").setup({
    window = {
      backdrop = 1,
      width = 0.8,
      height = 0.9,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = true,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
    plugins = {
      twilight = { enabled = true },
      gitsigns = { enabled = false },
      tmux = { enabled = false },
    },
    on_open = function()
      vim.g.transparency_backup = vim.g.transparency
      vim.g.transparency = 0
    end,
    on_close = function()
      vim.g.transparency = vim.g.transparency_backup
    end,
  })

  require("twilight").setup({
    dimming = {
      alpha = 0.25,
      color = { "Normal", "#ffffff" },
      inactive = true,
    },
    context = 10,
    treesitter = true,
    expand = {
      "function",
      "method",
      "table",
      "if_statement",
    },
  })

  -- Set up focus.nvim for automatic window management
  require("focus").setup({
    enable = true,
    autoresize = {
      enable = true,
      width = 80,  -- Changed from 0.8 to 80 (integer)
      height = 80, -- Changed from 0.8 to 80 (integer)
    },
    ui = {
      number = false,
      relativenumber = false,
      hybridnumber = false,
      absolutenumber_unfocused = false,
    },
  })
end

return M