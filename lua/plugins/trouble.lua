return {
  {
    'folke/trouble.nvim',
    keys = {
      {
        '<leader>fx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnosti[X]',
      },
      {
        '<leader>fX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnosti[X]',
      },
      {
        '<leader>fs',
        '<cmd>Trouble symbols toggle focus=true<cr>',
        desc = '[S]ymbols',
      },
      {
        '<leader>fl',
        '<cmd>Trouble loclist toggle<cr>',
        desc = '[L]ocations',
      },
      {
        '<leader>fq',
        '<cmd>Trouble qflist toggle<cr>',
        desc = '[Q]uickfix',
      },
    },
    opts = {},
  },
}
