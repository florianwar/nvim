local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp = vim.opt.rtp ^ lazypath

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy').setup('plugins', {
  dev = {
    path = '~/florian/projects/personal',
  },
  checker = {
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = 'rounded',
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

require('autocommands')
require('globals')
require('keymaps')
require('options')
