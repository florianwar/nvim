vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('my-highlight-on-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if the window gets resized
vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('ResizeSplits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CloseWithQ', { clear = true }),
  pattern = {
    'checkhealth',
    'help',
    'man',
    'qf',
    'query',
    'grug-far',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf })
  end,
})

-- Dont add comments on newline
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    vim.cmd('set formatoptions-=cro')
    vim.cmd('setlocal formatoptions-=cro')
  end,
})

-- No diagnostics in node_modules
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = vim.api.nvim_create_augroup('DisableEslintOnNodeModules', { clear = true }),
  pattern = { '**/node_modules/**', 'node_modules', '/node_modules/*' },
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Create a dir when saving a file if it doesnt exist
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(args)
    if args.match:match('^%w%w+://') then
      return
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Let kitty know when we are in vim
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
  group = vim.api.nvim_create_augroup('KittySetVarVimEnter', { clear = true }),
  callback = function()
    io.stdout:write('\x1b]1337;SetUserVar=in_editor=MQo\007')
  end,
})
vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
  group = vim.api.nvim_create_augroup('KittyUnsetVarVimLeave', { clear = true }),
  callback = function()
    io.stdout:write('\x1b]1337;SetUserVar=in_editor\007')
  end,
})
