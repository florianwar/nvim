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
        { '<leader>a', group = '[A]I' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]atabase' },
        { '<leader>f', group = '[F]ind' },
        { '<leader>g', group = '[G]it' },
        { '<leader>n', group = '[N]eotest' },
        { '<leader>o', group = '[O]bsidian' },
        { '<leader>r', group = '[R]elated' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>x', group = 'Diagnosti[X]' },
      })
    end,
  },
}
