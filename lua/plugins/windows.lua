return {
  {
    'JoseConseco/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
    },
    config = function()
      require('windows').setup({
        animation = {
          enable = false,
        },
        autowidth = {
          enable = true,
          winwidth = 10,
          animation = false,
        },
        autoboth = {
          enable = false,
        },
      })
    end,
  },
}
