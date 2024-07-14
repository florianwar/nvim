return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      local which_key = require('which-key')
      which_key.setup()

      which_key.add({
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>f', group = '[F]find' },
        { '<leader>g', group = '[G]it' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>x', group = 'Diagnosti[X]' },
      })
    end,
  },
}
