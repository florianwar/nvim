return {
  { 'echasnovski/mini.ai', opts = {} },
  { 'echasnovski/mini.trailspace', opts = {} },
  { 'echasnovski/mini.comment', opts = {} },
  {
    'echasnovski/mini.surround',
    opts = {
      mappings = {
        add = 'gza', -- Add surrounding in Normal and Visual modes
        delete = 'gzd', -- Delete surrounding
        find = 'gzf', -- Find surrounding (to the right)
        find_left = 'gzF', -- Find surrounding (to the left)
        highlight = 'gzh', -- Highlight surrounding
        replace = 'gzr', -- Replace surrounding
        update_n_lines = '', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    },
  },
  {
    'echasnovski/mini.starter',
    event = 'VimEnter',
    opts = function()
      local starter = require('mini.starter')
      local ascii = require('plugins.dev.ascii')

      local width = 70
      local header = {
        ascii.center(ascii.art.shark(), width),
      }
      local footer = {
        ascii.center(ascii.art.fish(), width),
        ascii.center('I use vim btw\n', width),
      }

      local palette = require('catppuccin.palettes').get_palette()
      vim.api.nvim_set_hl(0, 'MiniStarterHeader', { fg = palette.sky, bold = true })
      vim.api.nvim_set_hl(0, 'MiniStarterFooter', { fg = palette.mauve, bold = true })

      local menu_padding = string.rep(' ', 21)
      local section = menu_padding .. 'Commands:'
      return {
        evaluate_single = true,
        header = table.concat(header, '\n'),
        items = {
          { name = 'Resume last session', action = 'lua require("persistence").load()', section = section },
          { name = 'Find file', action = 'Telescope find_files', section = section },
          { name = 'Grep text', action = 'Telescope live_grep', section = section },
          { name = 'New File', action = 'ene | startinsert', section = section },
          { name = 'Lazy', action = 'Lazy', section = section },
          { name = 'Quit', action = 'qa', section = section },
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(menu_padding .. '\u{f18ba}  ', false),
          starter.gen_hook.aligning('center', 'center'),
        },
        footer = table.concat(footer, '\n'),
      }
    end,
  },
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    keys = {
      {
        '<c-d>',
        '<Cmd>lua vim.cmd("normal! <c-d>"); MiniAnimate.execute_after("scroll", "normal! zz")<CR>', -- For some reason using a function here doesn't work
        desc = 'Scroll Down',
      },
      {
        '<c-u>',
        '<Cmd>lua vim.cmd("normal! <c-u>"); MiniAnimate.execute_after("scroll", "normal! zz")<CR>',
        desc = 'Scroll Up',
      },
      {
        'n',
        '<Cmd>lua vim.cmd("normal! n"); MiniAnimate.execute_after("scroll", "normal! zvzz")<CR>',
        desc = 'Jump to Next',
      },
      {
        'N',
        '<Cmd>lua vim.cmd("normal! N"); MiniAnimate.execute_after("scroll", "normal! zvzz")<CR>',
        desc = 'Jump to Previous',
      },
    },
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ 'Up', 'Down' }) do
        local key = '<ScrollWheel' .. scroll .. '>'
        vim.keymap.set({ '', 'i' }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require('mini.animate')
      return {
        open = {
          enable = false,
        },
        close = {
          enable = false,
        },
        cursor = {
          timing = animate.gen_timing.linear({ duration = 30, unit = 'total' }),
        },
        resize = {
          timing = animate.gen_timing.linear({ duration = 30, unit = 'total' }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 30, unit = 'total' }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },
}
