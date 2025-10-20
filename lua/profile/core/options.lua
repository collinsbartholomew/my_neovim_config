-- Neovim options
local opt = vim.opt

-- General settings
opt.backup = false
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.hlsearch = true
opt.ignorecase = true
opt.mouse = "a"
opt.pumheight = 10
opt.showmode = false
opt.showtabline = 2
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 300
opt.writebackup = false
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.shortmess:append("c")
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'nvim-treesitter.foldexpr'()"
opt.foldenable = true
opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "", eob = " " }
opt.laststatus = 3
opt.winbar = "%=%m %f"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Performance
vim.loader.enable()