-- added-by-agent: zig-setup 20251020
-- mason: none
-- manual: ensure zig is installed and in PATH

local M = {}

function M.setup()
  -- Create user commands for Zig operations
  vim.api.nvim_create_user_command('ZigBuild', function()
    require('toggleterm.terminal').Terminal:new({
      cmd = 'zig build',
      dir = vim.fn.getcwd(),
      close_on_exit = false,
      hidden = false,
    }):toggle()
  end, {})

  vim.api.nvim_create_user_command('ZigRun', function()
    local file = vim.fn.expand('%:p')
    if vim.bo.filetype ~= 'zig' then
      vim.notify('Not a Zig file', vim.log.levels.ERROR)
      return
    end
    require('toggleterm.terminal').Terminal:new({
      cmd = string.format('zig run %s', file),
      dir = vim.fn.getcwd(),
      close_on_exit = false,
      hidden = false,
    }):toggle()
  end, {})

  vim.api.nvim_create_user_command('ZigTest', function()
    require('toggleterm.terminal').Terminal:new({
      cmd = 'zig test',
      dir = vim.fn.getcwd(),
      close_on_exit = false,
      hidden = false,
    }):toggle()
  end, {})

  vim.api.nvim_create_user_command('ZigFmt', function()
    if vim.bo.filetype ~= 'zig' then
      vim.notify('Not a Zig file', vim.log.levels.ERROR)
      return
    end
    -- Try LSP formatting first
    vim.lsp.buf.format({
      timeout_ms = 2000,
      filter = function(client)
        return client.name == "zls"
      end
    })
  end, {})

  -- Set up format on save for Zig files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "zig",
    callback = function(args)
      vim.bo[args.buf].formatprg = "zig fmt --stdin"
    end
  })
end

return M
