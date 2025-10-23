-- Lua language support
local M = {}

function M.setup()
  -- Lua-specific configurations
  vim.api.nvim_create_augroup("LuaConfig", { clear = true })
  
  -- Set up auto commands for Lua files
  vim.api.nvim_create_autocmd("FileType", {
    group = "LuaConfig",
    pattern = "lua",
    callback = function()
      -- Set specific options for Lua files
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = false
      vim.opt_local.textwidth = 120
      vim.opt_local.colorcolumn = "120"
    end,
  })
  
  -- Keymaps for Lua development
  vim.api.nvim_create_autocmd("FileType", {
    group = "LuaConfig",
    pattern = "lua",
    callback = function()
      local opts = { noremap = true, silent = true, buffer = 0 }
      
      -- Run current file
      vim.keymap.set("n", "<leader>lur", "<cmd>luafile %<CR>", opts)
      
      -- Debug current file
      vim.keymap.set("n", "<leader>lud", function()
        require("dap").continue()
      end, opts)
      
      -- Reload module
      vim.keymap.set("n", "<leader>lub", function()
        require("profile.core.functions").reload_lua_module()
      end, opts)
      
      -- Check file with luacheck
      vim.keymap.set("n", "<leader>luc", function()
        require("lint").try_lint("luacheck")
      end, opts)
    end,
  })
end

return M