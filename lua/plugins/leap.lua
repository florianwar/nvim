return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'ggandor/flit.nvim',
    keys = function()
      local ret = {}
      for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
        ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = 'nx' },
  },
  {
    'ggandor/leap.nvim',
    keys = {
      { 'ss', mode = { 'n', 'x', 'o' }, desc = 'Leap Forward to' },
      { 'SS', mode = { 'n', 'x', 'o' }, desc = 'Leap Backward to' },
      { 'sg', mode = { 'n', 'x', 'o' }, desc = 'Leap from Windows' },
    },
    config = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(false)
      vim.keymap.set({ 'n', 'x', 'o' }, 'ss', '<Plug>(leap-forward)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'SS', '<Plug>(leap-backward)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'sg', '<Plug>(leap-from-window)')

      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
  },
  -- makes some plugins dot-repeatable like leap
  { 'tpope/vim-repeat', event = 'VeryLazy' },
}
