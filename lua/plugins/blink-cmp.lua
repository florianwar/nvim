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
    'xzbdmw/colorful-menu.nvim',
    config = function()
      -- You don't need to set these options.
      require('colorful-menu').setup({
        ls = {
          lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = '@comment',
          },
          gopls = {
            -- By default, we render variable/function's type in the right most side,
            -- to make them not to crowd together with the original label.

            -- when true:
            -- foo             *Foo
            -- ast         "go/ast"

            -- when false:
            -- foo *Foo
            -- ast "go/ast"
            align_type_to_right = true,
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo". If align_type_to_right is
            -- true, this option has no effect.
            add_colon_before_type = false,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          -- for lsp_config or typescript-tools
          ts_ls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = '@comment',
          },
          vtsls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = '@comment',
          },
          ['rust-analyzer'] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = '@comment',
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = '@comment',
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- the hl group of leading dot of "•std::filesystem::permissions(..)"
            import_dot_hl = '@comment',
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          zls = {
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
          },
          roslyn = {
            extra_info_hl = '@comment',
          },
          dartls = {
            extra_info_hl = '@comment',
          },
          -- The same applies to pyright/pylance
          basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = '@comment',
          },
          -- If true, try to highlight "not supported" languages.
          fallback = true,
          -- this will be applied to label description for unsupport languages
          fallback_extra_info_hl = '@comment',
        },
        -- If the built-in logic fails to find a suitable highlight group for a label,
        -- this highlight is applied to the label.
        fallback_highlight = '@variable',
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. When set to a float
        -- between 0 and 1, it'll be treated as percentage of the width of
        -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
        -- Default 60.
        max_width = 60,
      })
    end,
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
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
          function(a, b)
            if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
              return
            end
            return b.client_name == 'i18nvim'
          end,
          -- default sorts
          'score',
          'sort_text',
        },
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          window = { max_width = 100, scrollbar = true },
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
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
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
      },
      cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
          },
        },
        keymap = {
          preset = 'none',

          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'cancel', 'fallback' },
          ['<C-y>'] = { 'select_and_accept' },
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
        },
        sources = function()
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
      },

      sources = {
        default = {
          'lazydev',
          'lsp',
          'path',
          'snippets',
          'buffer',
          'dadbod',
        },
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
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
  },
}
