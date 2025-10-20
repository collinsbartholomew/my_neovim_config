-- Neovim options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- Additional UI options
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.fillchars = {
  vert = '│',
  fold = '·',
  eob = ' ',  -- suppress ~ at EndOfBuffer
  diff = '⣿', -- alternatives = ⣿ ░ ─ ╱
  msgsep = '‾',
  foldopen = '▾',
  foldsep = '│',
  foldclose = '▸',
}
vim.opt.pumblend = 0  -- Make popup menus fully transparent
vim.opt.winblend = 0  -- Make floating windows fully transparent
vim.opt.laststatus = 3  -- Global statusline

-- Enable mouse support
vim.opt.mouse = 'a'

-- Better search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Indent settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true