return {
  {
    'chrisgrieser/nvim-rip-substitute',
    cmd = 'RipSubstitute',
    keys = {
      {
        '<leader>fr',
        function()
          require('rip-substitute').sub()
        end,
        mode = { 'n', 'x' },
        desc = ' [R]eplace in file',
      },
    },
    opts = {
      popupWin = {
        hideKeymapHints = true,
      },
      keymaps = {
        -- normal & visual mode
        confirm = '<C-y>',
        abort = '<esc>',
        prevSubstitutionInHistory = '<up>',
        nextSubstitutionInHistory = '<down>',
        openAtRegex101 = 'R',
        insertModeConfirm = '<C-y>', -- (except this one, obviously)
      },
    },
  },
}
