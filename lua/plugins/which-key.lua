return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      local which_key = require('which-key')
      which_key.setup({
        preset = 'modern',
      })

      which_key.add({
        { '<leader>c', group = '[C]ode' },
        { '<leader>f', group = '[F]find' },
        { '<leader>g', group = '[G]it' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>x', group = 'Diagnosti[X]' },
      })
    end,
  },
}
