local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  else
    return 'Recording @' .. recording_register
  end
end
local current_ascii_art = ''

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
            { 'filename', path = 4 },
            {
              'diagnostics',
              symbols = {
                error = ' ',
                warn = ' ',
                info = ' ',
                hint = ' ',
              },
            },
            { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
            function()
              if os.time() % 13 == 0 then
                current_ascii_art = require('plugins.dev.ascii').singleLine()
              end
              return current_ascii_art
            end,
          },
          lualine_x = {
            function()
              local statusline = require('arrow.statusline')
              -- statusline.is_on_arrow_file() -- return nil if current file is not on arrow.  Return the index if it is.
              -- statusline.text_for_statusline() -- return the text to be shown in the statusline (the index if is on arrow or "" if not)
              return statusline.text_for_statusline_with_icons() -- Same, but with an bow and arrow icon ;D
            end,

            show_macro_recording,
            {
              'diff',
              symbols = {
                added = ' ',
                modified = ' ',
                removed = ' ',
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return ' ' .. os.date('%R')
            end,
          },
        },
        extensions = { 'neo-tree', 'lazy' },
      }
    end,
  },
}
