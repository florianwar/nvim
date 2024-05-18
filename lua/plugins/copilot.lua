return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<M-l>',
          accept_word = false,
          accept_line = false,
          next = '<M-j>',
          prev = '<M-k>',
          dismiss = '<M-q>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
      },
    },
  },
}
