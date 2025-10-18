-- Statusline (lualine) configuration (moved from configs.ui.statusline)
local M = {}
local _setup_done = false

function M.setup()
  if _setup_done then return end
  _setup_done = true

  local ok, lualine = pcall(require, "lualine")
  if not ok then
    vim.notify("lualine not available", vim.log.levels.WARN)
    return {}
  end

  lualine.setup({
    options = { theme = "auto", component_separators = "", section_separators = "", globalstatus = true },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        "filename",
        {
          function()
            local clients = vim.lsp.get_clients()
            if #clients > 0 then
              return "LSP " .. #clients
            end
            return ""
          end,
          cond = function()
            return #vim.lsp.get_clients() > 0
          end,
          color = { fg = "#ffaa00" },
        },
      },
      lualine_x = {
        function()
          local recording = vim.fn.reg_recording()
          if recording ~= "" then
            return "RECORDING @" .. recording
          end
          return ""
        end,
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = {
        function()
          local cmd = vim.fn.getcmdline()
          if cmd and cmd ~= "" then
            return " :" .. cmd
          end
          return ""
        end,
        "progress",
      },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "neo-tree", "trouble" },
  })
end

return M
