return {
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
    config = function()
      vim.go.winwidth = 10
      vim.go.winminwidth = 10
      vim.go.equalalways = false
      require('windows').setup({
        animation = {
          enable = false,
          duration = 100,
          fps = 60,
        },
      })
    end,
  },
}
