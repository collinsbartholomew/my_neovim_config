-- Flash UI configuration (moved from configs.ui.flash)
local ok, flash = pcall(require, "flash")
if not ok then
  vim.notify("flash not available", vim.log.levels.WARN)
  return {}
end

flash.setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = { multi_window = true, forward = true, wrap = true, incremental = false },
  jump = { jumplist = true, pos = "start", history = false, register = false, nohlsearch = false, autojump = false },
  label = { uppercase = true, exclude = "", current = true, after = true, before = false, style = "overlay", reuse = "lowercase", distance = true, min_pattern_length = 0, rainbow = { enabled = false, shade = 5 } },
  highlight = { backdrop = true, matches = true, priority = 5000, groups = { match = "FlashMatch", current = "FlashCurrent", backdrop = "FlashBackdrop", label = "FlashLabel" } },
  modes = {
    search = { enabled = true, highlight = { backdrop = false }, jump = { history = true, register = true, nohlsearch = true } },
    char = { enabled = true, autohide = false, jump_labels = false, multi_line = true, label = { exclude = "hjkliardc" }, keys = { "f", "F", "t", "T", ";", "," } },
    treesitter = { labels = "abcdefghijklmnopqrstuvwxyz", jump = { pos = "range" }, search = { incremental = false }, label = { before = true, after = true, style = "inline" }, highlight = { backdrop = false, matches = false } },
  },
})

vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

return flash
