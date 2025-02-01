return {
  {
    'echasnovski/mini.ai',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
    },
    opts = {
      custom_textobjects = {
        --- make tag textobject more lenient
        t = { '<([%p%w]-)%f[^<%p%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        --- Subword match
        e = {
          -- Lua 5.1 character classes and the undocumented frontier pattern:
          -- https://www.lua.org/manual/5.1/manual.html#5.4.1
          -- http://lua-users.org/wiki/FrontierPattern
          -- note: when I say "letter" I technically mean "letter or digit"
          {
            -- Matches a single uppercase letter followed by 1+ lowercase letters.
            -- This covers:
            -- - PascalCaseWords (or the latter part of camelCaseWords)
            '%u[%l%d]+%f[^%l%d]', -- An uppercase letter, 1+ lowercase letters, to end of lowercase letters

            -- Matches lowercase letters up until not lowercase letter.
            -- This covers:
            -- - start of camelCaseWords (just the `camel`)
            -- - snake_case_words in lowercase
            -- - regular lowercase words
            '%f[^%s%p][%l%d]+%f[^%l%d]', -- after whitespace/punctuation, 1+ lowercase letters, to end of lowercase letters
            '^[%l%d]+%f[^%l%d]', -- after beginning of line, 1+ lowercase letters, to end of lowercase letters

            -- Matches uppercase or lowercase letters up until not letters.
            -- This covers:
            -- - SNAKE_CASE_WORDS in uppercase
            -- - Snake_Case_Words in titlecase
            -- - regular UPPERCASE words
            -- (it must be both uppercase and lowercase otherwise it will
            -- match just the first letter of PascalCaseWords)
            '%f[^%s%p][%a%d]+%f[^%a%d]', -- after whitespace/punctuation, 1+ letters, to end of letters
            '^[%a%d]+%f[^%a%d]', -- after beginning of line, 1+ letters, to end of letters
          },
          '^().*()$',
        },
      },
    },
  },
  { 'echasnovski/mini.bracketed', opts = { treesitter = { suffix = 'T' } } },
  { 'echasnovski/mini.trailspace', opts = {} },
  { 'echasnovski/mini.comment', opts = {} },
  { 'echasnovski/mini.icons', opts = {} },
  { 'echasnovski/mini.pairs', opts = {} },
  { 'echasnovski/mini.cursorword', opts = {} },
  {
    'echasnovski/mini.surround',
    opts = {
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = '', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    },
  },
  {
    'echasnovski/mini.clue',
    opts = function()
      return {
        triggers = {
          { mode = 'n', keys = '<C-w>' },
          -- Leader trigger
          { mode = 'n', keys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>m' },
        },
        clues = {
          require('mini.clue').gen_clues.windows({
            submode_move = true,
            submode_navigate = true,
            submode_resize = true,
          }),

          --- Treewalker
          { mode = 'n', keys = '<Leader>wj', postkeys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>wk', postkeys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>wh', postkeys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>wl', postkeys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>wK', postkeys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>wJ', postkeys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>wH', postkeys = '<Leader>w' },
          { mode = 'n', keys = '<Leader>wL', postkeys = '<Leader>w' },

          --- Multicursor

          { mode = 'n', keys = '<Leader>mj', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>mk', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>ma', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>mN', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>mn', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>mh', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>ml', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>md', postkeys = '<Leader>m' },
          { mode = 'n', keys = '<Leader>mm', postkeys = '<Leader>m' },
        },
      }
    end,
  },
  {
    'echasnovski/mini.starter',
    event = 'VimEnter',
    opts = function()
      local starter = require('mini.starter')
      local ascii = require('dev.ascii')

      local width = 80
      local header = {
        ascii.center(ascii.art.shark(), width),
      }
      local footer = {
        '',
        ascii.center(ascii.art.fish(), width),
        ascii.center('I use vim btw', width),
      }

      local palette = require('catppuccin.palettes').get_palette()
      vim.api.nvim_set_hl(0, 'MiniStarterHeader', { fg = palette.sky, bold = true })
      vim.api.nvim_set_hl(0, 'MiniStarterFooter', { fg = palette.mauve, bold = true })

      local menu_padding = string.rep(' ', 15)

      local function command_items()
        local section = menu_padding .. 'Commands'
        return {
          {
            name = 'Resume last session',
            action = function()
              require('persistence').load()
            end,
            section = section,
          },
          { name = 'Find file', action = 'Telescope find_files', section = section },
          { name = 'Grep text', action = 'Telescope live_grep', section = section },
          { name = 'New File', action = 'ene | startinsert', section = section },
          { name = 'Browse', action = 'Oil', section = section },
          { name = 'Lazy', action = 'Lazy', section = section },
          { name = 'Quit', action = 'qa', section = section },
        }
      end

      local function harpoon_items()
        local harpoon_list = require('harpoon'):list()
        local items = {}
        for k, v in pairs(harpoon_list.items) do
          items[#items + 1] = {
            name = k .. ' - ' .. vim.fn.fnamemodify(v.value, ':t'),
            action = function()
              harpoon_list:select(k)
            end,
            section = menu_padding .. 'Harpoon',
          }
        end
        return items
      end

      return {
        evaluate_single = true,
        header = table.concat(header, '\n'),
        items = {
          command_items(),
          harpoon_items(),
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
          enable = false,
        },
        resize = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 20, unit = 'total' }),
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
