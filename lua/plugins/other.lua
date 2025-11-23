return {
  {
    'rgroli/other.nvim',
    keys = {
      { '<leader>rr', '<cmd>Other<cr>', desc = 'Other File' },
      { '<leader>rs', '<cmd>OtherSplit<cr>', desc = 'Other File (Split)' },
      { '<leader>rv', '<cmd>OtherVSplit<cr>', desc = 'Other File (VSplit)' },
      { '<leader>ra', '<cmd>OtherClear<cr><cmd>Other<cr>', desc = 'Other File (Alternative)' },
    },
    config = function()
      require('other-nvim').setup({
        mappings = {
          {
            pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*.ts$',
            target = {
              {
                target = '/%1/%2/%3.component.html',
                context = 'html',
              },
              {
                target = '/%1/%2/%3.service.ts',
                context = 'service',
              },
              {
                target = '/%1/%2/%3.component.scss',
                context = 'scss',
              },
              {
                target = '/%1/%2/%3.component.spec.ts',
                context = 'test',
              },
            },
          },
          {
            pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*html$',
            target = {
              {
                target = '/%1/%2/%3.component.ts',
                context = 'component',
              },
              {
                target = '/%1/%2/%3.component.scss',
                context = 'scss',
              },
              {
                target = '/%1/%2/%3.component.spec.ts',
                context = 'test',
              },
            },
          },
          {
            pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*scss$',
            target = {
              {
                target = '/%1/%2/%3.component.html',
                context = 'html',
              },
              {
                target = '/%1/%2/%3.component.ts',
                context = 'component',
              },
              {
                target = '/%1/%2/%3.component.spec.ts',
                context = 'test',
              },
            },
          },
          {
            pattern = '/(.*)/(.*)/([a-zA-Z-_]*).*spec.ts$',
            target = {
              {
                target = '/%1/%2/%3.component.html',
                context = 'html',
              },
              {
                target = '/%1/%2/%3.component.scss',
                context = 'scss',
              },
              {
                target = '/%1/%2/%3.component.ts',
                context = 'component',
              },
            },
          },
          {
            pattern = '/(.*)/(.*).service.ts$',
            target = {
              {
                target = '/%1/%2.service.spec.ts',
                context = 'test',
              },
              {
                target = '/%1/%2.component.ts',
                context = 'component',
              },
            },
          },
          {
            pattern = '/(.*)/(.*).service.spec.ts$',
            target = {
              {
                target = '/%1/%2.service.ts',
                context = 'service',
              },
            },
          },
        },
      })
    end,
  },
}
