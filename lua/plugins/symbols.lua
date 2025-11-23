return {
  {
    'oskarrrrrrr/symbols.nvim',

    keys = {
      { ',s', '<cmd>SymbolsToggle<CR>', desc = 'Toggle Symbols' },
      { '<leader>ts', '<cmd>SymbolsToggle<CR>', desc = 'Toggle Symbols' },
    },
    config = function()
      local r = require('symbols.recipes')
      require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
        sidebar = {
          open_direction = 'try-right',
          auto_resize = {
            min_width = 30,
            max_width = 60,
          },
          show_inline_details = true,
          close_on_goto = true,
          auto_peek = false,
        },
      })
    end,
  },
}
