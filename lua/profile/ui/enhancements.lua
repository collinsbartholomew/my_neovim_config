-- Additional UI enhancements
local M = {}

function M.setup()
  -- Setup bufferline
  pcall(function()
    require('bufferline').setup({
      options = {
        mode = "tabs",
        separator_style = "thin",
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true
          }
        }
      }
    })
    
    -- Keymaps for buffer navigation
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
  end)
  
  -- Setup dropbar (breadcrumbs)
  pcall(function()
    require('dropbar').setup({
      general = {
        enable = true,
      },
      icons = {
        enable = true,
      },
      bar = {
        enable = true,
        attach_events = {
          'BufWinEnter',
          'BufWritePost',
          'BufModifiedSet',
          'LspAttach',
        },
      },
    })
  end)
  
  -- Setup navic for winbar context
  pcall(function()
    require('nvim-navic').setup({
      highlight = true,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    })
  end)
  
  -- Setup alpha (startup screen)
  pcall(function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    
    -- Customize header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }
    
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
      dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("p", "  Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
      dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
      dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }
    
    alpha.setup(dashboard.opts)
  end)
end

return M