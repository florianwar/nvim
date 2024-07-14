return {
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = true,
    opts = {
      window = {
        winblend = 10,
      },
    },
    keys = {
      { '<leader>tu', "<cmd>lua require('undotree').toggle()<cr>", desc = '[T]oggle [U]ndotree', noremap = true },
    },
  },
}
