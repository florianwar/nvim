return {
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
      require('harpoon'):setup({})
    end,
    keys = function()
      require('which-key').register({
        ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
      })

      return {
        {
          '<leader>ha',
          function()
            require('harpoon'):list():add()
          end,
          desc = '[A]dd file',
        },
        {
          '<leader>hh',
          function()
            local harpoon = require('harpoon')
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = '[H]arpoon menu',
        },
        {
          '<leader>1',
          function()
            require('harpoon'):list():select(1)
          end,
          desc = 'Harpoon to file [1]',
        },
        {
          '<leader>2',
          function()
            require('harpoon'):list():select(2)
          end,
          desc = 'Harpoon to file [2]',
        },
        {
          '<leader>3',
          function()
            require('harpoon'):list():select(3)
          end,
          desc = 'Harpoon to file [3]',
        },
        {
          '<leader>4',
          function()
            require('harpoon'):list():select(4)
          end,
          desc = 'Harpoon to file [4]',
        },
        {
          '<leader>5',
          function()
            require('harpoon'):list():select(5)
          end,
          desc = 'Harpoon to file [5]',
        },
        {
          '<leader>6',
          function()
            require('harpoon'):list():select(6)
          end,
          desc = 'Harpoon to file [6]',
        },
      }
    end,
  },
}
