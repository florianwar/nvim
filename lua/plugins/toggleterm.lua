return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-t>', '<esc>:ToggleTerm<cr>', mode = { 'n' }, desc = '[T]oggle [T]erminal' },
      { '<C-t>', '<C-\\><C-n>:ToggleTerm<cr>', mode = { 't' }, desc = '[T]oggle [T]erminal' },
    },
    opts = {
      open_mapping = [[<C-t>]],
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = false,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      float_opts = {
        border = 'rounded',
      },
    },
  },
}
