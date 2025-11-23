return {
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      { '<leader>ff', '<cmd>GrugFar<cr>', desc = '[F]ind and Replace in Workspace' },
    },
    opts = {
      windowCreationCommand = 'vsplit',
    },
  },
}
