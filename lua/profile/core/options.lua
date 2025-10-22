--Core editor options
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw for better performance
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Optionslocal opt = vim.opt

-- Basic
opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false -- Use actual tabs, not spaces
opt.smartindent = true

-- Search
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.colorcolumn = "80"
opt.signcolumn = "yes"
opt.wrap = false

-- Folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Backspace
opt.backspace= "indent,eol,start"

-- Split windowsopt.splitright = true
opt.splitbelow = true

-- File handling
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true

-- Assembly-specific options
-- Enable syntax highlighting for assembly files
vim.cmd [[autocmd BufNewFile,BufRead *.asm,*.s,*.S set filetype=asm]]
-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- UI settings
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 300
opt.timeoutlen = 300
opt.showtabline = 0  -- Disable tabline completely
opt.pumheight = 10
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.shortmess:append("c")

-- Better display for assembly files
vim.cmd [[autocmd FileType asm setlocal tabstop=8 shiftwidth=8 expandtab]]
vim.cmd [[autocmd FileType asm setlocal colorcolumn=80,100]]

-- Mojo-specific options
-- Enable syntax highlighting for Mojo files
vim.cmd [[autocmd BufNewFile,BufRead *.mojo,*.🔥 set filetype=mojo]]

-- Better display for Mojo files
vim.cmd [[autocmd FileType mojo setlocal tabstop=4 shiftwidth=4 expandtab]]
vim.cmd [[autocmd FileType mojo setlocal colorcolumn=100]]

-- Lua-specific options
vim.cmd [[autocmd FileType lua setlocal tabstop=2 shiftwidth=2 expandtab]]
vim.cmd [[autocmd FileType lua setlocal colorcolumn=120]]

return {}