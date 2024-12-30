return {
  {
    'MunsMan/kitty-navigator.nvim',
    keys = {
      {
        '<C-w>j',
        function()
          require('kitty-navigator').navigateLeft()
        end,
        desc = 'Move left a Split',
        mode = { 'n' },
      },
      {
        '<C-w>j',
        function()
          require('kitty-navigator').navigateDown()
        end,
        desc = 'Move down a Split',
        mode = { 'n' },
      },
      {
        '<C-w>k',
        function()
          require('kitty-navigator').navigateUp()
        end,
        desc = 'Move up a Split',
        mode = { 'n' },
      },
      {
        '<C-w>l',
        function()
          require('kitty-navigator').navigateRight()
        end,
        desc = 'Move right a Split',
        mode = { 'n' },
      },
    },
  },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    opts = {},
  },
}
