return {
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
        window = { border = 'rounded', max_width = 120, scrollbar = true },
      },
      list = {
        selection = function(ctx)
          return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
        end,
      },
      menu = {
        border = 'rounded',
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            return { pos[1] - 1, pos[2] - 1 }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height, 0 }
        end,
        draw = {
          gap = 1,
          align_to_component = 'label',
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'kind' },
          },
          components = {
            kind_icon = {
              text = function(item)
                local kind = require('lspkind').symbol_map[item.kind] or ''
                return kind .. ' '
              end,
              highlight = function(item)
                return 'CmpItemKind' .. item.kind
              end,
            },
            label = {
              width = { fill = true, max = 120 },
              text = function(ctx)
                return ctx.label .. ctx.label_detail
              end,
              highlight = function(ctx)
                -- label and label details
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and 'CmpItemAbbrDeprecated' or 'CmpItemAbbr' },
                }
                if ctx.label_detail then
                  table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = '@comment' })
                end

                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'CmpItemAbbrMatchFuzzy' })
                end

                return highlights
              end,
            },
            label_description = {
              width = {
                max = 40,
              },
              text = function(item)
                return item.label_description or ''
              end,
              highlight = function(item)
                return '@comment'
              end,
            },
            kind = {
              text = function(item)
                return item.kind
              end,
              highlight = function(item)
                return 'CmpItemKind' .. item.kind
              end,
            },
          },
        },
      },
    },

    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
      ['<C-j>'] = {
        function(cmp)
          return cmp.select_next()
        end,
        'snippet_forward',
        'fallback',
      },
      ['<C-k>'] = {
        function(cmp)
          return cmp.select_prev()
        end,
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
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      cmdline = function()
        local type = vim.fn.getcmdtype()
        if type == '/' or type == '?' then
          return { 'buffer' }
        end
        if type == ':' then
          return { 'cmdline' }
        end
        if type == '=' then
          return { 'lsp', 'buffer' }
        end

        return {}
      end,

      providers = {
        lsp = {
          min_keyword_length = 0,
          score_offset = 0,
        },
        path = {
          min_keyword_length = 0,
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
      },
    },
  },
}
