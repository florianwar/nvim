vim.g.autoformat = true
vim.cmd('colorscheme catppuccin')

local opt = vim.opt

opt.autowrite = true
opt.confirm = true
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.laststatus = 3
opt.signcolumn = 'yes:1'

opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.cursorline = true

opt.ignorecase = true
opt.smartcase = true
opt.wrap = false
opt.breakindent = true
opt.inccommand = 'split'
opt.incsearch = true
opt.hlsearch = true

opt.scrolloff = 10
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.splitright = true
opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.conceallevel = 1

opt.undofile = true
opt.autowrite = true
opt.swapfile = false
opt.backup = false

opt.updatetime = 250
opt.timeoutlen = 300

opt.termguicolors = true
opt.pumblend = 0
opt.pumheight = 12
