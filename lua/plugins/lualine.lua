local current_ascii_art = ''
local timer = vim.uv.new_timer()
timer:start(0, 20 * 1000, function()
  current_ascii_art = require('plugins.dev.ascii').singleLine()
end)

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = 'catppuccin',
          globalstatus = true,
          disabled_filetypes = { statusline = {} },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },

          lualine_c = {
            { '%=', separator = '' },
            -- Ascii art
            {
              function()
                return current_ascii_art
              end,
              color = function()
                return { fg = require('catppuccin.palettes').get_palette().rosewater }
              end,
            },
          },
          lualine_x = {
            -- Show macro recording status
            {
              function()
                local recording_register = vim.fn.reg_recording()
                if recording_register == '' then
                  return ''
                else
                  return 'Recording @' .. recording_register
                end
              end,
              color = 'WarningMsg',
            },
          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } },
            {
              -- Display current selection dimensions in visual mode
              function()
                local starts = vim.fn.line('v')
                local ends = vim.fn.line('.')
                local count = starts <= ends and ends - starts + 1 or starts - ends + 1
                local wc = vim.fn.wordcount()
                return count .. ':' .. wc['visual_chars']
              end,
              cond = function()
                return vim.fn.mode():find('[Vv]') ~= nil
              end,
            },
          },
          lualine_z = {
            function()
              return ' ' .. os.date('%R')
            end,
          },
        },
        winbar = {},
        tabline = {},
        extensions = { 'neo-tree', 'lazy' },
      }
    end,
  },
}
