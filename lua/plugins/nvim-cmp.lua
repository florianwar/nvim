return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'onsails/lspkind.nvim',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup({ paths = { vim.fn.stdpath('config') .. '/snippets/angular' } })

      local lspkind = require('lspkind')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered({
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
          }),
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          format = lspkind.cmp_format({
            maxwidth = 120,
            ellipsis_char = '...',
          }),
          expandable_indicator = true,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),

          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),

          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-CR>'] = cmp.mapping.confirm({ select = true }),

          --
          ['<C-Space>'] = cmp.mapping.complete({}),

          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      })
    end,
  },
}
