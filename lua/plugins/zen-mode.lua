return {
  {
    'folke/zen-mode.nvim',
    dependencies = {
      {
        'joshuadanpeterson/typewriter',
        config = function()
          require('typewriter').setup({
            enable_with_zen_mode = true,
            keep_cursor_position = true,
            enable_notifications = true,
            enable_horizontal_scroll = false,
          })
        end,
        opts = {},
      },
    },
    keys = {
      { '<leader>tz', '<cmd>ZenMode<cr>', { desc = '[T]oggle [Z]en-mode' } },
    },
    opts = {
      window = {
        backdrop = 0.8,
        width = 130,
        height = 1,
        options = {
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        gitsigns = { enabled = false },
        kitty = {
          enabled = true,
          font = '+2',
        },
      },
      on_open = function()
        vim.cmd('TWEnable')
      end,
      on_close = function()
        vim.cmd('TWDisable')
      end,
    },
  },
}
