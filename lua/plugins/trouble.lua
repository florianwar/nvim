return {
  {
    'folke/trouble.nvim',
    keys = {
      {
        '<leader>tx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Toggle Diagnosti[X]',
      },
      {
        '<leader>tl',
        '<cmd>Trouble loclist toggle<cr>',
        desc = '[L]ocations',
      },
      {
        '<leader>tq',
        '<cmd>Trouble qflist toggle<cr>',
        desc = '[Q]uickfix',
      },
    },
    opts = {},
  },
}
