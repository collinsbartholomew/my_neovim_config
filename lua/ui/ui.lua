require("tokyonight").setup({
  style = "storm",
  transparent = true,
  terminal_colors = true,
})

vim.cmd([[colorscheme tokyonight-storm]])

require("lualine").setup({
  options = {
    theme = "tokyonight",
  },
})

require("bufferline").setup({})

require("gitsigns").setup()

-- Enable telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})