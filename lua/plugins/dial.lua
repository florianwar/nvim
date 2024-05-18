return {
  {
    'monaqa/dial.nvim',
    keys = {
      {
        '<C-a>',
        function()
          require('dial.map').manipulate('increment', 'normal')
        end,
        silent = true,
        noremap = true,
        desc = 'Increment value',
      },
      {
        '<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'normal')
        end,
        silent = true,
        noremap = true,
        desc = 'Decrement value',
      },
    },
    config = function()
      local augend = require('dial.augend')
      local config = require('dial.config')

      config.augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.constant.new({ elements = { 'const', 'let' }, word = true, cyclic = true }),
          augend.constant.new({ elements = { '<', '<=', '>=', '>' }, word = true, cyclic = true }),
          augend.constant.new({ elements = { '&&', '||', '??' }, word = true, cyclic = true }),
        },
      })
    end,
  },
}
