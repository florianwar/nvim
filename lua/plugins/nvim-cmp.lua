return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = { 'rafamadriz/friendly-snippets' },
      },
      'onsails/lspkind.nvim',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. 'snippets/angular' } })
      luasnip.filetype_extend('htmlangular', { 'angular', 'html' })
      luasnip.filetype_extend('typescript', { 'javascript', 'typescript', 'angular' })

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
            mode = 'symbol_text',
            maxwidth = 80,
            symbol_map = {
              i18n = '',
            },
            menu = {
              luasnip = '[Snippet]',
              nvim_lsp = '[LSP]',
              path = '[Path]',
              i18nvim = '[I18Nvim]',
              lazydev = '[LazyDev]',
            },
            ellipsis_char = '...',
          }),
          expandable_indicator = true,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),

          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-CR>'] = cmp.mapping.confirm({ select = true }),

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
          { name = 'luasnip', option = { use_show_condition = false } },
          { name = 'nvim_lsp' },
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'i18nvim', group_index = 0 },
          { name = 'path' },
        },
      })
    end,
  },
}
