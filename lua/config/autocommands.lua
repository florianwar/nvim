vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('my-highlight-on-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
