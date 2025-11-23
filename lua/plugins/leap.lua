return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    'ggandor/flit.nvim',
    dependencies = {
      {
        'ggandor/leap.nvim',
      },
    },
    keys = function()
      local ret = {}
      for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
        ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = 'nx', clever_repeat = true },
  },
}
