return {
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {

    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim',
    },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          window = { border = 'rounded', max_width = 100, scrollbar = true },
        },
        list = {
          selection = {
            auto_insert = false,
            preselect = function(ctx)
              return true
            end,
          },
        },
        menu = {
          border = 'rounded',
          cmdline_position = function()
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
              return { pos[1] - 1, pos[2] - 1 } -- correcty align label
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
          draw = {
            gap = 2,
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
            },
            components = {
              label = {
                width = { fill = true, max = 120, min = 30 },
              },
              label_description = {
                width = {
                  max = 40,
                },
              },
            },
          },
        },
      },

      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<tab>'] = {
          'snippet_forward',
        },
        ['<S-tab>'] = {
          'snippet_backward',
        },
        ['<C-j>'] = {
          'select_next',
          'snippet_forward',
          'fallback',
        },
        ['<C-k>'] = {
          'select_prev',
          'snippet_backward',
          'fallback',
        },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      },

      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },

      sources = {
        default = {
          'lazydev',
          'lsp',
          'path',
          'snippets',
          'buffer',
          'avante_commands',
          'avante_mentions',
          'avante_files',
        },
        cmdline = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          if type == ':' or type == '@' then
            return { 'cmdline' }
          end
          if type == '=' then
            return { 'lsp', 'buffer' }
          end

          return {}
        end,

        providers = {
          path = {
            min_keyword_length = 2,
          },
          snippets = {
            min_keyword_length = 2,
          },
          buffer = {
            min_keyword_length = function(ctx)
              if ctx.mode == 'cmdline' then
                return 0
              else
                return 5
              end
            end,
            max_items = 5,
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          avante_commands = {
            name = 'avante_commands',
            module = 'blink.compat.source',
            score_offset = 90, -- show at a higher priority than lsp
            opts = {},
          },
          avante_files = {
            name = 'avante_commands',
            module = 'blink.compat.source',
            score_offset = 100, -- show at a higher priority than lsp
            opts = {},
          },
          avante_mentions = {
            name = 'avante_mentions',
            module = 'blink.compat.source',
            score_offset = 1000, -- show at a higher priority than lsp
            opts = {},
          },
        },
      },
    },
  },
}
