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

      which_key.add({
        { '<leader>o', group = '[O]bsidian' },
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
      ui = {
        enable = false, -- set to false to disable all additional syntax features
        update_debounce = 200,
        checkboxes = {
          [' '] = { char = '󰄱 ', hl_group = 'ObsidianTodo' },
          ['x'] = { char = ' ', hl_group = 'ObsidianDone' },
          ['>'] = { char = ' ', hl_group = 'ObsidianRightArrow' },
          ['~'] = { char = '󰰱 ', hl_group = 'ObsidianTilde' },
        },
        bullets = { char = '•', hl_group = 'ObsidianBullet' },
        external_link_icon = { char = ' ', hl_group = 'ObsidianExtLinkIcon' },
        reference_text = { hl_group = 'ObsidianRefText' },
        highlight_text = { hl_group = 'ObsidianHighlightText' },
        tags = { hl_group = 'ObsidianTag' },
        block_ids = { hl_group = 'ObsidianBlockID' },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = '#f78c6c' },
          ObsidianDone = { bold = true, fg = '#89ddff' },
          ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
          ObsidianTilde = { bold = true, fg = '#ff5370' },
          ObsidianBullet = { bold = true, fg = '#89ddff' },
          ObsidianRefText = { underline = true, fg = '#c792ea' },
          ObsidianExtLinkIcon = { fg = '#c792ea' },
          ObsidianTag = { italic = true, fg = '#89ddff' },
          ObsidianBlockID = { italic = true, fg = '#89ddff' },
          ObsidianHighlightText = { bg = '#75662e' },
        },
      },
      workspaces = {
        {
          name = 'work',
          path = '~/vaults/work',
        },
      },
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
    },
  },
}
