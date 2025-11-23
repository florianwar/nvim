return {
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    opts = {
      left = {
        { ft = 'undotree', title = 'Undo' },
        { ft = 'neo-tree', title = 'Neotree' },
        { ft = 'SymbolsSidebar', title = 'Symbols' },
      },
      bottom = {
        { ft = 'trouble', title = 'Trouble' },
        { ft = 'qf', title = 'QuickFix' },
      },
      options = {
        left = {
          size = 40,
        },
      },
      animate = {
        enabled = false,
      },
    },
  },
}
