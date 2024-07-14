return {
  {
    'stevearc/oil.nvim',
    opts = {
      keymaps = {
        ['<Esc>'] = { callback = 'actions.close', mode = 'n' },
        ['q'] = { callback = 'actions.close', mode = 'n' },
        ['g?'] = 'actions.show_help',
        -- lets see how this impacts renaming
        -- ['h'] = { callback = 'actions.parent', mode = 'n' },
        -- ['l'] = { callback = 'actions.select', mode = 'n' },
        ['s'] = { callback = 'actions.select_vsplit', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-p>'] = 'actions.preview',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = 'actions.tcd',
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
      use_default_keymaps = false,
    },
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
