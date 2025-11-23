return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute({ toggle = true, reveal = true })
      end,
      desc = 'Open Neotree',
    },
  },
  opts = {
    event_handlers = {
      {
        event = 'file_opened',
        handler = function(_)
          require('neo-tree.command').execute({ action = 'close' })
        end,
      },
    },
    window = {
      width = 60,
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
    },
  },
}
