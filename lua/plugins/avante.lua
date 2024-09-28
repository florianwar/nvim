return {
  {
    'yetone/avante.nvim',
    keys = { { '<leader>aa', '<cmd>Avante<cr>', desc = '[A]vante' } },
    build = 'make',
    opts = function()
      require('which-key').add({
        { '<leader>a', name = '[A]vante' },
      })

      return {
        provider = 'claude',
        mappings = {
          ask = '<leader>aa',
          edit = '<leader>ae',
          refresh = '<leader>ar',
          --- @class AvanteConflictMappings
          diff = {
            ours = 'yo',
            theirs = 'yt',
            none = 'yx',
            both = 'yb',
            next = ']x',
            prev = '[x',
          },
          jump = {
            next = ']]',
            prev = '[[',
          },
          submit = {
            normal = '<CR>',
            insert = '<C-s>',
          },
          toggle = {
            debug = '<leader>ad',
            hint = '<leader>ah',
          },
        },
      }
    end,

    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          ft = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
