return {
  {
    'epwalsh/obsidian.nvim',
    ft = 'md',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = function()
      local obsidian = require('obsidian')
      local which_key = require('which-key')

      which_key.register({
        ['<leader>o'] = { name = '[O]bsidian', _ = 'which_key_ignore' },
      })

      return {
        { '<leader>oo', '<cmd>ObsidianQuickSwitch<cr>', desc = '[O]pen file' },
        { '<leader>on', '<cmd>ObsidianNew<cr>', desc = '[N]ew Note' },
        { '<leader>og', '<cmd>ObsidianSearch<cr>', desc = '[G]rep Vault' },
        {
          '<leader>of',
          function()
            return obsidian.util.gf_passthrough()
          end,
          desc = '[F]ollow link',
        },
        {
          '<leader>oc',
          function()
            return require('obsidian').util.toggle_checkbox()
          end,
          desc = 'Toggle [C]heckbox',
        },
      }
    end,
    opts = {
      workspaces = {
        {
          name = 'work',
          path = '~/vaults/work',
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
    },
  },
}
